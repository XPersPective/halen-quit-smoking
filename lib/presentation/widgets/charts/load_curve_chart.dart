import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/dates.dart';
import '../../../core/design/typography.dart';
import '../../../core/theme.dart';
import '../../../domain/body_load_model.dart';
import '../../../core/design/tokens.dart';

/// The signature chart of the product (module report §1.④): 24 hours of the
/// modelled body load as a sawtooth — a steep rise at every cigarette and an
/// exponential fall between them, so the user sees their OWN rhythm.
///
/// Deliberate constraints from the report's chart rules:
///  - the Y axis is numbered, but in the only unit this model can honestly
///    produce: PERCENT OF THE USER'S OWN 24-HOUR PEAK. A chart whose axis
///    means nothing is decoration, so the axis is labelled and captioned —
///    and because the unit is self-relative, nothing here can be read as a
///    measured concentration (no ng/mL, no COHb%, no mg);
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
    required this.axisCaption,
    required this.timeLabels,
    required this.locale,
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

  /// What the Y axis measures, e.g. "% of your own peak" — drawn above the
  /// plot so the numbers are never naked.
  final String axisCaption;

  /// Three x-axis labels, left to right (window start, midpoint, "now").
  final List<String> timeLabels;

  /// Language code, for writing the percent sign on the correct side.
  final String locale;

  final String semanticsLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            axisCaption,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: HalenSpace.x1),
          SizedBox(
            height: height,
            child: CustomPaint(
              painter: _LoadCurvePainter(
                samples: samples,
                events: events,
                ghostEvents: ghostEvents,
                color: color,
                timeLabels: timeLabels,
                locale: locale,
                labelStyle: (theme.textTheme.labelSmall ??
                      const TextStyle(fontSize: 11))
                  .asNumber,
                gridColor: theme.dividerColor,
              ),
              size: Size.infinite,
            ),
          ),
        ],
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
    required this.timeLabels,
    required this.locale,
    required this.labelStyle,
    required this.gridColor,
  });

  final List<LoadSample> samples;
  final List<DateTime> events;
  final List<DateTime> ghostEvents;
  final Color color;
  final List<String> timeLabels;
  final String locale;
  final TextStyle labelStyle;
  final Color gridColor;

  /// Room under the plot for the cigarette ticks and the time labels.
  static const double _tickLane = 28;

  /// Room at the left for the percentage labels.
  ///
  /// Tabular figures are wider than proportional ones — that is the point of
  /// them — so the gutter that fitted "100%" before the type change clipped
  /// it to "10…" after. Sized against the widest label the axis can produce.
  static const double _labelGutter = 48;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) {
      return;
    }
    // The "now" dot sits on the right edge, so the plot stops short of the
    // canvas — otherwise the marker is sliced in half by the card.
    final plot = Rect.fromLTRB(
      _labelGutter,
      HalenSpace.x3,
      size.width - HalenSpace.x4,
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

    // A numbered scale: 0, 50 and 100 percent of the user's own peak. The
    // caption above the plot carries the unit.
    final gridPaint = Paint()
      ..color = gridColor.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (final value in [0, 50, 100]) {
      final y = yFor(value);
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      _text(
        canvas,
        formatPercent(value, locale),
        Offset(0, y - 7),
        _labelGutter - 6,
      );
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

    // Time labels under the tick lane: without them the X axis is as mute
    // as an unlabelled Y axis was.
    // Evenly spaced, any count: five ticks (24, 18, 12, 6 hours, now) say
    // far more about when than the old three did.
    for (var i = 0; i < timeLabels.length; i++) {
      final align = timeLabels.length == 1 ? 1.0 : i / (timeLabels.length - 1);
      final width = timeLabels.length > 3 ? 46.0 : 64.0;
      final x = (plot.left + plot.width * align - width * align)
          .clamp(0.0, size.width - width);
      _text(
        canvas,
        timeLabels[i],
        Offset(x, plot.bottom + 12),
        width,
        align: align,
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

  void _text(
    Canvas canvas,
    String value,
    Offset at,
    double maxWidth, {
    double align = 0,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: labelStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);
    painter.paint(canvas, at.translate((maxWidth - painter.width) * align, 0));
  }

  @override
  bool shouldRepaint(_LoadCurvePainter old) =>
      old.samples != samples ||
      old.events != events ||
      old.ghostEvents != ghostEvents ||
      old.timeLabels != timeLabels ||
      old.color != color;
}
