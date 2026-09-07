/// BUGÜN screen building blocks. Pure presentation — all numbers arrive via
/// [TodayState]; every chart exposes a spoken summary (report §14 a11y).
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The daily-budget progress ring: "6/8" with the fraction smoked.
class BudgetRing extends StatelessWidget {
  const BudgetRing({
    super.key,
    required this.smoked,
    required this.target,
    required this.semanticLabel,
  });

  final int smoked;
  final int target;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraction = target <= 0 ? 0.0 : (smoked / target).clamp(0.0, 1.0);
    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        width: 168,
        height: 168,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(168, 168),
              painter: _RingPainter(
                fraction: fraction,
                trackColor: theme.colorScheme.surfaceContainerHighest,
                progressColor: theme.colorScheme.primary,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$smoked/$target',
                  style: theme.textTheme.displaySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.fraction,
    required this.trackColor,
    required this.progressColor,
  });

  final double fraction;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 12.0;
    final rect = Offset.zero & size;
    const startAngle = -math.pi / 2;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    canvas.drawArc(rect.deflate(stroke), startAngle, math.pi * 2, false, track);
    canvas.drawArc(
      rect.deflate(stroke),
      startAngle,
      math.pi * 2 * fraction,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.progressColor != progressColor;
}

/// Mini normalized nicotine-exposure sparkline (S3, 0–100).
class NicotineSparkline extends StatelessWidget {
  const NicotineSparkline({
    super.key,
    required this.curve,
    required this.semanticLabel,
  });

  final List<int> curve;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        height: 40,
        child: CustomPaint(
          size: Size.infinite,
          painter: _CurvePainter(curve: curve, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  const _CurvePainter({required this.curve, required this.color});

  final List<int> curve;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (curve.length < 2) {
      return;
    }
    final path = Path();
    for (var i = 0; i < curve.length; i++) {
      final x = i / (curve.length - 1) * size.width;
      final y = size.height - (curve[i] / 100) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CurvePainter old) => false;
}
