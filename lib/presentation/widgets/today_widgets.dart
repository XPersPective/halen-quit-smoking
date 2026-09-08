/// BUGÜN screen building blocks. Pure presentation — all numbers arrive via
/// [TodayState]; every chart exposes a spoken summary (report §14 a11y).
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:halen/core/theme.dart';

/// The daily-budget progress ring with modern gradient stroke & remaining counter.
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
    final remaining = math.max(0, target - smoked);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        width: 190,
        height: 190,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(190, 190),
              painter: _RingPainter(
                fraction: fraction,
                trackColor: isDark
                    ? HalenColors.surfaceElevatedDark
                    : HalenColors.surfaceElevatedLight,
                primaryColor: theme.colorScheme.primary,
                accentColor: HalenColors.emerald,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$smoked/$target',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: smoked > target
                        ? HalenColors.coral
                        : theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: remaining > 0
                        ? HalenColors.emerald.withValues(alpha: 0.12)
                        : HalenColors.amberCta.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    remaining > 0 ? '$remaining hak kaldı' : 'Hedef doldu',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: remaining > 0
                          ? HalenColors.emerald
                          : HalenColors.amberCta,
                    ),
                  ),
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
    required this.primaryColor,
    required this.accentColor,
  });

  final double fraction;
  final Color trackColor;
  final Color primaryColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final rect = Offset.zero & size;
    const startAngle = -math.pi / 2;

    // Track
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;

    canvas.drawArc(
      rect.deflate(stroke),
      startAngle,
      math.pi * 2,
      false,
      track,
    );

    if (fraction > 0) {
      final sweepAngle = math.pi * 2 * fraction;
      final progressRect = rect.deflate(stroke);

      final progress = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [primaryColor, accentColor],
        ).createShader(progressRect);

      canvas.drawArc(
        progressRect,
        startAngle,
        sweepAngle,
        false,
        progress,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction ||
      old.primaryColor != primaryColor ||
      old.accentColor != accentColor;
}

/// Normalized nicotine-exposure sparkline with smooth area gradient (S3, 0–100).
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
        height: 52,
        child: CustomPaint(
          size: Size.infinite,
          painter: _CurvePainter(
            curve: curve,
            lineColor: theme.colorScheme.primary,
            fillColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  const _CurvePainter({
    required this.curve,
    required this.lineColor,
    required this.fillColor,
  });

  final List<int> curve;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (curve.length < 2) return;

    final linePath = Path();
    final fillPath = Path();

    for (var i = 0; i < curve.length; i++) {
      final x = i / (curve.length - 1) * size.width;
      final y = size.height - (curve[i] / 100) * (size.height - 8) - 4;
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == curve.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    // Draw gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor, fillColor.withValues(alpha: 0.0)],
      ).createShader(Offset.zero & size);

    canvas.drawPath(fillPath, fillPaint);

    // Draw stroke
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = lineColor;

    canvas.drawPath(linePath, strokePaint);

    // Draw active point dot at the end
    final lastX = size.width;
    final lastY = size.height - (curve.last / 100) * (size.height - 8) - 4;
    canvas.drawCircle(
      Offset(lastX, lastY),
      4.5,
      Paint()..color = lineColor,
    );
    canvas.drawCircle(
      Offset(lastX, lastY),
      2.0,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_CurvePainter old) => true;
}
