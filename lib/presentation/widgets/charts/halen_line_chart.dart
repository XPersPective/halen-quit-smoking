import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// One named series on a [HalenLineChart].
class ChartSeries {
  const ChartSeries({
    required this.name,
    required this.color,
    required this.values,
    this.dashed = false,
    this.fill = false,
  });

  /// Legend label — every series is named on screen. A line the user cannot
  /// name is a line they cannot read.
  final String name;
  final Color color;

  /// Y values, oldest first. Nulls are not supported: gaps should be filled
  /// by the caller so the line stays honest about what it is showing.
  final List<double> values;

  /// Comparison series (a "never smoked" reference, say) read as dashed.
  final bool dashed;

  /// Fills under the line — used for the one series that carries the message.
  final bool fill;
}

/// The shared line chart for every module screen.
///
/// It exists because hand-drawn lines were failing the report's own chart
/// rules: no axis, no legend, no way to interrogate a point. Everything a
/// reader needs to decode the picture is now part of the widget itself:
///
///  * a plain-language [meaning] sentence above the chart — the report's
///    "one chart, one sentence" rule, enforced by making it required;
///  * a named legend under it, with the direction that counts as good;
///  * real axis labels and a touch tooltip that names the series and the
///    point, so the number can be checked rather than admired;
///  * a shaded band between the first two series when [shadeBetween] is on —
///    that gap is the message on the economy and lung screens.
class HalenLineChart extends StatelessWidget {
  const HalenLineChart({
    super.key,
    required this.series,
    required this.meaning,
    required this.xLabels,
    required this.semanticsLabel,
    this.axisCaption,
    this.yFormatter,
    this.tooltipFormatter,
    this.minY,
    this.maxY,
    this.height = 210,
    this.shadeBetween = false,
    this.highlightLastPoint = true,
    this.yLabelWidth = 48,
  });

  final List<ChartSeries> series;

  /// The sentence that says what this chart means, in the user's words.
  final String meaning;

  /// Labels for the x axis, evenly spaced (typically 3: start, middle, end).
  final List<String> xLabels;

  /// What the Y axis measures, e.g. "points, 0-100". A numbered axis without
  /// its unit is decoration; this is how the unit gets said.
  final String? axisCaption;

  final String semanticsLabel;

  /// Formats a y-axis tick. Defaults to a rounded integer.
  final String Function(double)? yFormatter;

  /// Formats a tooltip value; defaults to [yFormatter].
  final String Function(double)? tooltipFormatter;

  final double? minY;
  final double? maxY;
  final double height;

  /// Shades the area between the first two series.
  final bool shadeBetween;

  /// Marks where "today" (the last point) sits, so the reader always knows
  /// which end of the line is now.
  final bool highlightLastPoint;

  /// Width reserved for y-axis labels. Currency strings need more room than
  /// plain numbers; too little and the label wraps onto the line above it.
  final double yLabelWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final format = yFormatter ?? (v) => v.round().toString();
    final tooltip = tooltipFormatter ?? format;

    final all = [for (final s in series) ...s.values];
    if (all.isEmpty || series.first.values.length < 2) {
      return const SizedBox.shrink();
    }
    // Padding is for auto-scaled axes only: when a caller states 0-100 it
    // means 0-100, and inventing -12 and 112 ticks made the axis unreadable.
    final lo = minY ?? all.reduce(math.min);
    final hi = maxY ?? all.reduce(math.max);
    final padLow = minY == null ? math.max((hi - lo) * 0.12, 1.0) : 0.0;
    final padHigh = maxY == null ? math.max((hi - lo) * 0.12, 1.0) : 0.0;
    final length = series.first.values.length;

