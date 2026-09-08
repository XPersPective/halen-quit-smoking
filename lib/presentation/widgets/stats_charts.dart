/// Statistics charts — fl_chart powered, animated, touch tooltips. Every
/// chart keeps a spoken summary via [Semantics] (report §12/§14).
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

/// Daily counts as rounded gradient bars with a slim target rod beside each
/// bar (Smoke Free pattern: actual vs goal at a glance). The current day is
/// emphasized; history stays calm and translucent.
class DailyBarsChart extends StatelessWidget {
  const DailyBarsChart({
    super.key,
    required this.counts,
    required this.planTargets,
    required this.barColor,
    required this.markerColor,
    this.dayLabels,
  });

  /// One value per day, oldest first.
  final List<int> counts;
  final List<int?> planTargets;
  final Color barColor;
  final Color markerColor;
  final List<String>? dayLabels;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final summary = [
      for (var i = 0; i < counts.length; i++)
        '${dayLabels != null && i < dayLabels!.length ? dayLabels![i] : i + 1}: ${l10n.chartActualLabel} ${counts[i]}${i < planTargets.length && planTargets[i] != null ? ', ${l10n.chartTargetLabel} ${planTargets[i]}' : ''}',
    ].join('. ');

    if (counts.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxValue = [
      ...counts,
      ...planTargets.whereType<int>(),
    ].fold(1, (a, b) => a > b ? a : b);

    return Semantics(
      label: summary,
      image: true,
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            maxY: (maxValue * 1.18).ceilToDouble(),
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.primary,
              tooltipBorderRadius: BorderRadius.circular(12),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final i = group.x;
                final day = dayLabels != null && i < dayLabels!.length
                    ? dayLabels![i]
                    : '${i + 1}';
                final target = i < planTargets.length
                    ? planTargets[i]
                    : null;
                return BarTooltipItem(
                  '$day\n',
                  TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: '${l10n.chartActualLabel} ${rod.toY.round()}'
                      '${target != null ? ' · ${l10n.chartTargetLabel} $target' : ''}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxValue / 2).ceilToDouble().clamp(1, 100),
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.08,
              ),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 26,
                interval: (maxValue / 2).ceilToDouble().clamp(1, 100),
                getTitlesWidget: (value, meta) => Text(
                  value % 1 == 0 && value >= 0 ? '${value.round()}' : '',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (dayLabels == null || i < 0 || i >= dayLabels!.length) {
                    return const SizedBox.shrink();
                  }
                  final isLast = i == counts.length - 1;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      dayLabels![i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isLast ? FontWeight.w700 : FontWeight.w500,
                        color: isLast
                            ? barColor
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < counts.length; i++)
              BarChartGroupData(
                x: i,
                barsSpace: 3,
                barRods: [
                  BarChartRodData(
                    toY: counts[i].toDouble(),
                    width: 16,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: i == counts.length - 1
                          ? [barColor, barColor.withValues(alpha: 0.78)]
                          : [
                              barColor.withValues(alpha: 0.38),
                              barColor.withValues(alpha: 0.20),
                            ],
                    ),
                  ),
                  if (i < planTargets.length && planTargets[i] != null)
                    BarChartRodData(
                      toY: planTargets[i]!.toDouble(),
                      width: 3,
                      borderRadius: BorderRadius.circular(2),
                      color: markerColor.withValues(alpha: 0.72),
                    ),
                ],
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
