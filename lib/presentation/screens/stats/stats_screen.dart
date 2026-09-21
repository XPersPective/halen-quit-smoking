import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/domain/ad_policy.dart';
import 'package:halen/presentation/widgets/ads/halen_ad_banner.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/application/stats_providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/domain/motivation.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';
import 'package:halen/presentation/widgets/body_load_card.dart';
import 'package:halen/presentation/widgets/charts/hourly_distribution_chart.dart';
import 'package:halen/presentation/widgets/charts/interval_chart.dart';
import 'package:halen/presentation/widgets/charts/trigger_breakdown_chart.dart';
import 'package:halen/presentation/widgets/craving_window_card.dart';
import 'package:halen/presentation/widgets/entrance.dart';
import 'package:halen/presentation/widgets/indices_card.dart';
import 'package:halen/presentation/widgets/stats_charts.dart';
import 'package:halen/presentation/widgets/environment_card.dart';
import 'package:halen/presentation/widgets/tar_intake_card.dart';
import '../../../core/design/tokens.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final daily = ref.watch(dailyStatsProvider(7));
    final savings = ref.watch(totalSavingsProvider);
    final tabs = [
      l10n.statsTabDaily,
      l10n.statsTabHourly,
      l10n.statsTabIntervals,
      l10n.statsTabTriggers,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statsTitle),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            Text(
              l10n.statsIntro,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x6),

            // Module report §14 — the twin indices lead, because "am I
            // getting better?" is the question people open stats to answer.
            const Entrance(child: IndicesCard()),
            const SizedBox(height: HalenSpace.x4),
            // §1 — the body-load sawtooth, built from the user's own times.
            const Entrance(index: 1, child: BodyLoadCard()),
            const SizedBox(height: HalenSpace.x4),
            // §4 — craving arrives while nicotine falls, shown in their data.
            const Entrance(index: 2, child: CravingWindowCard()),
            const SizedBox(height: HalenSpace.x4),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.body),
                    icon: const Icon(Icons.monitor_heart_outlined, size: 18),
                    label: Text(l10n.organMapTitle),
                  ),
                ),
                const SizedBox(width: HalenSpace.x3),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.economy),
                    icon: const Icon(Icons.savings_outlined, size: 18),
                    label: Text(l10n.economyTitle),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x6),
            savings.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(l10n.commonErrorTitle),
              data: (total) => Container(
                padding: const EdgeInsets.all(HalenSpace.x6),
                decoration: HalenSurface.hero(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(HalenSpace.x2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.savings_rounded,
                            color: HalenColors.mint,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: HalenSpace.x3),
                        Expanded(
                          child: Text(
                            l10n.chartSavings,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: HalenColors.mint,
                            ),
                          ),
                        ),
                        Text(
                          l10n.statsRangeAll,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF9FC4AF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HalenSpace.x5),
                    Text(
                      '${total.toStringAsFixed(0)} ₺',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: HalenSpace.x1),
                    Text(
                      l10n.statsSavingsNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFD6E8DB),
                      ),
                    ),
                    // Cumulative savings trend (Smoke Free signature chart).
                    daily.maybeWhen(
                      data: (stats) {
                        if (stats.length < 2) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: _SavingsTrendChart(stats: stats),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < tabs.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tabs[i]),
                        selected: _selectedTabIndex == i,
                        onSelected: (_) =>
                            setState(() => _selectedTabIndex = i),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: HalenSpace.x4),
            if (_selectedTabIndex == 0) ...[
              daily.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(l10n.commonErrorTitle),
                data: (stats) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(HalenSpace.x5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chartDaily,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: HalenSpace.x1),
                        Text(
                          l10n.statsRange7,
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: HalenSpace.x6),
                        if (stats.every(
                          (s) => s.count == 0 && s.planTarget == null,
                        ))
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: HalenSpace.x8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.insights_rounded,
                                  size: 40,
                                  color: colors.primary,
                                ),
                                const SizedBox(height: HalenSpace.x4),
                                Text(
                                  l10n.chartEmptyTitle,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: HalenSpace.x2),
                                Text(
                                  l10n.chartEmptyBody,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else ...[
                          DailyBarsChart(
                            counts: [for (final s in stats) s.count],
                            planTargets: [for (final s in stats) s.planTarget],
                            dayLabels: [
                              for (final s in stats)
                                DateFormat.E(l10n.localeName)
                                    .format(DateTime.parse(s.dateKey)),
                            ],
                            barColor: colors.primary,
                            markerColor: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: HalenSpace.x4),
                          Wrap(
                            spacing: 20,
                            runSpacing: 8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: colors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: HalenSpace.x2),
                                  Text(
                                    l10n.chartActualLabel,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    child: LayoutBuilder(
                                      builder: (context, c) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          for (final _ in [1, 2, 3])
                                            Container(
                                              width: 3,
                                              height: 2,
                                              decoration: BoxDecoration(
                                                color: colors.onSurfaceVariant,
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: HalenSpace.x2),
                                  Text(
                                    l10n.chartTargetLabel,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: HalenSpace.x3),
              daily.maybeWhen(
                data: (stats) {
                  final streaks = computeStreaks([
                    for (final s in stats)
                      DayAdherence(count: s.count, planTarget: s.planTarget),
                  ]);
                  // Progress toward the next 7-day milestone (no zero
                  // counters on broken streaks — report §16).
                  final weekProgress =
                      (streaks.displayDays % 7) / 7;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(HalenSpace.x5),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(HalenSpace.x3),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.spa_rounded,
                              color: colors.onPrimaryContainer,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: HalenSpace.x4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  streaks.isBroken
                                      ? l10n.motivationStreakRestart
                                      : l10n.motivationStreakBest(
                                          streaks.displayDays,
                                        ),
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: HalenSpace.x2),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value: weekProgress,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
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
            if (_selectedTabIndex == 1)
              ref
                  .watch(hourlyAnalyticsProvider)
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(l10n.commonErrorTitle),
                    data: (report) => HourlyDistributionCard(report: report),
                  ),
            if (_selectedTabIndex == 2)
              ref
                  .watch(todayIntervalsProvider)
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(l10n.commonErrorTitle),
                    data: (report) => IntervalChartCard(report: report),
                  ),
            if (_selectedTabIndex == 3)
              ref
                  .watch(triggerAnalyticsProvider)
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text(l10n.commonErrorTitle),
                    data: (report) => TriggerBreakdownCard(triggers: report),
                  ),
            // Items 4 and 10 go after everything that was already here:
            // added above, they pushed the chart tabs ~7,000 px further down
            // on a small phone with large text.
            const SizedBox(height: HalenSpace.x6),
            const TarIntakeCard(),
            const SizedBox(height: HalenSpace.x4),
            const EnvironmentCard(),
            const SizedBox(height: 28),
            // T21: labelled banner, free users past the trial only. The
            // policy layer decides; no fill collapses the slot.
            const HalenAdBanner(surface: AdSurface.statsBottom),
            const SizedBox(height: HalenSpace.x4),
            TextButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.healthTimeline),
              icon: const Icon(Icons.favorite_border_rounded, size: 18),
              label: Text(l10n.timelineTitle),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cumulative savings as a smooth gradient area line inside the dark hero
/// (the signature chart of the category's top apps). Lives on the petrol
/// surface, so its palette is mint-on-green, not theme colors.
class _SavingsTrendChart extends StatelessWidget {
  const _SavingsTrendChart({required this.stats});

  final List<DayStats> stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var running = 0.0;
    final spots = <FlSpot>[
      for (var i = 0; i < stats.length; i++)
        () {
          running += stats[i].savings ?? 0;
          return FlSpot(i.toDouble(), running);
        }(),
    ];
    final maxValue = running.clamp(10.0, double.infinity).toDouble();

    return SizedBox(
      height: 88,
      child: Semantics(
        label: l10n.chartSavings,
        image: true,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (stats.length - 1).toDouble(),
            minY: 0,
            maxY: maxValue,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              leftTitles: AxisTitles(),
              bottomTitles: AxisTitles(),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => Colors.white,
                tooltipBorderRadius: BorderRadius.circular(10),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                getTooltipItems: (spots) => [
                  for (final spot in spots)
                    LineTooltipItem(
                      '${spot.y.toStringAsFixed(0)} ₺',
                      TextStyle(
                        color: HalenColors.petrolDeep,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.35,
                preventCurveOverShooting: true,
                barWidth: 2.5,
                color: HalenColors.mint,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 3,
                    color: HalenColors.mint,
                    strokeWidth: 2,
                    strokeColor: const Color(0xFF1D4A39),
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      HalenColors.mint.withValues(alpha: 0.35),
                      HalenColors.mint.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }
}
