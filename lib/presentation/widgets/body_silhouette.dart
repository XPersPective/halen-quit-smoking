import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The human figure behind the body map, redrawn to look like a body.
///
/// The first figure was assembled from separate pieces — a circle for a head,
/// a rectangle for a neck, a boxy torso, and arms and legs built from
/// straight-line polygons. The pieces showed their seams, the limbs had
/// visible facets, and the proportions were a snowman's: shoulders far too
/// wide, no waist. It read as a placeholder, and the user said so.
///
/// What changed, and why each matters:
///
///  * **one outline.** Head, neck, torso-and-legs and both arms are built
///    separately and merged with a path union, so the figure is a single
///    shape: no seams, and no darker overlap where a translucent arm crosses
///    a translucent shoulder;
///  * **no corners anywhere.** Every contour runs through a closed
///    Catmull-Rom spline, so a limb is a curve, not a polygon;
///  * **human proportions.** Roughly eight heads tall, sloping trapezius,
///    a waist narrower than the shoulders and the hips, tapering knees and
///    ankles, arms hanging slightly away from the body;
///  * **depth.** A vertical gradient, a soft glassy highlight on the chest,
///    a faint outer glow, a few quiet anatomical cues (collar bones,
///    sternum, navel) and a ground shadow. The cues are drawn at very low
///    contrast — enough to read as a considered figure, not enough to become
///    an anatomy plate.
///
/// Everything is defined in **body space**: x is the offset from the
/// centreline and y the distance from the top of the head, both in units of
/// the figure's height. [BodyFrame] maps that onto any canvas, so the organs
/// stay inside the body on any screen width — the old map placed them by
/// fractions of the canvas width, which only lined up at one size.
abstract final class BodyGeometry {
  /// Half-width of the widest point (the hands), in body heights, plus a
  /// little air. Used to fit the figure to narrow canvases.
  static const double halfSpan = 0.20;

  /// Where each drawn organ sits, and how big it is, in body space.
  static const Map<String, (Offset, Size)> organs = {
    'brain': (Offset(0, 0.050), Size(0.080, 0.056)),
    'mouth': (Offset(0, 0.099), Size(0.034, 0.013)),
    'lungs': (Offset(0, 0.272), Size(0.170, 0.128)),
    // Below the lungs' centre on purpose: close enough to read as resting
    // on the diaphragm between them, far enough that its tap target does not
    // cover the centre of the lungs.
    'heart': (Offset(0.026, 0.340), Size(0.064, 0.056)),
    'liver': (Offset(-0.032, 0.384), Size(0.100, 0.054)),
    'stomach': (Offset(0.040, 0.394), Size(0.068, 0.056)),
    'kidneyBladder': (Offset(0, 0.454), Size(0.100, 0.048)),
  };

  /// The right half of the torso-and-legs outline, top of the neck down to
  /// the crotch, in body space. The left half is its mirror.
  static const List<Offset> torsoRight = [
    Offset(0.000, 0.112),
    Offset(0.024, 0.114),
    Offset(0.027, 0.148),
    Offset(0.062, 0.166),
    Offset(0.104, 0.180),
    Offset(0.122, 0.204),
    Offset(0.114, 0.245),
    Offset(0.106, 0.300),
    Offset(0.095, 0.360),
    Offset(0.084, 0.420),
    Offset(0.092, 0.470),
    Offset(0.108, 0.530),
    Offset(0.106, 0.590),
    Offset(0.090, 0.680),
    Offset(0.070, 0.770),
    Offset(0.072, 0.830),
    Offset(0.052, 0.920),
    Offset(0.040, 0.955),
    Offset(0.058, 0.980),
    Offset(0.032, 0.993),
    Offset(0.016, 0.976),
    Offset(0.018, 0.945),
    Offset(0.022, 0.860),
    Offset(0.016, 0.775),
    Offset(0.012, 0.680),
    Offset(0.006, 0.606),
    Offset(0.000, 0.599),
  ];

  /// The right arm's centreline, shoulder to fingertips, with the arm's
  /// half-width at each point.
  static const List<(Offset, double)> armRight = [
    (Offset(0.110, 0.192), 0.028),
    (Offset(0.138, 0.268), 0.026),
    (Offset(0.150, 0.350), 0.021),
    (Offset(0.160, 0.430), 0.019),
    (Offset(0.166, 0.500), 0.016),
    (Offset(0.168, 0.540), 0.018),
  ];

  static const Offset headCentre = Offset(0, 0.066);
  static const double headRadiusX = 0.048;
  static const double headRadiusY = 0.062;
}

/// Maps body space onto a canvas: fitted to the height (and to the width,
/// on narrow screens), centred, with a small margin.
class BodyFrame {
  factory BodyFrame(Size size) {
    final byHeight = size.height * 0.94;
    final byWidth = size.width / (2 * BodyGeometry.halfSpan);
    final h = math.min(byHeight, byWidth);
    return BodyFrame._(h, (size.height - h) / 2, size.width / 2);
  }

  const BodyFrame._(this.h, this.top, this.cx);

  /// The figure's height in pixels.
  final double h;
  final double top;
  final double cx;

  Offset point(Offset body) => Offset(cx + body.dx * h, top + body.dy * h);

