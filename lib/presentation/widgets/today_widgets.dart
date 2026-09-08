/// BUGÜN screen building blocks. Pure presentation — all numbers arrive via
/// [TodayState]; every chart exposes a spoken summary (report §14 a11y).
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

/// The daily-budget progress ring: thick gradient stroke, glowing cap.
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
      excludeSemantics: true,
      child: SizedBox(
        width: 136,
        height: 148,
        child: Column(
          children: [
            SizedBox(
              width: 128,
              height: 116,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(116, 116),
                    painter: _RingPainter(fraction: fraction),
                  ),
                  Text(
                    '$smoked/$target',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.dailyBudgetCaption,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: HalenColors.mint,
                  fontSize: 10,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.fraction});

  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final rect = Offset.zero & size;
    const startAngle = -math.pi / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.16);

    canvas.drawArc(rect.deflate(stroke / 2), startAngle, math.pi * 2, false,
        track);

    if (fraction > 0) {
      final progressRect = rect.deflate(stroke / 2);
      final sweepAngle = math.pi * 2 * fraction;

      final progress = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: const [Color(0xFF8FD4B2), HalenColors.mint],
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(progressRect);

      canvas.drawArc(progressRect, startAngle, sweepAngle, false, progress);

      // Glowing endpoint dot.
      final dotAngle = startAngle + sweepAngle;
      final center = progressRect.center;
      final radius = progressRect.width / 2;
      final dotCenter = Offset(
        center.dx + radius * math.cos(dotAngle),
        center.dy + radius * math.sin(dotAngle),
      );
      canvas.drawCircle(
        dotCenter,
        stroke * 0.9,
        Paint()..color = Colors.white.withValues(alpha: 0.25),
      );
      canvas.drawCircle(
        dotCenter,
        stroke * 0.55,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction;
}

/// Normalized nicotine-exposure sparkline with smooth area gradient (S3, 0-100).
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
        height: 56,
        child: CustomPaint(
          size: Size.infinite,
          painter: _CurvePainter(
            curve: curve,
            lineColor: theme.colorScheme.primary,
            fillColor: theme.colorScheme.primary,
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

    final points = <Offset>[];
    for (var i = 0; i < curve.length; i++) {
      final x = 6 + i / (curve.length - 1) * (size.width - 12);
      final y = size.height - (curve[i] / 100) * (size.height - 10) - 5;
      points.add(Offset(x, y));
    }

    // Smooth the line through segment midpoints (quadratic bezier).
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final mid = (points[i - 1] + points[i]) / 2;
      linePath.quadraticBezierTo(points[i - 1].dx, points[i - 1].dy,
          mid.dx, mid.dy);
    }
    linePath.lineTo(points.last.dx, points.last.dy);

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor.withValues(alpha: 0.22), fillColor.withValues(
          alpha: 0.0,
        )],
      ).createShader(Offset.zero & size);

    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = lineColor;

    canvas.drawPath(linePath, strokePaint);

    final last = points.last;
    canvas.drawCircle(
      last,
      6.5,
      Paint()..color = lineColor.withValues(alpha: 0.2),
    );
    canvas.drawCircle(last, 3.5, Paint()..color = lineColor);
    canvas.drawCircle(last, 1.6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.curve != curve || old.lineColor != lineColor;
}
