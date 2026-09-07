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
  });

  /// One value per day, oldest first.
  final List<int> counts;
  final List<int?> planTargets;
  final Color barColor;
  final Color markerColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DailyBarsPainter(
          counts: counts,
          planTargets: planTargets,
          barColor: barColor,
          markerColor: markerColor,
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
  });

  final List<int> counts;
  final List<int?> planTargets;
  final Color barColor;
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (counts.isEmpty) {
      return;
    }
    final maxValue = [
      ...counts,
      ...planTargets.whereType<int>(),
    ].fold(1, (a, b) => a > b ? a : b);
    final barWidth = size.width / counts.length * 0.6;
    final step = size.width / counts.length;

    for (var i = 0; i < counts.length; i++) {
      final x = i * step + (step - barWidth) / 2;
      final barHeight = counts[i] / maxValue * (size.height - 8);
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
        Paint()..color = barColor,
      );
      final target = planTargets[i];
      if (target != null) {
        final y = size.height - target / maxValue * (size.height - 8);
        canvas.drawLine(
          Offset(i * step, y),
          Offset((i + 1) * step, y),
          Paint()
            ..color = markerColor
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DailyBarsPainter old) => false;
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
