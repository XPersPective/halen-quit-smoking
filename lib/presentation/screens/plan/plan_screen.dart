import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/application/plan_screen_providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/application/module_providers.dart';
import 'package:halen/application/taper_controller.dart';
import 'package:halen/domain/soft_taper.dart';
import 'package:halen/domain/plan_kinds.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';
import '../../../core/design/tokens.dart';

/// Screen 11: Plan — the adaptive taper plan (report §14). Premium feature:
/// the free tier sees a locked card (records/savings stay free forever,
/// report §28), the trial and lifetime see the full engine.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final premium = ref.watch(isPremiumProvider);
    final planAsync = ref.watch(todayPlanProvider);
    final estimateAsync = ref.watch(quitEstimateProvider);
    final adjustmentsAsync = ref.watch(recentAdjustmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.planTitle),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: !premium
            ? ListView(
                padding: const EdgeInsets.all(HalenSpace.x6),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(HalenSpace.x5),
                      child: Column(
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: theme.colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(height: HalenSpace.x3),
                          Text(
                            l10n.todayPlanLockedFree,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: HalenSpace.x4),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.paywall),
                            child: Text(l10n.commonUnlockPremium),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(HalenSpace.x6),
                children: [
                  // Module report §13 — the plan strip: the user should never
                  // have to ask which plan they are on, and switching is
                  // always reachable (deliberate, not locked).
                  const _PlanStrip(),
                  const SizedBox(height: HalenSpace.x2),
                  // Module report §9 — what the taper engine decided today,
                  // in the user's own words. Holding a step is stated as a
                  // choice, never as a failure.
                  const _TaperNote(),
                  const SizedBox(height: HalenSpace.x4),
                  planAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(l10n.commonErrorTitle),
                    data: (plan) => plan == null
                        ? Card(
                            child: Padding(
                              padding: const EdgeInsets.all(HalenSpace.x5),
                              child: Text(
                                l10n.todayEmptyFirstDay,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(HalenSpace.x6),
                            decoration: HalenCard.hero(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(HalenSpace.x2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.14,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.track_changes_rounded,
                                        color: HalenColors.mint,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: HalenSpace.x3),
                                    Expanded(
                                      child: Text(
                                        plan.phase == PlanPhase.finalWeek
                                            ? l10n.finalWeekTitle
                                            : l10n.chartPlanVsActual,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                          color: HalenColors.mint,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: HalenSpace.x5),
                                Text(
                                  l10n.todayRingLabel(0, plan.targetCount),
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (plan.phase == PlanPhase.finalWeek) ...[
                                  const SizedBox(height: HalenSpace.x3),
                                  Text(
                                    l10n.finalWeekBody,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFFD6E8DB),
                                    ),
                                  ),
                                  const SizedBox(height: HalenSpace.x4),
                                  FilledButton.icon(
                                    onPressed: () async {
                                      final day = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 30)),
                                      );
                                      if (day != null && context.mounted) {
                                        await ref
                                            .read(planScreenControllerProvider)
                                            .confirmQuitDay(day);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l10n.quitDaySet(
                                                  MaterialLocalizations.of(
                                                        context,
                                                  )
                                                      .formatMediumDate(day),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.event_available),
                                    label: Text(l10n.quitDayConfirmTitle),
                                  ),
                                ],
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: HalenSpace.x4),
                  estimateAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (estimate) => estimate == null
                        ? const SizedBox.shrink()
                        : Card(
                            child: Padding(
                              padding: const EdgeInsets.all(HalenSpace.x5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.planWeeksEstimate(
                                      estimate.minWeeks,
                                      estimate.maxWeeks,
                                    ),
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(l10n.commonModelTag,
                                          style: theme.textTheme.labelSmall),
                                      IconButton(
                                        tooltip: l10n.commonHowCalculated,
                                        icon: const Icon(Icons.help_outline,
                                            size: 18),
                                        onPressed: () => Navigator.pushNamed(
                                            context, Routes.howCalculated),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: HalenSpace.x4),
                  adjustmentsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (adjustments) => adjustments.isEmpty
                        ? const SizedBox.shrink()
                        : Card(
                            child: Padding(
                              padding: const EdgeInsets.all(HalenSpace.x5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.recalcTitle,
                                      style: theme.textTheme.titleMedium),
                                  const SizedBox(height: HalenSpace.x2),
                                  for (final a in adjustments.take(5))
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.refresh_rounded,
                                            size: 18,
                                            color:
                                                theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: HalenSpace.x2),
                                          Expanded(
                                            child: Text(
                                              switch (a.messageKey) {
                                                'clustered' =>
                                                  l10n.recalcBunched,
                                                'recalculated' =>
                                                  l10n.recalcDistributed,
                                                'tempo_extended' =>
                                                  l10n.tempoAutoAdjusted,
                                                _ => l10n.recalcDistributed,
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: HalenSpace.x6),
                ],
              ),
      ),
    );
  }
}


/// Which plan is running, and the way into changing it (module report §13).
class _PlanStrip extends ConsumerWidget {
  const _PlanStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(planStateProvider).value;
    final kind = state?.kind ?? PlanKind.gradualTaper;
    final week = state == null
        ? 1
        : DateTime.now().difference(state.startedAt).inDays ~/ 7 + 1;
    final name = switch (kind) {
      PlanKind.gradualTaper => l10n.planKindGradual,
      PlanKind.dailyQuota => l10n.planKindQuota,
      PlanKind.quitDay => l10n.planKindQuitDay,
      PlanKind.trackOnly => l10n.planKindTrackOnly,
    };

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.planStripLabel(name, week),
            style: theme.textTheme.labelLarge,
          ),
        ),
        TextButton.icon(
          onPressed: () => Navigator.pushNamed(context, Routes.planSwitch),
          icon: const Icon(Icons.swap_horiz_rounded, size: 18),
          label: Text(l10n.planSwitchTitle),
        ),
      ],
    );
  }
}


/// Today's soft-taper decision (module report §9).
class _TaperNote extends ConsumerWidget {
  const _TaperNote();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final step = ref.watch(dailyTaperStepProvider).value;
    if (step == null) {
      return const SizedBox.shrink();
    }
    final text = switch (step.decision) {
      TaperDecision.advance => l10n.taperAdvance(step.intervalMinutes),
      TaperDecision.holdShortStep ||
      TaperDecision.holdLowAdherence =>
        l10n.taperHoldStep,
      TaperDecision.atTarget => l10n.taperAdvance(step.intervalMinutes),
    };
    final detail = ref.watch(taperPlanDetailProvider).value;
    final kind = ref.watch(planStateProvider).value?.kind;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.timelapse_rounded, size: 18),
            const SizedBox(width: HalenSpace.x2),
            Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
          ],
        ),
        if (detail != null && detail.hours.isNotEmpty) ...[
          const SizedBox(height: HalenSpace.x1),
          Text(
            '${l10n.taperEasiestFirst} '
            '(${detail.hours.take(3).map((h) => '$h:00').join(', ')})',
            style: theme.textTheme.labelSmall,
          ),
        ],
        if (detail != null && kind == PlanKind.dailyQuota) ...[
          const SizedBox(height: HalenSpace.x1),
          Text(
            l10n.planQuotaToday(detail.ceiling),
            style: theme.textTheme.labelMedium,
          ),
        ],
      ],
    );
  }
}
