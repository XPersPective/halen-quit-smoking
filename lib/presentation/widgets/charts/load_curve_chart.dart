import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../domain/body_load_model.dart';

/// The signature chart of the product (module report §1.④): 24 hours of the
/// modelled body load as a sawtooth — a steep rise at every cigarette and an
/// exponential fall between them, so the user sees their OWN rhythm.
///
/// Deliberate constraints from the report's chart rules:
///  - the Y axis carries band names (Low / Medium / High), never numbers, so
///    nothing here can be read as a measured concentration;
///  - at most three grid lines and no point markers (96 samples would be
///    noise);
///  - every cigarette gets a tick on the baseline, and every ride-out gets a
///    dashed "ghost peak" — the peak that never happened;
///  - one text summary is exposed to screen readers instead of 96 points.
class LoadCurveChart extends StatelessWidget {
  const LoadCurveChart({
    super.key,
    required this.samples,
    required this.events,
    required this.ghostEvents,
    required this.color,
    required this.bandLabels,
    required this.semanticsLabel,
    this.height = 168,
  });

  /// Normalized 0–100 samples across the window.
  final List<LoadSample> samples;

  /// Cigarette times inside the window — the baseline ticks.
  final List<DateTime> events;

  /// Rides-out inside the window — the dashed peaks that never happened.
  final List<DateTime> ghostEvents;

  final Color color;

  /// Low / Medium / High labels, bottom to top.
  final List<String> bandLabels;

  final String semanticsLabel;
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
          painter: _LoadCurvePainter(
            samples: samples,
            events: events,
            ghostEvents: ghostEvents,
            color: color,
            bandLabels: bandLabels,
            labelStyle: theme.textTheme.labelSmall ?? const TextStyle(fontSize: 11),
            gridColor: theme.dividerColor,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _LoadCurvePainter extends CustomPainter {
  _LoadCurvePainter({
    required this.samples,
    required this.events,
    required this.ghostEvents,
    required this.color,
    required this.bandLabels,
    required this.labelStyle,
    required this.gridColor,
  });

  final List<LoadSample> samples;
  final List<DateTime> events;
  final List<DateTime> ghostEvents;
  final Color color;
  final List<String> bandLabels;
  final TextStyle labelStyle;
  final Color gridColor;

  static const double _tickLane = 14;
  static const double _labelGutter = 52;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) {
      return;
    }
    final plot = Rect.fromLTRB(
      _labelGutter,
      6,
      size.width,
      size.height - _tickLane,
    );
    final start = samples.first.at;
    final span = samples.last.at.difference(start).inMilliseconds;
    if (span <= 0 || plot.width <= 0 || plot.height <= 0) {
      return;
    }

    double xFor(DateTime at) =>
        plot.left +
        plot.width *
            (at.difference(start).inMilliseconds / span).clamp(0.0, 1.0);
    double yFor(num value) => plot.bottom - plot.height * (value / 100);

    // Three band lines, labelled instead of numbered.
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final value = [17, 50, 84][i];
      final y = yFor(value);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      _text(canvas, bandLabels[i], Offset(0, y - 7), _labelGutter - 8);
    }

    // Curve plus its fill.
    final path = Path()..moveTo(xFor(samples.first.at), yFor(samples.first.value));
    for (final sample in samples.skip(1)) {
      path.lineTo(xFor(sample.at), yFor(sample.value));
    }
    final fill = Path.from(path)
      ..lineTo(xFor(samples.last.at), plot.bottom)
      ..lineTo(xFor(samples.first.at), plot.bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.20),
            color.withValues(alpha: 0.0),
          ],
        ).createShader(plot),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );

    // Ghost peaks: the rise that would have happened, drawn dashed.
    final ghostPaint = Paint()
      ..color = HalenColors.emerald
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final ghost in ghostEvents) {
      final x = xFor(ghost);
      final baseIndex = _nearestIndex(ghost);
      final peak = math.min(100, samples[baseIndex].value + 34);
      _dashedLine(canvas, Offset(x, plot.bottom), Offset(x, yFor(peak)), ghostPaint);
      canvas.drawCircle(Offset(x, yFor(peak)), 2.5, Paint()..color = HalenColors.emerald);
    }

    // Baseline ticks: one per cigarette.
    final tickPaint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final event in events) {
      final x = xFor(event);
      canvas.drawLine(
        Offset(x, plot.bottom + 3),
        Offset(x, plot.bottom + 9),
        tickPaint,
      );
    }

    // "Now" line at the right edge.
    final nowX = xFor(samples.last.at);
    canvas.drawLine(
      Offset(nowX, plot.top),
      Offset(nowX, plot.bottom),
      Paint()
        ..color = color.withValues(alpha: 0.45)
        ..strokeWidth = 1,
    );
    canvas.drawCircle(
      Offset(nowX, yFor(samples.last.value)),
      4,
      Paint()..color = color,
    );
  }

  int _nearestIndex(DateTime at) {
    var best = 0;
    var bestDelta = double.infinity;
    for (var i = 0; i < samples.length; i++) {
      final delta = samples[i].at.difference(at).inMinutes.abs().toDouble();
      if (delta < bestDelta) {
        bestDelta = delta;
        best = i;
      }
    }
    return best;
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dash = 4.0;
    const gap = 3.0;
    final total = (to - from).distance;
    if (total <= 0) {
      return;
    }
    final direction = (to - from) / total;
    var drawn = 0.0;
    while (drawn < total) {
      final end = math.min(drawn + dash, total);
      canvas.drawLine(from + direction * drawn, from + direction * end, paint);
      drawn = end + gap;
    }
  }

  void _text(Canvas canvas, String value, Offset at, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: labelStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(_LoadCurvePainter old) =>
      old.samples != samples ||
      old.events != events ||
      old.ghostEvents != ghostEvents ||
      old.color != color;
}
