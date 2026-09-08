import 'package:flutter/material.dart';

/// 7 × 24 heatmap of the user's own rhythm (module report §4.④).
///
/// Chart rules kept: a single monochromatic scale in at most five steps (so
/// it survives colour-blindness), zero drawn as an outline rather than a
/// colour, and a one-sentence semantics label instead of 168 cells.
class WeekHeatmap extends StatelessWidget {
  const WeekHeatmap({
    super.key,
    required this.counts,
    required this.color,
    required this.semanticsLabel,
    required this.dayLabels,
    this.height = 132,
  });

  /// counts[weekday 0–6][hour 0–23]; weekday 0 is the first column row.
  final List<List<int>> counts;
  final Color color;
  final String semanticsLabel;

  /// Seven short day labels, already localized.
  final List<String> dayLabels;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _HeatmapPainter(
            counts: counts,
            color: color,
            dayLabels: dayLabels,
            gridColor: theme.dividerColor,
            labelStyle:
                theme.textTheme.labelSmall ?? const TextStyle(fontSize: 10),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.counts,
    required this.color,
    required this.dayLabels,
    required this.gridColor,
    required this.labelStyle,
  });

  final List<List<int>> counts;
  final Color color;
  final List<String> dayLabels;
  final Color gridColor;
  final TextStyle labelStyle;

  static const double _gutter = 26;
  static const double _hourLane = 14;
  static const int _steps = 5;

  @override
  void paint(Canvas canvas, Size size) {
    if (counts.length != 7) {
      return;
    }
    var peak = 0;
    for (final row in counts) {
      for (final value in row) {
        if (value > peak) {
          peak = value;
        }
      }
    }

    final plotWidth = size.width - _gutter;
    final plotHeight = size.height - _hourLane;
    final cellWidth = plotWidth / 24;
    final cellHeight = plotHeight / 7;
    final radius = Radius.circular(cellWidth < 6 ? 1 : 2);

    for (var day = 0; day < 7; day++) {
      final top = day * cellHeight;
      final labelPainter = TextPainter(
        text: TextSpan(text: dayLabels[day], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: _gutter - 4);
      labelPainter.paint(
        canvas,
        Offset(0, top + (cellHeight - labelPainter.height) / 2),
      );

      for (var hour = 0; hour < 24; hour++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            _gutter + hour * cellWidth + 0.5,
            top + 0.5,
            cellWidth - 1,
            cellHeight - 1,
          ),
          radius,
        );
        final value = counts[day][hour];
        if (value == 0 || peak == 0) {
          canvas.drawRRect(
            rect,
            Paint()
              ..color = gridColor.withValues(alpha: 0.35)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1,
          );
          continue;
        }
        // Quantize to five steps so the scale stays readable.
        final step = ((value / peak) * _steps).ceil().clamp(1, _steps);
        canvas.drawRRect(
          rect,
          Paint()..color = color.withValues(alpha: 0.18 + 0.82 * step / _steps),
        );
      }
    }

    for (final hour in [0, 6, 12, 18]) {
      final painter = TextPainter(
        text: TextSpan(text: '$hour', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(_gutter + hour * cellWidth, size.height - painter.height),
      );
    }
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.counts != counts || old.color != color;
}
