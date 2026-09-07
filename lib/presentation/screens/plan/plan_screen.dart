import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/plan_screen_providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';

/// Screen 11: Plan — the adaptive taper plan (report §14).
///
/// Shows the daily budget and phase, the two-sided "weeks to quit" estimate
/// (S3, linked to its explanation), the "Yeniden hesapladık" feed and the
/// quit-day confirmation once the budget reaches the final-week level.
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final planAsync = ref.watch(todayPlanProvider);
    final estimateAsync = ref.watch(quitEstimateProvider);
    final adjustmentsAsync = ref.watch(recentAdjustmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.planTitle),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            planAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(l10n.commonErrorTitle),
              data: (plan) => plan == null
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(l10n.todayEmptyFirstDay),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.todayRingLabel(0, plan.targetCount),
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plan.phase == PlanPhase.finalWeek
                                      ? l10n.finalWeekTitle
                                      : l10n.chartPlanVsActual,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                if (plan.phase == PlanPhase.finalWeek) ...[
                                  const SizedBox(height: 8),
                                  Text(l10n.finalWeekBody),
                                  const SizedBox(height: 12),
                                  FilledButton(
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
                                                          context)
                                                      .formatMediumDate(day),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(l10n.quitDayConfirmTitle),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            estimateAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (estimate) => estimate == null
                  ? const SizedBox.shrink()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.planWeeksEstimate(
                                estimate.minWeeks,
                                estimate.maxWeeks,
                              ),
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
            const SizedBox(height: 16),
            adjustmentsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (adjustments) => adjustments.isEmpty
                  ? const SizedBox.shrink()
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.recalcTitle,
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            for (final a in adjustments.take(5))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.refresh, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        switch (a.messageKey) {
                                          'clustered' => l10n.recalcBunched,
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
