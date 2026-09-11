import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';

/// The shared bar chart — the line chart's sibling, with the same rules.
///
/// A sentence before the picture ([meaning], required), a unit on the axis
/// ([axisCaption], required here: every bar chart in this app shows an
/// amount), a label under every bar, and blank reserved lanes on the top and
/// right edges so bars never touch the card (item 13).
class HalenBarChart extends StatelessWidget {
  const HalenBarChart({
    super.key,
    required this.values,
    required this.labels,
    required this.meaning,
    required this.axisCaption,
    required this.color,
    required this.semanticsLabel,
    this.yFormatter,
    this.highlightLast = true,
    this.height = 200,
    this.yLabelWidth = 56,
  });

  final List<double> values;

  /// One label per bar.
  final List<String> labels;

  final String meaning;
  final String axisCaption;
  final Color color;
  final String semanticsLabel;
  final String Function(double)? yFormatter;

  /// Draws the last bar solid and the rest lighter — "now" versus history.
  final bool highlightLast;

  final double height;
  final double yLabelWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final format = yFormatter ?? (v) => v.round().toString();
    final top = values.isEmpty ? 1.0 : math.max(values.reduce(math.max), 1e-9);
    // Round the axis up to a clean top so the ticks read as numbers someone
    // would say out loud, not 37.4 and 74.8.
    final step = _niceStep(top / 2);
    final maxY = step * 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(meaning, style: theme.textTheme.bodyMedium),
        const SizedBox(height: HalenSpace.x2),
        Text(
          axisCaption,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: HalenSpace.x3),
        Semantics(
          label: semanticsLabel,
          image: true,
          child: SizedBox(
            height: height,
            child: BarChart(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 320),
              BarChartData(
                maxY: maxY,
                minY: 0,
                alignment: BarChartAlignment.spaceAround,
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: step,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.dividerColor.withValues(alpha: 0.45),
                    strokeWidth: 1,
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                    getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                      '${labels[group.x]}: ${format(rod.toY)}',
                      theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onInverseSurface,
                      ),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: HalenSpace.x3,
                      getTitlesWidget: _blank,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: HalenSpace.x4,
                      getTitlesWidget: _blank,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: step,
                      reservedSize: yLabelWidth,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: HalenSpace.x2),
                        child: Text(
                          format(value),
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: HalenSpace.x8,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: HalenSpace.x2),
                          child: Text(
                            labels[i],
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < values.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          width: 18,
                          color: highlightLast && i != values.length - 1
                              ? color.withValues(alpha: 0.45)
                              : color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 1, 2 or 5 times a power of ten — the steps people count in.
  static double _niceStep(double raw) {
    if (raw <= 0) {
      return 1;
    }
    final magnitude = math.pow(10, (math.log(raw) / math.ln10).floor()).toDouble();
    for (final m in const [1.0, 2.0, 5.0, 10.0]) {
      if (raw <= m * magnitude) {
        return m * magnitude;
      }
    }
    return 10 * magnitude;
  }
}

Widget _blank(double value, TitleMeta meta) => const SizedBox.shrink();
