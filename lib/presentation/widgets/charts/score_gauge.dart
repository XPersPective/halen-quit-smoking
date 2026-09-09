import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

/// The Progress Score gauge (module report §14.1).
///
/// Replaces the two-line "scissor" chart as the primary read: a score out of
/// a hundred is a fraction, and an arc is how people read fractions at a
/// glance. The arc carries only three things — the number, the band it sits
/// in, and which way it moved this week — because that is the whole answer
/// to "am I getting better?".
class ScoreGauge extends StatelessWidget {
  const ScoreGauge({
    super.key,
    required this.score,
    required this.band,
    required this.delta,
    required this.deltaLabel,
    required this.color,
    required this.semanticsLabel,
    this.size = 176,
  });

  /// 0–100.
  final int score;

  /// The band name shown under the number ("On track", "Strong"…).
  final String band;

  /// Change over the last seven days, in points.
  final int delta;

  /// The sentence form of [delta], already localized.
  final String deltaLabel;

  final Color color;
  final String semanticsLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size * 0.78,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score / 100),
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => CustomPaint(
                size: Size(size, size * 0.78),
                painter: _GaugePainter(
                  fraction: value,
                  color: color,
                  track: theme.dividerColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size * 0.10),
              // At large text scales the number, band and delta cannot keep
              // their natural size inside the arc — scaling the group down
              // keeps the dial readable instead of overflowing it.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: -1.5,
                      ),
                    ),
                    Text(band, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          delta > 0
                              ? Icons.arrow_upward_rounded
                              : delta < 0
                              ? Icons.arrow_downward_rounded
                              : Icons.remove_rounded,
                          size: 13,
                          color: color,
                        ),
                        const SizedBox(width: 3),
                        Text(deltaLabel, style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.fraction,
    required this.color,
    required this.track,
  });

  /// 0..1 of the arc that is filled.
  final double fraction;
  final Color color;
  final Color track;

  /// A 240° arc opening downward — the shape reads as a dial, and the gap at
  /// the bottom leaves room for the label without crowding the number.
  static const _startAngle = math.pi * 0.83;
  static const _sweep = math.pi * 1.34;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.075;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.width - stroke,
    );

    canvas.drawArc(
      rect,
      _startAngle,
      _sweep,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
    if (fraction <= 0) {
      return;
    }
    canvas.drawArc(
      rect,
      _startAngle,
      _sweep * fraction.clamp(0.0, 1.0),
      false,
      Paint()
        ..shader = SweepGradient(
          startAngle: _startAngle,
          endAngle: _startAngle + _sweep,
          colors: [color.withValues(alpha: 0.55), color],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.fraction != fraction || old.color != color;
}

/// The Harm Load scale (module report §14.2).
///
/// A load is not a fraction of an achievement, so it does not get an arc: it
/// gets a bar with its four named bands drawn in, and a marker showing where
/// the user sits. The bands are the point — a number without them is
/// meaningless, and the report forbids dressing it up as a disease risk.
class HarmScale extends StatelessWidget {
  const HarmScale({
    super.key,
    required this.score,
    required this.bandLabels,
    required this.activeBand,
    required this.semanticsLabel,
  });

  /// 0–100.
  final int score;

  /// Four band names, light → very heavy.
  final List<String> bandLabels;

  /// Index of the band [score] falls in.
  final int activeBand;

  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                bandLabels[activeBand.clamp(0, bandLabels.length - 1)],
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: score / 100),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 650),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => SizedBox(
              height: 26,
              width: double.infinity,
              child: CustomPaint(
                painter: _HarmScalePainter(
                  fraction: value,
                  // Charcoal to warm, never red: this is a load the user
                  // is carrying, not an alarm they have triggered.
                  colors: const [
                    HalenColors.mint,
                    HalenColors.emerald,
                    HalenColors.amberCta,
                    HalenColors.coral,
                  ],
                  markerColor: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in bandLabels)
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HarmScalePainter extends CustomPainter {
  _HarmScalePainter({
    required this.fraction,
    required this.colors,
    required this.markerColor,
  });

  final double fraction;
  final List<Color> colors;
  final Color markerColor;

  @override
  void paint(Canvas canvas, Size size) {
    const barHeight = 12.0;
    final top = (size.height - barHeight) / 2;
    final segment = size.width / colors.length;

    for (var i = 0; i < colors.length; i++) {
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(segment * i + 1, top, segment - 2, barHeight),
        topLeft: Radius.circular(i == 0 ? 6 : 2),
        bottomLeft: Radius.circular(i == 0 ? 6 : 2),
        topRight: Radius.circular(i == colors.length - 1 ? 6 : 2),
        bottomRight: Radius.circular(i == colors.length - 1 ? 6 : 2),
      );
      canvas.drawRRect(rect, Paint()..color = colors[i].withValues(alpha: 0.5));
    }

    // The marker: a filled pin, so the position is readable without relying
    // on the band colours alone.
    final x = (size.width * fraction).clamp(6.0, size.width - 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 3, top - 5, 6, barHeight + 10),
        const Radius.circular(3),
      ),
      Paint()..color = markerColor,
    );
  }

  @override
  bool shouldRepaint(_HarmScalePainter old) =>
      old.fraction != fraction || old.markerColor != markerColor;
}
