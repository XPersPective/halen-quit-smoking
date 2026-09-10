import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/dates.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../domain/cessation.dart';
import '../../../domain/entities.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';
import '../../widgets/entrance.dart';
import 'coping_plan_sheet.dart';
import 'mood_check_sheet.dart';

/// The quit attempt, in one place (premium brief §C.2, §C.4, §C.6).
///
/// Five things, in the order the guidelines put them: a date, the reason in
/// the person's own words, the medicines, a plan for the situations that
/// break attempts, and one other human who knows. Every one of them is
/// optional and none of them gate anything — an app that blocks the log
/// button until you fill in a form is an app people delete.
class QuitPlanScreen extends ConsumerWidget {
  const QuitPlanScreen({super.key});

  static const _totalSteps = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final state = ref.watch(cessationStateProvider).value ??
        const CessationState();
    final done = state.readinessSteps(totalSteps: _totalSteps);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quitPlanTitle)),
      body: ListView(
        padding: HalenSpace.screen,
        children: [
          Text(l10n.quitPlanSubtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: HalenSpace.x3),
          _ReadinessBar(done: done, total: _totalSteps),
          const SizedBox(height: HalenSpace.x6),

          Entrance(child: _QuitDateCard(state: state)),
          const SizedBox(height: HalenSpace.x4),
          Entrance(index: 1, child: _ReasonCard(state: state, locale: locale)),
          const SizedBox(height: HalenSpace.x4),
          const Entrance(index: 2, child: _MedicinesCard()),
          const SizedBox(height: HalenSpace.x4),
          Entrance(index: 3, child: _CopingCard(state: state)),
          const SizedBox(height: HalenSpace.x4),
          Entrance(index: 4, child: _SupportCard(state: state)),
          const SizedBox(height: HalenSpace.x4),
          Entrance(index: 5, child: _NotAPuffCard(state: state)),
          const SizedBox(height: HalenSpace.x4),
          const Entrance(index: 6, child: _MoodCard()),
        ],
      ),
    );
  }
}