    LineChartBarData barFor(ChartSeries s, {bool below = false}) =>
        LineChartBarData(
          spots: [
            for (var i = 0; i < s.values.length; i++)
              FlSpot(i.toDouble(), s.values[i]),
          ],
          isCurved: true,
          curveSmoothness: 0.18,
          preventCurveOverShooting: true,
          color: s.color,
          barWidth: s.dashed ? 1.6 : 2.6,
          dashArray: s.dashed ? const [5, 4] : null,
          dotData: FlDotData(
            show: highlightLastPoint,
            checkToShowDot: (spot, _) => spot.x == (length - 1).toDouble(),
            getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
              radius: 4,
              color: s.color,
              strokeWidth: 2,
              strokeColor: theme.colorScheme.surface,
            ),
          ),
          belowBarData: BarAreaData(
            show: s.fill || below,
            color: s.color.withValues(alpha: below ? 0.14 : 0.10),
            applyCutOffY: false,
          ),
          aboveBarData: BarAreaData(show: false),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rule 1: the sentence comes before the picture.
        Text(meaning, style: theme.textTheme.bodyMedium),
        if (axisCaption != null) ...[
          const SizedBox(height: 6),
          Text(
            axisCaption!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Semantics(
          label: semanticsLabel,
          image: true,
          child: SizedBox(
            height: height,
            child: LineChart(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 260),
              LineChartData(
                minY: lo - padLow,
                maxY: hi + padHigh,
                lineBarsData: [
                  for (var i = 0; i < series.length; i++)
                    barFor(series[i], below: shadeBetween && i == 0),
                ],
                betweenBarsData: [
                  if (shadeBetween && series.length >= 2)
                    BetweenBarsData(
                      fromIndex: 0,
                      toIndex: 1,
                      color: series.first.color.withValues(alpha: 0.16),
                    ),
                ],
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: math.max((hi - lo) / 2, 1),
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: theme.dividerColor.withValues(alpha: 0.45),
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
                      reservedSize: yLabelWidth,
                      interval: math.max((hi - lo) / 2, 1),
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          format(value),
                          style: theme.textTheme.labelSmall,
                          textAlign: TextAlign.right,
                          // Never wrap: a wrapped tick collides with the line
                          // above it and makes the axis unreadable.
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: xLabels.isNotEmpty,
                      reservedSize: 26,
                      interval: xLabels.length <= 1
                          ? length.toDouble()
                          : (length - 1) / (xLabels.length - 1),
                      getTitlesWidget: (value, meta) {
                        if (xLabels.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final step = xLabels.length <= 1
                            ? 1.0
                            : (length - 1) / (xLabels.length - 1);
                        final index = (value / step).round();
                        if (index < 0 || index >= xLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            xLabels[index],
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                    tooltipBorderRadius: BorderRadius.circular(12),
                    getTooltipItems: (spots) => [
                      for (final spot in spots)
                        LineTooltipItem(
                          '${series[spot.barIndex].name}: '
                          '${tooltip(spot.y)}',
                          theme.textTheme.labelMedium!.copyWith(
                            color: theme.colorScheme.onInverseSurface,
                          ),
                        ),
                    ],
                  ),
                  getTouchedSpotIndicator: (bar, indexes) => [
                    for (final _ in indexes)
                      TouchedSpotIndicatorData(
                        FlLine(color: bar.color!, strokeWidth: 1),
                        FlDotData(
                          getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                            radius: 4,
                            color: bar.color!,
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ChartLegend(series: series),
      ],
    );
  }
}

/// Names every line, with the swatch drawn the way the line is drawn.
class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.series});

  final List<ChartSeries> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        for (final s in series)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                size: const Size(16, 3),
                painter: _SwatchPainter(color: s.color, dashed: s.dashed),
              ),
              const SizedBox(width: 6),
              // A series name can be a full Turkish phrase, which on a 360 dp
              // phone is wider than the card. Let it wrap instead of
              // overflowing — the legend is what makes the chart readable, so
              // it is the last thing that should be clipped.
              Flexible(
                child: Text(s.name, style: theme.textTheme.labelMedium),
              ),
            ],
          ),
      ],
    );
  }
}

class _SwatchPainter extends CustomPainter {
  _SwatchPainter({required this.color, required this.dashed});

  final Color color;
  final bool dashed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    if (!dashed) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
      return;
    }
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(math.min(x + 4, size.width), size.height / 2),
        paint,
      );
      x += 7;
    }
  }

  @override
  bool shouldRepaint(_SwatchPainter old) =>
      old.color != color || old.dashed != dashed;
}

/// A card wrapper that gives every chart the same anatomy: title, optional
/// help button, the chart, and a closing note.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.footnote,
    this.onHelp,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final String? footnote;
  final VoidCallback? onHelp;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      if (subtitle != null)
                        Text(subtitle!, style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
                ?trailing,
                if (onHelp != null)
                  IconButton(
                    icon: const Icon(Icons.help_outline_rounded, size: 20),
                    onPressed: onHelp,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            child,
            if (footnote != null) ...[
              const SizedBox(height: 12),
              Text(
                footnote!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: HalenColors.textSecondaryLight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
