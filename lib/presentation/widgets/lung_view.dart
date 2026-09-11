import 'package:flutter/material.dart';

import '../../core/theme.dart';

/// The breathing lung illustration (module report §6.④).
///
/// Three deliberate decisions live in this file:
///  - the lung is NEVER drawn black, diseased or photographic — load is a
///    mist, because fear without efficacy is the one thing shown not to work;
///  - it breathes at the same 4 s in / 6 s out tempo as the SOS screen, and
///    the breath OPENS as the load falls, so the state is felt before it is
///    read;
///  - reduce-motion collapses it to a still frame with the same mist, so no
///    information lives only in the animation.
class LungView extends StatefulWidget {
  const LungView({
    super.key,
    required this.mist,
    required this.semanticsLabel,
    this.height = 220,
    this.celebrate = false,
  });

  /// Relative particle load, 0..1 — drives the mist and the breath depth.
  final double mist;

  final String semanticsLabel;
  final double height;

  /// True in the window after a health milestone is reached: the outline
  /// glows once rather than firing confetti (module report §6.④).
  final bool celebrate;

  @override
  State<LungView> createState() => _LungViewState();
}

class _LungViewState extends State<LungView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10), // 4 s in, 6 s out
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Never leave a repeating animation running when the platform (or a
    // test) asks for reduced motion: the still frame carries the same
    // information, and an endless ticker would also drain battery.
    if (MediaQuery.of(context).disableAnimations) {
      _breath.stop();
    } else if (!_breath.isAnimating) {
      _breath.repeat();
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _breath,
          builder: (context, _) {
            // 0..1 over the inhale, back down over the longer exhale.
            final phase = _breath.value;
            final breath = phase < 0.4
                ? Curves.easeInOutSine.transform(phase / 0.4)
                : 1 - Curves.easeInOutSine.transform((phase - 0.4) / 0.6);
            return CustomPaint(
              painter: _LungPainter(
                glow: widget.celebrate,
                mist: widget.mist.clamp(0.0, 1.0),
                // A heavy load makes the breath shallower — the state is
                // legible without a single number.
                breath: reduceMotion ? 0.5 : breath,
                isLight: isLight,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _LungPainter extends CustomPainter {
  _LungPainter({
    required this.mist,
    required this.breath,
    required this.isLight,
    this.glow = false,
  });

  final double mist;
  final double breath;
  final bool isLight;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    // Breathing scale: lungs expand down and outwards
    final amplitude = 0.025 + 0.025 * (1 - mist);
    final scaleX = 1 - amplitude + amplitude * 2 * breath;
    final scaleY = 1 - (amplitude * 0.8) + (amplitude * 1.6) * breath;

    canvas.save();
    canvas.translate(size.width / 2, size.height * 0.55);
    canvas.scale(scaleX, scaleY);
    canvas.translate(-size.width / 2, -size.height * 0.55);

    final leftLobe = _leftLungPath(size);
    final rightLobe = _rightLungPath(size);

    // Color tones: Healthy mint/teal when clean, brownish-amber tint under heavy smoke load
    final baseTint = isLight ? HalenColors.petrol : HalenColors.mint;
    final smokeTint = const Color(0xFF7A583A);
    final currentTint = Color.lerp(baseTint, smokeTint, mist * 0.55)!;

    // Background lung parenchyma fill with smooth gradient
    final fillGradient = RadialGradient(
      center: const Alignment(0.0, -0.2),
      radius: 0.9,
      colors: [
        currentTint.withValues(alpha: isLight ? 0.22 : 0.32),
        currentTint.withValues(alpha: isLight ? 0.08 : 0.14),
      ],
    );

    final fillPaint = Paint()
      ..shader = fillGradient.createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    canvas.drawPath(leftLobe, fillPaint);
    canvas.drawPath(rightLobe, fillPaint);

    // Celebration glow around the perimeter if recently reached milestone
    if (glow) {
      final glowPaint = Paint()
        ..color = HalenColors.amberCta.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawPath(leftLobe, glowPaint);
      canvas.drawPath(rightLobe, glowPaint);
    }

    // Outer contour lines
    final contourPaint = Paint()
      ..color = currentTint.withValues(alpha: isLight ? 0.85 : 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(leftLobe, contourPaint);
    canvas.drawPath(rightLobe, contourPaint);

    // Anatomical fissures (lobes)
    final fissurePaint = Paint()
      ..color = currentTint.withValues(alpha: isLight ? 0.35 : 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    // Left oblique fissure
    final leftFissure = Path()
      ..moveTo(size.width * 0.41, size.height * 0.40)
      ..cubicTo(
        size.width * 0.33,
        size.height * 0.55,
        size.width * 0.25,
        size.height * 0.70,
        size.width * 0.20,
        size.height * 0.77,
      );
    canvas.drawPath(leftFissure, fissurePaint);

    // Right horizontal and oblique fissures (3 lobes: superior, middle, inferior)
    final rightHorizontal = Path()
      ..moveTo(size.width * 0.58, size.height * 0.50)
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.51,
        size.width * 0.75,
        size.height * 0.54,
        size.width * 0.80,
        size.height * 0.58,
      );
    final rightOblique = Path()
      ..moveTo(size.width * 0.59, size.height * 0.40)
      ..cubicTo(
        size.width * 0.67,
        size.height * 0.57,
        size.width * 0.73,
        size.height * 0.72,
        size.width * 0.79,
        size.height * 0.78,
      );
    canvas.drawPath(rightHorizontal, fissurePaint);
    canvas.drawPath(rightOblique, fissurePaint);

    // Particulate mist & tar load (rising from base and accumulating in alveolar pockets)
    if (mist > 0) {
      canvas.save();
      final fullPath = Path()
        ..addPath(leftLobe, Offset.zero)
        ..addPath(rightLobe, Offset.zero);
      canvas.clipPath(fullPath);

      final mistRect = Offset.zero & size;
      final mistTop = size.height * (1.0 - mist * 0.85);
      canvas.drawRect(
        Rect.fromLTRB(0, mistTop, size.width, size.height),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xFF5A412C).withValues(alpha: 0.65 * mist),
              const Color(0xFF6B5848).withValues(alpha: 0.35 * mist),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6, 1.0],
          ).createShader(mistRect),
      );
      canvas.restore();
    }

    // Branching Bronchial Tree & Trachea
    _drawBronchialTree(canvas, size, currentTint, isLight);

    canvas.restore();
  }

  void _drawBronchialTree(
    Canvas canvas,
    Size size,
    Color tint,
    bool isLight,
  ) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Trachea (windpipe with cartilaginous rings)
    final tracheaPaint = Paint()
      ..color = tint.withValues(alpha: isLight ? 0.75 : 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final ringPaint = Paint()
      ..color = tint.withValues(alpha: isLight ? 0.45 : 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // Main trachea vertical tube
    canvas.drawLine(Offset(cx, h * 0.08), Offset(cx, h * 0.34), tracheaPaint);

    // Tracheal rings (horizontal ribs)
    for (var r = 0.12; r <= 0.32; r += 0.04) {
      canvas.drawLine(
        Offset(cx - 5, h * r),
        Offset(cx + 5, h * r),
        ringPaint,
      );
    }

    // Carina and Primary Bronchi
    final primaryBronchus = Paint()
      ..color = tint.withValues(alpha: isLight ? 0.70 : 0.80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;

    // Left Main Bronchus (longer, more horizontal)
    final leftBronchus = Path()
      ..moveTo(cx, h * 0.34)
      ..cubicTo(cx - w * 0.05, h * 0.38, cx - w * 0.11, h * 0.44, w * 0.35, h * 0.49);
    canvas.drawPath(leftBronchus, primaryBronchus);

    // Right Main Bronchus (wider, more vertical)
    final rightBronchus = Path()
      ..moveTo(cx, h * 0.34)
      ..cubicTo(cx + w * 0.04, h * 0.37, cx + w * 0.09, h * 0.42, w * 0.63, h * 0.47);
    canvas.drawPath(rightBronchus, primaryBronchus);

    // Secondary & Tertiary Bronchial Branches (delicate organic tree)
    final treePaint = Paint()
      ..color = tint.withValues(alpha: isLight ? 0.45 : 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    // Left Lobe Branches
    final leftTree = Path()
      // Superior lobe branches
      ..moveTo(w * 0.35, h * 0.49)
      ..cubicTo(w * 0.32, h * 0.42, w * 0.30, h * 0.36, w * 0.28, h * 0.32)
      ..moveTo(w * 0.31, h * 0.40)
      ..lineTo(w * 0.23, h * 0.42)
      // Inferior lobe branches
      ..moveTo(w * 0.35, h * 0.49)
      ..cubicTo(w * 0.34, h * 0.58, w * 0.33, h * 0.68, w * 0.30, h * 0.77)
      ..moveTo(w * 0.34, h * 0.62)
      ..lineTo(w * 0.24, h * 0.68)
      ..moveTo(w * 0.33, h * 0.70)
      ..lineTo(w * 0.37, h * 0.81);
    canvas.drawPath(leftTree, treePaint);

    // Right Lobe Branches (3 zones: superior, middle, inferior)
    final rightTree = Path()
      // Superior lobe branch
      ..moveTo(w * 0.63, h * 0.47)
      ..cubicTo(w * 0.66, h * 0.40, w * 0.69, h * 0.34, w * 0.71, h * 0.30)
      ..moveTo(w * 0.67, h * 0.38)
      ..lineTo(w * 0.76, h * 0.38)
      // Middle lobe branch
      ..moveTo(w * 0.63, h * 0.47)
      ..cubicTo(w * 0.68, h * 0.52, w * 0.73, h * 0.54, w * 0.77, h * 0.56)
      // Inferior lobe branch
      ..moveTo(w * 0.63, h * 0.47)
      ..cubicTo(w * 0.65, h * 0.57, w * 0.66, h * 0.67, w * 0.68, h * 0.78)
      ..moveTo(w * 0.65, h * 0.60)
      ..lineTo(w * 0.74, h * 0.67)
      ..moveTo(w * 0.66, h * 0.71)
      ..lineTo(w * 0.61, h * 0.82);
    canvas.drawPath(rightTree, treePaint);
  }

  /// Left Lung: Anatomically narrower at apex, distinct cardiac notch for the heart.
  Path _leftLungPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // Start at apex
    path.moveTo(w * 0.43, h * 0.24);
    // Lateral curve downwards
    path.cubicTo(w * 0.33, h * 0.25, w * 0.17, h * 0.38, w * 0.16, h * 0.62);
    // Inferior border / base (concave to rest over diaphragm)
    path.cubicTo(w * 0.155, h * 0.81, w * 0.24, h * 0.91, w * 0.35, h * 0.88);
    // Medial ascent with Cardiac Notch
    path.cubicTo(w * 0.41, h * 0.86, w * 0.43, h * 0.75, w * 0.41, h * 0.62);
    path.cubicTo(w * 0.40, h * 0.54, w * 0.44, h * 0.38, w * 0.43, h * 0.24);
    path.close();
    return path;
  }

  /// Right Lung: Broader, 3-lobed silhouette with elevated base for the liver.
  Path _rightLungPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // Start at apex
    path.moveTo(w * 0.57, h * 0.24);
    // Medial descent towards hilum
    path.cubicTo(w * 0.56, h * 0.38, w * 0.60, h * 0.54, w * 0.58, h * 0.62);
    path.cubicTo(w * 0.57, h * 0.74, w * 0.58, h * 0.84, w * 0.64, h * 0.87);
    // Base (slightly elevated by underlying liver dome)
    path.cubicTo(w * 0.75, h * 0.90, w * 0.84, h * 0.80, w * 0.84, h * 0.62);
    // Lateral curve upwards to apex
    path.cubicTo(w * 0.83, h * 0.38, w * 0.67, h * 0.25, w * 0.57, h * 0.24);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_LungPainter old) =>
      old.mist != mist ||
      old.breath != breath ||
      old.isLight != isLight ||
      old.glow != glow;
}
