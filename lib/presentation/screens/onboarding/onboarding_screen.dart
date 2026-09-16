import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/onboarding_controller.dart';
import 'package:halen/core/design/tokens.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/domain/cessation.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/onboarding.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/cessation/quit_plan_screen.dart'
    show quitReasonLabel;
import 'package:halen/presentation/widgets/choice_card.dart';

/// Screens 2–9: the eight-step onboarding (<90 s, no account, report §11).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _step = 0;
  final _priceForm = GlobalKey<FormState>();
  final _brandForm = GlobalKey<FormState>();
  bool _busy = false;

  // Eight now: the reason a person gives in their own words is the
  // motivational-interviewing step the flow was missing, and it is the one
  // the app plays back at the moment of a craving (premium brief §C.7).
  static const _stepCount = 8;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_busy) return;
    if (_step == 3 && !(_priceForm.currentState?.validate() ?? false)) return;
    if (_step == 7 && !(_brandForm.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      final controller = ref.read(onboardingControllerProvider.notifier);
      final answers = ref.read(onboardingControllerProvider);

      if (_step == 0 && answers.ageBand == AgeBand.under18) {
        // Report §39: no plan for under-18; youth resources instead.
        await controller.submitUnder18();
        if (!mounted) {
          return;
        }
        Navigator.pushReplacementNamed(context, Routes.under18);
        return;
      }

      if (_step < _stepCount - 1) {
        await _pageController.nextPage(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
        );
        if (!mounted) return;
        setState(() => _step += 1);
        return;
      }

      await controller.submit();
      if (!mounted) {
        return;
      }
      // Straight to the payoff, not to an empty Today. The person has just
      // spent a minute answering questions; the first thing they see has to
      // be what those answers bought them (premium brief §A.1).
      Navigator.pushReplacementNamed(context, Routes.onboardingResult);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.commonErrorTitle),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _back() async {
    if (_busy) return;
    if (_step == 0) {
      Navigator.maybePop(context);
      return;
    }
    setState(() => _busy = true);
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
    if (!mounted) return;
    setState(() {
      _step -= 1;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.obStepOf(_step + 1, _stepCount)),
        leading: BackButton(onPressed: _back),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: Semantics(
                label: l10n.obStepOf(_step + 1, _stepCount),
                child: Row(
                  children: [
                    for (var i = 0; i < _stepCount; i++)
                      Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: HalenSpace.x1,
                          ),
                          decoration: BoxDecoration(
                            color: i <= _step
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const _AgeStep(),
                  const _DailyCountStep(),
                  const _TtfcStep(),
                  Form(key: _priceForm, child: const _PriceStep()),
                  const _TriggersStep(),
                  const _GoalStep(),
                  const _WhyStep(),
                  Form(key: _brandForm, child: const _BrandStep()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(HalenSpace.x4),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _back,
                      child: Text(l10n.commonBack),
                    ),
                  ),
                  const SizedBox(width: HalenSpace.x4),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _busy ? null : _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .onTertiary,
                      ),
                      child: Text(
                        _step == _stepCount - 1
                            ? l10n.obFinish
                            : l10n.commonNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.title, required this.child, this.hint});

  final String title;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(HalenSpace.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: theme.textTheme.headlineSmall),
          if (hint != null) ...[
            const SizedBox(height: HalenSpace.x2),
            Text(hint!, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: HalenSpace.x6),
          child,
        ],
      ),
    );
  }
}

