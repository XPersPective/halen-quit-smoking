/// Statistics charts — plain CustomPaint bars, no chart package. Every chart
/// carries a spoken summary via [Semantics] (report §12/§14).
library;

import 'package:flutter/material.dart';

/// Daily counts as bars with a plan-target marker on each bar.
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
    return SizedBox(
      height: 150,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DailyBarsPainter(
          counts: counts,
          planTargets: planTargets,
          barColor: barColor,
          markerColor: markerColor,
          dayLabels: dayLabels,
          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DailyBarsPainter extends CustomPainter {
  const _DailyBarsPainter({
    required this.counts,
    required this.planTargets,
    required this.barColor,
    required this.markerColor,
    this.dayLabels,
    required this.textColor,
  });

  final List<int> counts;
  final List<int?> planTargets;
  final Color barColor;
  final Color markerColor;
  final List<String>? dayLabels;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (counts.isEmpty) {
      return;
    }
    final maxValue = [
      ...counts,
      ...planTargets.whereType<int>(),
    ].fold(1, (a, b) => a > b ? a : b);

    final baselineY = size.height - 24;
    final usableHeight = baselineY - 24;
    final step = size.width / counts.length;
    final barWidth = (step * 0.55).clamp(12.0, 36.0);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw baseline
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      Paint()
        ..color = textColor.withValues(alpha: 0.25)
        ..strokeWidth = 1,
    );

    for (var i = 0; i < counts.length; i++) {
      final count = counts[i];
      final x = i * step + (step - barWidth) / 2;
      final barHeight = count > 0
          ? (count / maxValue * usableHeight).clamp(6.0, usableHeight)
          : 3.0;
      final y = baselineY - barHeight;

      final rRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      );

      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            barColor,
            barColor.withValues(alpha: 0.65),
          ],
        ).createShader(rRect.outerRect);

      canvas.drawRRect(rRect, barPaint);

      // Target marker
      final target = planTargets[i];
      if (target != null && target > 0) {
        final targetY = baselineY - (target / maxValue * usableHeight);
        final markerPaint = Paint()
          ..color = markerColor
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

        canvas.drawLine(
          Offset(x - 4, targetY),
          Offset(x + barWidth + 4, targetY),
          markerPaint,
        );
      }

      // Count value above bar
      if (count > 0) {
        textPainter.text = TextSpan(
          text: '$count',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: barColor,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, y - 16),
        );
      }

      // Day label below baseline
      if (dayLabels != null && i < dayLabels!.length) {
        textPainter.text = TextSpan(
          text: dayLabels![i],
          style: TextStyle(
            fontSize: 10,
            color: textColor,
            fontWeight: i == counts.length - 1 ? FontWeight.bold : FontWeight.normal,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x + (barWidth - textPainter.width) / 2, baselineY + 6),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DailyBarsPainter old) => true;
}

/// Hour-of-day histogram (24 slim bars).
class HourlyBarsChart extends StatelessWidget {
  const HourlyBarsChart({
    super.key,
    required this.histogram,
    required this.barColor,
  });

  final List<int> histogram;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CustomPaint(
        size: Size.infinite,
        painter: _HourlyPainter(histogram: histogram, barColor: barColor),
      ),
    );
  }
}

class _HourlyPainter extends CustomPainter {
  const _HourlyPainter({required this.histogram, required this.barColor});

  final List<int> histogram;
  final Color barColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (histogram.length != 24) {
      return;
    }
    final max = histogram.fold(1, (a, b) => a > b ? a : b);
    final step = size.width / 24;
    final paint = Paint()..color = barColor;
    for (var h = 0; h < 24; h++) {
      final barHeight = histogram[h] / max * (size.height - 4);
      canvas.drawRect(
        Rect.fromLTWH(h * step + 1, size.height - barHeight, step - 2, barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_HourlyPainter old) => false;
}
