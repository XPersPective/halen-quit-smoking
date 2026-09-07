import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/stats_providers.dart';
import 'package:halen/domain/motivation.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';
import 'package:halen/presentation/widgets/stats_charts.dart';

/// Screen 12: Statistics — daily count vs plan, hourly pattern, savings.
///
/// v1 shows the last 7 days (the free-tier range); the full-range gating is
/// wired in the purchase phase. Charts always carry spoken summaries.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final daily = ref.watch(dailyStatsProvider(7));
    final hourly = ref.watch(hourlyHistogramProvider);
    final savings = ref.watch(totalSavingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            daily.when(
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text(l10n.commonErrorTitle),
              data: (stats) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.chartDaily, style: theme.textTheme.titleMedium),
                      Text(l10n.chartPlanVsActual,
                          style: theme.textTheme.bodySmall),
                      const SizedBox(height: 12),
                      DailyBarsChart(
                        counts: [for (final s in stats) s.count],
                        planTargets: [for (final s in stats) s.planTarget],
                        barColor: theme.colorScheme.primary,
                        markerColor: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(height: 8),
                      Semantics(
                        label: l10n.a11yDailyChartSummary(
                          stats.length >= 2 ? stats[stats.length - 2].count : 0,
                          stats.isNotEmpty ? (stats.last.planTarget ?? 0) : 0,
                          (((stats.isNotEmpty ? stats.last.adherence : null) ??
                                      1.0) *
                                  100)
                              .round(),
                        ),
                        child: Text(
                          l10n.chartDaily,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            hourly.when(
              loading: () => const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text(l10n.commonErrorTitle),
              data: (histogram) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.chartHourly,
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      HourlyBarsChart(
                        histogram: histogram,
                        barColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            savings.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text(l10n.commonErrorTitle),
              data: (total) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.savings_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          label: l10n.a11ySavingsChart,
                          child: Text(
                            '${l10n.chartSavings}: ${total.toStringAsFixed(0)}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Motivation strip (report §16): on-plan streaks — a broken
            // streak is never shown as zero; the longest run stands.
            daily.maybeWhen(
              data: (stats) {
                final streaks = computeStreaks([
                  for (final s in stats) DayAdherence(count: s.count, planTarget: s.planTarget),
                ]);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(streaks.isBroken
                              ? l10n.motivationStreakRestart
                              : l10n.motivationStreakBest(streaks.displayDays)),
                        ),
                      ],
                    ),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
