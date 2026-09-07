import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/onboarding_controller.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/choice_card.dart';

/// Screens 2–8: the seven-step onboarding (<90 s, no account, report §11).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _step = 0;

  static const _stepCount = 7;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
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
      _pageController.nextPage(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
      setState(() => _step += 1);
      return;
    }

    await controller.submit();
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, Routes.today);
  }

  void _back() {
    if (_step == 0) {
      Navigator.maybePop(context);
      return;
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
    setState(() => _step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.obStepOf(_step + 1)),
        leading: BackButton(onPressed: _back),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _AgeStep(),
                  _DailyCountStep(),
                  _TtfcStep(),
                  _PriceStep(),
                  _TriggersStep(),
                  _GoalStep(),
                  _BrandStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _back,
                      child: Text(l10n.commonBack),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onTertiary,
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: theme.textTheme.headlineSmall),
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(hint!, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: 24),
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
          const SizedBox(height: 16),
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
    _priceController =
        TextEditingController(text: answers.pricePerPack.toStringAsFixed(2));
    _packSizeController =
        TextEditingController(text: answers.packSize.toString());
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
          TextField(
            controller: _priceController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: l10n.obPriceTitle,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) =>
                controller.setPricePerPack(double.tryParse(v.replaceAll(',', '.')) ?? 0),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _packSizeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.obPackSizeLabel,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => controller.setPackSize(int.tryParse(v) ?? 20),
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
          const SizedBox(height: 8),
          ChoiceCard(
            title: l10n.obGoalQuitNow,
            subtitle: l10n.obGoalQuitNowHint,
            selected: answers.targetMode == TargetMode.quitNow,
            onTap: () => controller.setTargetMode(TargetMode.quitNow),
          ),
          const SizedBox(height: 8),
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
          TextField(
            controller: _brandController,
            decoration: InputDecoration(
              labelText: l10n.obBrandTitle,
              border: const OutlineInputBorder(),
            ),
            onChanged: (v) => controller.setBrandName(v.isEmpty ? null : v),
          ),
          const SizedBox(height: 24),
          // Final medical disclaimer (report §13/§39) — shown at the end of
          // onboarding, before the plan is created.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.obFinalDisclaimer,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(l10n.obDataNote, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