  Size box(Size body) => Size(body.width * h, body.height * h);
}

/// Builds the single merged outline.
abstract final class BodySilhouette {
  static Path path(BodyFrame frame) {
    final right = BodyGeometry.torsoRight;
    final loop = <Offset>[
      ...right,
      for (final p in right.reversed.skip(1).take(right.length - 2))
        Offset(-p.dx, p.dy),
    ];
    var body = _spline([for (final p in loop) frame.point(p)]);

    final head = Path()
      ..addOval(
        Rect.fromCenter(
          center: frame.point(BodyGeometry.headCentre),
          width: BodyGeometry.headRadiusX * 2 * frame.h,
          height: BodyGeometry.headRadiusY * 2 * frame.h,
        ),
      );
    body = Path.combine(PathOperation.union, body, head);
    for (final side in const [1.0, -1.0]) {
      body = Path.combine(PathOperation.union, body, _arm(frame, side));
    }
    return body;
  }

  /// One arm as a smooth closed outline around its centreline.
  static Path _arm(BodyFrame frame, double side) {
    final spine = [
      for (final (p, w) in BodyGeometry.armRight) (Offset(p.dx * side, p.dy), w),
    ];
    final outer = <Offset>[];
    final inner = <Offset>[];
    for (var i = 0; i < spine.length; i++) {
      final before = spine[math.max(0, i - 1)].$1;
      final after = spine[math.min(spine.length - 1, i + 1)].$1;
      final dir = after - before;
      final len = dir.distance;
      final normal =
          len == 0 ? const Offset(1, 0) : Offset(-dir.dy / len, dir.dx / len);
      final (p, w) = spine[i];
      outer.add(p + normal * w);
      inner.add(p - normal * w);
    }
    // A rounded fingertip: one point past the end of the centreline.
    final last = spine.last.$1;
    final prev = spine[spine.length - 2].$1;
    final tipDir = last - prev;
    final tip = last + tipDir / tipDir.distance * spine.last.$2;
    final outline = [...outer, tip, ...inner.reversed];
    return _spline([for (final p in outline) frame.point(p)]);
  }

  /// A closed Catmull-Rom spline through [points], as cubic Béziers. This is
  /// what removes every corner: each segment's handles come from the points
  /// either side of it, so the curve is smooth through every point.
  static Path _spline(List<Offset> points) {
    final path = Path();
    final n = points.length;
    if (n < 3) {
      return path;
    }
    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 0; i < n; i++) {
      final p0 = points[(i - 1 + n) % n];
      final p1 = points[i];
      final p2 = points[(i + 1) % n];
      final p3 = points[(i + 2) % n];
      final c1 = p1 + (p2 - p0) / 6;
      final c2 = p2 - (p3 - p1) / 6;
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    path.close();
    return path;
  }
}

class BodySilhouettePainter extends CustomPainter {
  BodySilhouettePainter({
    required this.tint,
    required this.outline,
    required this.highlight,
  });

  final Color tint;
  final Color outline;
  final Color highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final frame = BodyFrame(size);
    final body = BodySilhouette.path(frame);
    final bounds = body.getBounds();

    // Ground shadow, so the figure stands rather than floats.
    canvas.drawOval(
      Rect.fromCenter(
        center: frame.point(const Offset(0, 0.995)),
        width: 0.30 * frame.h,
        height: 0.024 * frame.h,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // A soft outer glow in the tint.
    canvas.drawPath(
      body,
      Paint()
        ..color = tint.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Body fill: lit from above, fading towards the feet.
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tint.withValues(alpha: 0.20),
            tint.withValues(alpha: 0.10),
            tint.withValues(alpha: 0.05),
          ],
          stops: const [0.0, 0.45, 1.0],
        ).createShader(bounds),
    );

    // A glassy highlight across the chest, clipped to the body.
    canvas
      ..save()
      ..clipPath(body)
      ..drawRect(
        bounds,
        Paint()
          ..shader = RadialGradient(
            colors: [
              highlight.withValues(alpha: 0.38),
              highlight.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: frame.point(const Offset(-0.035, 0.24)),
              radius: 0.30 * frame.h,
            ),
          ),
      )
      ..restore();

    // Quiet anatomical cues: collar bones, sternum, navel.
    final cue = Paint()
      ..color = outline.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (final side in const [1.0, -1.0]) {
      final a = frame.point(Offset(0.012 * side, 0.160));
      final c = frame.point(Offset(0.052 * side, 0.170));
      final b = frame.point(Offset(0.094 * side, 0.184));
      canvas.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..quadraticBezierTo(c.dx, c.dy, b.dx, b.dy),
        cue,
      );
    }
    final sternumTop = frame.point(const Offset(0, 0.186));
    final sternumBottom = frame.point(const Offset(0, 0.330));
    canvas
      ..drawLine(sternumTop, sternumBottom, cue)
      ..drawCircle(frame.point(const Offset(0, 0.470)), 0.0045 * frame.h, cue);

    // The outline, darker at the head and fading down.
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            outline.withValues(alpha: 0.55),
            outline.withValues(alpha: 0.28),
          ],
        ).createShader(bounds)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(BodySilhouettePainter old) =>
      old.tint != tint || old.outline != outline || old.highlight != highlight;
}
