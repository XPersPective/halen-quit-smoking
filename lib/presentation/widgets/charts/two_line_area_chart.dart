import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Two scenario lines with the gap between them shaded — the single visual
/// grammar shared by the economy projection ("this shaded area is your
/// decision", module report §3.④) and the lung scenarios (§6.③).
///
/// Rules kept from the report: no point markers, at most three grid lines,
/// the shaded area is the message, and the whole chart exposes one sentence
/// to screen readers rather than a list of numbers.
class TwoLineAreaChart extends StatelessWidget {
  const TwoLineAreaChart({
    super.key,
    required this.upper,
    required this.lower,
    required this.upperColor,
    required this.lowerColor,
    required this.semanticsLabel,
    this.reference,
    this.referenceColor,
    this.height = 190,
    this.axisLabels = const [],
  });

  /// The "if nothing changes" series — always the worse one.
  final List<double> upper;

  /// The "if you change" series.
  final List<double> lower;

  /// Optional third, purely comparative series (never-smoker baseline).
  final List<double>? reference;

  final Color upperColor;
  final Color lowerColor;
  final Color? referenceColor;
  final String semanticsLabel;
  final double height;

  /// Up to three labels spread across the X axis.
  final List<String> axisLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _TwoLinePainter(
            upper: upper,
            lower: lower,
            reference: reference,
            upperColor: upperColor,
            lowerColor: lowerColor,
            referenceColor: referenceColor,
            gridColor: theme.dividerColor,
            axisLabels: axisLabels,
            labelStyle:
                theme.textTheme.labelSmall ?? const TextStyle(fontSize: 11),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _TwoLinePainter extends CustomPainter {
  _TwoLinePainter({
    required this.upper,
    required this.lower,
    required this.reference,
    required this.upperColor,
    required this.lowerColor,
    required this.referenceColor,
    required this.gridColor,
    required this.axisLabels,
    required this.labelStyle,
  });

  final List<double> upper;
  final List<double> lower;
  final List<double>? reference;
  final Color upperColor;
  final Color lowerColor;
  final Color? referenceColor;
  final Color gridColor;
  final List<String> axisLabels;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (upper.length < 2 || lower.length < 2) {
      return;
    }
    final axisLane = axisLabels.isEmpty ? 0.0 : 16.0;
    final plot = Rect.fromLTRB(0, 6, size.width, size.height - axisLane);
    final all = [...upper, ...lower, ...?reference];
    final maxValue = all.fold<double>(0, math.max);
    final minValue = all.fold<double>(double.infinity, math.min);
    final span = math.max(maxValue - minValue, 1e-9);

    double x(int i, int length) =>
        plot.left + plot.width * (i / math.max(length - 1, 1));
    double y(double value) =>
        plot.bottom - plot.height * ((value - minValue) / span);

    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.45)
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final gy = plot.top + plot.height * i / 4;
      canvas.drawLine(Offset(plot.left, gy), Offset(plot.right, gy), gridPaint);
    }

    Path pathFor(List<double> series) {
      final path = Path()..moveTo(x(0, series.length), y(series.first));
      for (var i = 1; i < series.length; i++) {
        path.lineTo(x(i, series.length), y(series[i]));
      }
      return path;
    }

    // The shaded decision area between the two scenarios.
    final area = Path.from(pathFor(upper));
    for (var i = lower.length - 1; i >= 0; i--) {
      area.lineTo(x(i, lower.length), y(lower[i]));
    }
    area.close();
    canvas.drawPath(
      area,
      Paint()..color = upperColor.withValues(alpha: 0.16),
    );

    if (reference != null && reference!.length >= 2) {
      canvas.drawPath(
        pathFor(reference!),
        Paint()
          ..color = (referenceColor ?? gridColor).withValues(alpha: 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
    }
    canvas.drawPath(
      pathFor(upper),
      Paint()
        ..color = upperColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      pathFor(lower),
      Paint()
        ..color = lowerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < axisLabels.length; i++) {
      final painter = TextPainter(
        text: TextSpan(text: axisLabels[i], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final fraction = axisLabels.length == 1 ? 0.0 : i / (axisLabels.length - 1);
      final left = (plot.left + plot.width * fraction - painter.width * fraction)
          .clamp(0.0, size.width - painter.width);
      painter.paint(canvas, Offset(left, size.height - painter.height));
    }
  }

  @override
  bool shouldRepaint(_TwoLinePainter old) =>
      old.upper != upper ||
      old.lower != lower ||
      old.reference != reference ||
      old.upperColor != upperColor;
}
