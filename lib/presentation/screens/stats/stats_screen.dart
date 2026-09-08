import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/interval_providers.dart';
import 'package:halen/application/stats_providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/domain/motivation.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';
import 'package:halen/presentation/widgets/charts/hourly_distribution_chart.dart';
import 'package:halen/presentation/widgets/charts/interval_chart.dart';
import 'package:halen/presentation/widgets/charts/trigger_breakdown_chart.dart';
import 'package:halen/presentation/widgets/stats_charts.dart';

/// Screen 12: Statistics & Analytics Hub.
///
/// Features 4 rich views: Daily Trend, 24-Hour Distribution, Inter-Cigarette
/// Intervals, and Triggers Breakdown.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedTabIndex = 0;

  String _dayLabel(String dateKey) {
    try {
      final dt = DateTime.parse(dateKey);
      const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
      return days[(dt.weekday - 1) % 7];
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final daily = ref.watch(dailyStatsProvider(7));
    final savings = ref.watch(totalSavingsProvider);
    final hourlyReportAsync = ref.watch(hourlyAnalyticsProvider);
    final intervalsReportAsync = ref.watch(todayIntervalsProvider);
    final triggersAsync = ref.watch(triggerAnalyticsProvider);

    final tabs = [
      l10n.statsTabDaily,
      l10n.statsTabHourly,
      l10n.statsTabIntervals,
      l10n.statsTabTriggers,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.statsTitle,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Segmented tabs control
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? HalenColors.surfaceElevatedDark
                    : HalenColors.surfaceElevatedLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Row(
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTabIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == i
                                ? theme.colorScheme.surface
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _selectedTabIndex == i
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              tabs[i],
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: _selectedTabIndex == i
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: _selectedTabIndex == i
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Tab 0: Daily Trends
            if (_selectedTabIndex == 0) ...[
              daily.when(
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(l10n.commonErrorTitle),
                data: (stats) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.chartDaily,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.chartPlanVsActual,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? HalenColors.textSecondaryDark
                                        : HalenColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        DailyBarsChart(
                          counts: [for (final s in stats) s.count],
                          planTargets: [for (final s in stats) s.planTarget],
                          dayLabels: [for (final s in stats) _dayLabel(s.dateKey)],
                          barColor: theme.colorScheme.primary,
                          markerColor: HalenColors.amberCta,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Gerçekleşen',
                              style: theme.textTheme.labelSmall,
                            ),
                            const SizedBox(width: 18),
                            Container(
                              width: 12,
                              height: 3,
                              color: HalenColors.amberCta,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Plan Hedefi',
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Streak strip
              daily.maybeWhen(
                data: (stats) {
                  final streaks = computeStreaks([
                    for (final s in stats)
                      DayAdherence(count: s.count, planTarget: s.planTarget),
                  ]);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: HalenColors.amberCta.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_fire_department_rounded,
                              color: HalenColors.amberCta,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              streaks.isBroken
                                  ? l10n.motivationStreakRestart
                                  : l10n.motivationStreakBest(streaks.displayDays),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],

            // Tab 1: 24h Hourly Distribution
            if (_selectedTabIndex == 1) ...[
              hourlyReportAsync.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(l10n.commonErrorTitle),
                data: (report) => HourlyDistributionCard(report: report),
              ),
            ],

            // Tab 2: Intervals between cigarettes
            if (_selectedTabIndex == 2) ...[
              intervalsReportAsync.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(l10n.commonErrorTitle),
                data: (report) => IntervalChartCard(report: report),
              ),
            ],

            // Tab 3: Triggers
            if (_selectedTabIndex == 3) ...[
              triggersAsync.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text(l10n.commonErrorTitle),
                data: (triggers) => TriggerBreakdownCard(triggers: triggers),
              ),
            ],

            const SizedBox(height: 14),

            // Total Savings Card
            savings.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text(l10n.commonErrorTitle),
              data: (total) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: HalenColors.emerald.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.savings_rounded,
                          color: HalenColors.emerald,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.chartSavings,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? HalenColors.textSecondaryDark
                                    : HalenColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(0)} ₺',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: HalenColors.emerald,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, Routes.healthTimeline),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(60, 36),
                        ),
                        child: const Text('Sağlık Zamanı'),
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