/// How much of the plan is in place. A progress bar rather than a checklist
/// of red crosses: nothing here is a failure to have not done yet.
class _ReadinessBar extends StatelessWidget {
  const _ReadinessBar({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quitPlanReadiness(total, done),
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: HalenSpace.x2),
        ClipRRect(
          borderRadius: HalenRadius.smallAll,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: total == 0 ? 0 : done / total),
            duration: HalenDuration.respecting(context, HalenDuration.slow),
            curve: HalenCurves.settle,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: DataRole.progress.containerOf(context),
              valueColor: AlwaysStoppedAnimation<Color>(
                DataRole.progress.of(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuitDateCard extends ConsumerWidget {
  const _QuitDateCard({required this.state});

  final CessationState state;

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.quitDate ??
          now.add(const Duration(days: QuitDateGuidance.suggestedDays)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked == null) {
      return;
    }
    await ref.read(cessationControllerProvider).setQuitDate(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final date = state.quitDate;
    final days = date == null
        ? null
        : QuitDateGuidance.daysUntil(DateTime.now(), date);

    String when() {
      if (days == null) {
        return l10n.quitDateNone;
      }
      if (days == 0) {
        return l10n.quitDateToday;
      }
      if (days == 1) {
        return l10n.quitDateTomorrow;
      }
      return days > 0 ? l10n.quitDateIn(days) : l10n.quitDatePassed(-days);
    }

    // The two notes that matter, and only when they apply: too close to
    // prepare, or so far away that the date stops being a commitment.
    String? note;
    if (days != null && days > 0 && days < QuitDateGuidance.minPreparationDays) {
      note = l10n.quitDateTooSoonNote;
    } else if (days != null && days > QuitDateGuidance.maxUsefulDays) {
      note = l10n.quitDateTooFarNote;
    }

    return HalenCard(
      emphasis: CardEmphasis.raised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.quitDateTitle,
            subtitle: l10n.quitDateWhy,
          ),
          const SizedBox(height: HalenSpace.x4),
          HalenStat(
            label: l10n.quitDateTitle,
            value: when(),
            color: DataRole.progress.of(context),
            large: true,
            caption: date == null ? null : dayKey(date),
          ),
          if (note != null) ...[
            const SizedBox(height: HalenSpace.x3),
            Text(note, style: theme.textTheme.bodySmall),
          ],
          if (state.quitDateMoves > 0) ...[
            const SizedBox(height: HalenSpace.x2),
            Text(
              l10n.quitDateMovedNote(state.quitDateMoves),
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: HalenSpace.x3),
          Row(
            children: [
              FilledButton(
                onPressed: () => _pick(context, ref),
                child: Text(
                  date == null ? l10n.quitDateSet : l10n.quitDateChange,
                ),
              ),
              if (date != null) ...[
                const SizedBox(width: HalenSpace.x2),
                TextButton(
                  onPressed: () =>
                      ref.read(cessationControllerProvider).setQuitDate(null),
                  child: Text(l10n.quitDateClear),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends ConsumerWidget {
  const _ReasonCard({required this.state, required this.locale});

  final CessationState state;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.obWhyTitle,
            subtitle: l10n.obWhyHint,
          ),
          const SizedBox(height: HalenSpace.x3),
          Wrap(
            spacing: HalenSpace.x2,
            runSpacing: HalenSpace.x2,
            children: [
              for (final reason in QuitReason.values)
                ChoiceChip(
                  label: Text(quitReasonLabel(reason, l10n)),
                  selected: state.reason == reason,
                  onSelected: (selected) => ref
                      .read(cessationControllerProvider)
                      .setReason(selected ? reason : null),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicinesCard extends ConsumerWidget {
  const _MedicinesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return HalenCard(
      onTap: () => Navigator.of(context).pushNamed(Routes.medicines),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.medicinesTitle,
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.medicinesLead, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _CopingCard extends ConsumerWidget {
  const _CopingCard({required this.state});

  final CessationState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final written = state.copingPlans.where((p) => !p.isEmpty).toList();
    return HalenCard(
      onTap: () => showCopingPlanSheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.copingTitle,
            subtitle: l10n.copingLead,
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: HalenSpace.x3),
          if (written.isEmpty)
            Text(l10n.copingEmpty, style: theme.textTheme.bodySmall)
          else
            Wrap(
              spacing: HalenSpace.x2,
              runSpacing: HalenSpace.x2,
              children: [
                for (final plan in written)
                  HalenPill(
                    label: triggerLabelText(plan.trigger, l10n),
                    color: DataRole.progress.of(context),
                    icon: Icons.check_rounded,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SupportCard extends ConsumerStatefulWidget {
  const _SupportCard({required this.state});

  final CessationState state;

  @override
  ConsumerState<_SupportCard> createState() => _SupportCardState();
}

class _SupportCardState extends ConsumerState<_SupportCard> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.state.supportPerson ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final quitDate = widget.state.quitDate;
    final draft = l10n.supportPersonDraft(
      quitDate == null ? l10n.quitDateToday : dayKey(quitDate),
    );

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.supportPersonTitle,
            subtitle: l10n.supportPersonBody,
          ),
          const SizedBox(height: HalenSpace.x3),
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: l10n.supportPersonHint),
            textInputAction: TextInputAction.done,
            onSubmitted: (value) =>
                ref.read(cessationControllerProvider).setSupportPerson(value),
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
              ref
                  .read(cessationControllerProvider)
                  .setSupportPerson(_controller.text);
            },
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(draft, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x2),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(l10n.supportPersonCopy),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: draft));
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.supportPersonCopied)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotAPuffCard extends ConsumerWidget {
  const _NotAPuffCard({required this.state});

  final CessationState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: l10n.notAPuffTitle),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.notAPuffBody, style: theme.textTheme.bodyMedium),
          const SizedBox(height: HalenSpace.x3),
          if (state.notAPuffAccepted)
            HalenPill(
              label: l10n.notAPuffTaken,
              color: DataRole.progress.of(context),
              icon: Icons.check_rounded,
            )
          else
            FilledButton.tonal(
              onPressed: () => ref
                  .read(cessationControllerProvider)
                  .acceptNotAPuffRule(accepted: true),
              child: Text(l10n.notAPuffAccept),
            ),
        ],
      ),
    );
  }
}

class _MoodCard extends ConsumerWidget {
  const _MoodCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return HalenCard(
      emphasis: CardEmphasis.quiet,
      onTap: () => showMoodCheckSheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.moodCheckTitle,
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.moodCheckWhy, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// The reason, in the user's language. Kept here so every screen that shows
/// it back to them — the plan, quit day, the craving sheet — says it the
/// same way.
String quitReasonLabel(QuitReason reason, AppLocalizations l10n) =>
    switch (reason) {
      QuitReason.children => l10n.reasonChildren,
      QuitReason.health => l10n.reasonHealth,
      QuitReason.money => l10n.reasonMoney,
      QuitReason.freedom => l10n.reasonFreedom,
      QuitReason.smell => l10n.reasonSmell,
      QuitReason.fitness => l10n.reasonFitness,
      QuitReason.someoneAsked => l10n.reasonSomeoneAsked,
    };

/// Trigger names, shared with the coping-plan sheet.
String triggerLabelText(TriggerLabel label, AppLocalizations l10n) =>
    switch (label) {
      TriggerLabel.coffee => l10n.triggerCoffee,
      TriggerLabel.afterMeal => l10n.triggerAfterMeal,
      TriggerLabel.stress => l10n.triggerStress,
      TriggerLabel.alcohol => l10n.triggerAlcohol,
      TriggerLabel.car => l10n.triggerCar,
      TriggerLabel.social => l10n.triggerSocial,
      TriggerLabel.workBreak => l10n.triggerWorkBreak,
      TriggerLabel.beforeSleep => l10n.triggerBeforeSleep,
      TriggerLabel.wakeUp => l10n.triggerWakeUp,
    };
