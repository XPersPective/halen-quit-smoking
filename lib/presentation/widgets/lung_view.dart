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
    final amplitude = 0.02 + 0.02 * (1 - mist); // heavier load, shallower breath
    final scale = 1 - amplitude + amplitude * 2 * breath;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);
    canvas.translate(-size.width / 2, -size.height / 2);

    final body = _lungPath(size);
    final tint = isLight ? HalenColors.petrol : HalenColors.mint;

    canvas.drawPath(
      body,
      Paint()..color = tint.withValues(alpha: isLight ? 0.10 : 0.16),
    );
    if (glow) {
      // One soft halo on the outline — the milestone is marked, not partied.
      canvas.drawPath(
        body,
        Paint()
          ..color = HalenColors.amberCta.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
    }
    canvas.drawPath(
      body,
      Paint()
        ..color = tint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Mist: a soft haze rising from the base, never a "percent cleaned".
    if (mist > 0) {
      canvas.save();
      canvas.clipPath(body);
      final rect = Offset.zero & size;
      final top = size.height * (1 - mist * 0.8);
      canvas.drawRect(
        Rect.fromLTRB(0, top, size.width, size.height),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xFF6B6B6B).withValues(alpha: 0.55 * mist),
              const Color(0xFF6B6B6B).withValues(alpha: 0.0),
            ],
          ).createShader(rect),
      );
      canvas.restore();
    }

    // Airways.
    final airway = Paint()
      ..color = tint.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2;
    canvas.drawLine(
      Offset(cx, size.height * 0.08),
      Offset(cx, size.height * 0.42),
      airway,
    );
    canvas.drawLine(
      Offset(cx, size.height * 0.42),
      Offset(size.width * 0.34, size.height * 0.55),
      airway,
    );
    canvas.drawLine(
      Offset(cx, size.height * 0.42),
      Offset(size.width * 0.66, size.height * 0.55),
      airway,
    );

    canvas.restore();
  }

  /// Two symmetric lobes, drawn as one path so the mist clips cleanly.
  Path _lungPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();

    // Left lobe.
    path.moveTo(w * 0.46, h * 0.34);
    path.cubicTo(w * 0.30, h * 0.32, w * 0.16, h * 0.48, w * 0.18, h * 0.70);
    path.cubicTo(w * 0.19, h * 0.86, w * 0.30, h * 0.94, w * 0.40, h * 0.90);
    path.cubicTo(w * 0.47, h * 0.87, w * 0.47, h * 0.70, w * 0.46, h * 0.34);
    path.close();

    // Right lobe (mirrored).
    path.moveTo(w * 0.54, h * 0.34);
    path.cubicTo(w * 0.70, h * 0.32, w * 0.84, h * 0.48, w * 0.82, h * 0.70);
    path.cubicTo(w * 0.81, h * 0.86, w * 0.70, h * 0.94, w * 0.60, h * 0.90);
    path.cubicTo(w * 0.53, h * 0.87, w * 0.53, h * 0.70, w * 0.54, h * 0.34);
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