class _AgeStep extends ConsumerWidget {
  const _AgeStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final answers = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final bands = {
      AgeBand.under18: l10n.obAgeUnder18,
      AgeBand.y18to24: l10n.obAge18to24,
      AgeBand.y25to34: l10n.obAge25to34,
      AgeBand.y35to44: l10n.obAge35to44,
      AgeBand.y45to54: l10n.obAge45to54,
      AgeBand.y55plus: l10n.obAge55plus,
    };
    return _StepScaffold(
      title: l10n.obAgeTitle,
      hint: answers.ageBand == AgeBand.under18 ? l10n.obUnder18Notice : null,
      child: Column(
        children: [
          for (final entry in bands.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ChoiceCard(
                title: entry.value,
                selected: answers.ageBand == entry.key,
                onTap: () => controller.setAgeBand(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyCountStep extends ConsumerWidget {
  const _DailyCountStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final answers = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    return _StepScaffold(
      title: l10n.obCpdTitle,
      hint: l10n.obCpdHint,
      child: Column(
        children: [
          Text(
            '${answers.baselineCpd}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: HalenSpace.x4),
          Slider(
            value: answers.baselineCpd.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: '${answers.baselineCpd}',
            onChanged: (v) => controller.setBaseline(v.round()),
          ),
        ],
      ),
    );
  }
}

class _TtfcStep extends ConsumerWidget {
  const _TtfcStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final answers = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final bands = {
      TtfcBand.under5: l10n.obTtfcUnder5,
      TtfcBand.five30: l10n.obTtfc5to30,
      TtfcBand.thirtyOne60: l10n.obTtfc31to60,
      TtfcBand.over60: l10n.obTtfcOver60,
    };
    return _StepScaffold(
      title: l10n.obTtfcTitle,
      child: Column(
        children: [
          for (final entry in bands.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ChoiceCard(
                title: entry.value,
                selected: answers.ttfcBand == entry.key,
                onTap: () => controller.setTtfc(entry.key),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceStep extends ConsumerStatefulWidget {
  const _PriceStep();

  @override
  ConsumerState<_PriceStep> createState() => _PriceStepState();
}

class _PriceStepState extends ConsumerState<_PriceStep> {
  late final TextEditingController _priceController;
  late final TextEditingController _packSizeController;

  @override
  void initState() {
    super.initState();
    final answers = ref.read(onboardingControllerProvider);
    _priceController = TextEditingController(
      text: answers.pricePerPack > 0
          ? answers.pricePerPack.toStringAsFixed(2)
          : '',
    );
    _packSizeController = TextEditingController(
      text: answers.packSize.toString(),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _packSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(onboardingControllerProvider.notifier);
    return _StepScaffold(
      title: l10n.obPriceTitle,
      hint: l10n.obPriceHint,
      child: Column(
        children: [
          TextFormField(
            controller: _priceController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => OnboardingAnswers.parsePrice(v ?? '') == null
                ? '${l10n.obPriceTitle} (0 < … ≤ 1,000,000)'
                : null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.obPriceTitle,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => controller.setPricePerPack(
              OnboardingAnswers.parsePrice(v) ?? 0,
            ),
          ),
          const SizedBox(height: HalenSpace.x4),
          TextFormField(
            controller: _packSizeController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) => OnboardingAnswers.parsePackSize(v ?? '') == null
                ? '${l10n.obPackSizeLabel}: 1–100'
                : null,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.obPackSizeLabel,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) =>
                controller.setPackSize(OnboardingAnswers.parsePackSize(v) ?? 0),
          ),
        ],
      ),
    );
  }
}

class _TriggersStep extends ConsumerWidget {
  const _TriggersStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final answers = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final labels = {
      TriggerLabel.coffee: l10n.triggerCoffee,
      TriggerLabel.afterMeal: l10n.triggerAfterMeal,
      TriggerLabel.stress: l10n.triggerStress,
      TriggerLabel.alcohol: l10n.triggerAlcohol,
      TriggerLabel.car: l10n.triggerCar,
      TriggerLabel.social: l10n.triggerSocial,
      TriggerLabel.workBreak: l10n.triggerWorkBreak,
      TriggerLabel.beforeSleep: l10n.triggerBeforeSleep,
      TriggerLabel.wakeUp: l10n.triggerWakeUp,
    };
    return _StepScaffold(
      title: l10n.obTimesTitle,
      hint: l10n.obTimesHint,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final entry in labels.entries)
            FilterChip(
              label: Text(entry.value),
              selected: answers.triggers.contains(entry.key),
              onSelected: (_) => controller.toggleTrigger(entry.key),
              showCheckmark: true,
            ),
        ],
      ),
    );
  }
}

class _GoalStep extends ConsumerWidget {
  const _GoalStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final answers = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    return _StepScaffold(
      title: l10n.obGoalTitle,
      child: Column(
        children: [
          ChoiceCard(
            title: l10n.obGoalReduce,
            subtitle: l10n.obGoalReduceHint,
            selected: answers.targetMode == TargetMode.reduce,
            onTap: () => controller.setTargetMode(TargetMode.reduce),
          ),
          const SizedBox(height: HalenSpace.x2),
          ChoiceCard(
            title: l10n.obGoalQuitNow,
            subtitle: l10n.obGoalQuitNowHint,
            selected: answers.targetMode == TargetMode.quitNow,
            onTap: () => controller.setTargetMode(TargetMode.quitNow),
          ),
          const SizedBox(height: HalenSpace.x2),
          ChoiceCard(
            title: l10n.obGoalUndecided,
            subtitle: l10n.obGoalUndecidedHint,
            selected: answers.targetMode == TargetMode.undecided,
            onTap: () => controller.setTargetMode(TargetMode.undecided),
          ),
        ],
      ),
    );
  }
}

/// Why, in the person's own words (premium brief §C.7).
///
/// A reason someone states themselves outperforms a reason the app supplies,
/// which is the whole basis of motivational interviewing. It is stored on the
/// quit plan and shown back on quit day and inside a craving.
class _WhyStep extends ConsumerWidget {
  const _WhyStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(onboardingControllerProvider).quitReason;
    final controller = ref.read(onboardingControllerProvider.notifier);
    return _StepScaffold(
      title: l10n.obWhyTitle,
      hint: l10n.obWhyHint,
      child: Wrap(
        spacing: HalenSpace.x2,
        runSpacing: HalenSpace.x2,
        children: [
          for (final reason in QuitReason.values)
            ChoiceChip(
              label: Text(quitReasonLabel(reason, l10n)),
              selected: selected == reason,
              onSelected: (isSelected) =>
                  controller.setQuitReason(isSelected ? reason : null),
            ),
        ],
      ),
    );
  }
}

class _BrandStep extends ConsumerStatefulWidget {
  const _BrandStep();

  @override
  ConsumerState<_BrandStep> createState() => _BrandStepState();
}

class _BrandStepState extends ConsumerState<_BrandStep> {
  late final TextEditingController _brandController;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(
      text: ref.read(onboardingControllerProvider).brandName ?? '',
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final controller = ref.read(onboardingControllerProvider.notifier);
    return _StepScaffold(
      title: l10n.obBrandTitle,
      hint: l10n.obBrandHint,
      child: Column(
        children: [
          TextFormField(
            controller: _brandController,
            maxLength: 100,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (v) =>
                (v?.trim().isEmpty ?? true) || v!.trim().length > 100
                ? l10n.obBrandHint
                : null,
            decoration: InputDecoration(
              labelText: l10n.obBrandTitle,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => controller.setBrandName(v.isEmpty ? null : v),
          ),
          const SizedBox(height: HalenSpace.x6),
          // Final medical disclaimer (report §13/§39) — shown at the end of
          // onboarding, before the plan is created.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(HalenSpace.x4),
              child: Text(
                l10n.obFinalDisclaimer,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.obDataNote, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
