import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Daily load band (module report §1.④, the secondary chart): one bar per
/// day, drawn from that day's mean modelled load with the day's peak marked
/// on top.
///
/// It answers a different question from the 24-hour sawtooth — "is the whole
/// week coming down?" — so it stays deliberately coarse: no numbers on the
/// bars, one sentence above it, and a trend line that the caller words.
class LoadBandChart extends StatelessWidget {
  const LoadBandChart({
    super.key,
    required this.means,
    required this.peaks,
    required this.color,
    required this.semanticsLabel,
    this.height = 120,
  });

  /// Mean normalized load per day (0–100), oldest first.
  final List<int> means;

  /// Peak normalized load per day (0–100), oldest first, same length.
  final List<int> peaks;

  final Color color;
  final String semanticsLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        child: CustomPaint(
          painter: _LoadBandPainter(
            means: means,
            peaks: peaks,
            color: color,
            gridColor: Theme.of(context).dividerColor,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _LoadBandPainter extends CustomPainter {
  _LoadBandPainter({
    required this.means,
    required this.peaks,
    required this.color,
    required this.gridColor,
  });

  final List<int> means;
  final List<int> peaks;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (means.isEmpty) {
      return;
    }
    final slot = size.width / means.length;
    final barWidth = math.min(slot * 0.62, 18.0);
    final radius = Radius.circular(barWidth / 3);

    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      Paint()
        ..color = gridColor.withValues(alpha: 0.5)
        ..strokeWidth = 1,
    );

    for (var i = 0; i < means.length; i++) {
      final centre = slot * i + slot / 2;
      final meanHeight = size.height * (means[i] / 100);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            centre - barWidth / 2,
            size.height - meanHeight,
            barWidth,
            math.max(meanHeight, 2),
          ),
          radius,
        ),
        Paint()..color = color.withValues(alpha: 0.75),
      );

      // The day's peak as a slim cap above the mean — the shape of a heavy
      // day is different from a busy one, and that difference is the point.
      if (i < peaks.length && peaks[i] > means[i]) {
        final peakY = size.height - size.height * (peaks[i] / 100);
        canvas.drawLine(
          Offset(centre - barWidth / 2, peakY),
          Offset(centre + barWidth / 2, peakY),
          Paint()
            ..color = color
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LoadBandPainter old) =>
      old.means != means || old.peaks != peaks || old.color != color;
}
