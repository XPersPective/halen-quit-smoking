import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme.dart';
import '../../data/repositories/library_repository.dart';

/// A tappable, breathing body map (module report §7.④).
///
/// The card list this replaces was accurate and lifeless. Three decisions
/// shape what is here instead:
///
///  * **it breathes.** Every hotspot pulses on a slow shared clock — one
///    four-second cycle for the whole body, so the figure reads as alive
///    rather than as twelve blinking dots competing for attention;
///  * **selection is a movement, not a jump.** The chosen organ grows, the
///    others fade back, and the detail slides in underneath — a state change
///    the eye can follow;
///  * **still no gore and no personal percentages.** The figure is a single
///    calm outline, and every number attached to it is population-level and
///    labelled as such on the same screen.
///
/// Reduce-motion collapses the pulse and the transitions to static frames;
/// nothing here is information that only the animation carries.
class BodyMapView extends StatefulWidget {
  const BodyMapView({
    super.key,
    required this.organs,
    required this.selectedKey,
    required this.onSelected,
    required this.locale,
    this.height = 330,
  });

  final List<OrganEntry> organs;

  /// The currently open organ, or null when nothing is selected.
  final String? selectedKey;

  final ValueChanged<String> onSelected;
  final String locale;
  final double height;

  @override
  State<BodyMapView> createState() => _BodyMapViewState();
}

class _BodyMapViewState extends State<BodyMapView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// Where each organ sits on the figure, in fractions of the canvas.
  static const hotspots = <String, Offset>{
    'brain': Offset(0.50, 0.075),
    'eyes': Offset(0.435, 0.105),
    'mouth': Offset(0.50, 0.155),
    'lungs': Offset(0.415, 0.315),
    'heart': Offset(0.545, 0.315),
    'liver': Offset(0.425, 0.425),
    'stomach': Offset(0.555, 0.435),
    'kidneyBladder': Offset(0.50, 0.520),
    'bloodVessels': Offset(0.355, 0.470),
    'immune': Offset(0.645, 0.470),
    'reproductive': Offset(0.50, 0.600),
    'skin': Offset(0.560, 0.720),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, widget.height);
          return AnimatedBuilder(
            animation: _pulse,
            builder: (context, _) {
              final phase = reduceMotion ? 0.5 : _pulse.value;
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BodyPainter(
                        outline: theme.colorScheme.onSurface
                            .withValues(alpha: 0.30),
                        fill: theme.colorScheme.primary.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  for (final organ in widget.organs)
                    if (hotspots[organ.key] != null)
                      _Hotspot(
                        organ: organ,
                        locale: widget.locale,
                        position: hotspots[organ.key]!,
                        canvas: size,
                        phase: phase,
                        selected: widget.selectedKey == organ.key,
                        dimmed: widget.selectedKey != null &&
                            widget.selectedKey != organ.key,
                        reduceMotion: reduceMotion,
                        onTap: () {
                          if (!reduceMotion) {
                            HapticFeedback.selectionClick();
                          }
                          widget.onSelected(organ.key);
                        },
                      ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _Hotspot extends StatelessWidget {
  const _Hotspot({
    required this.organ,
    required this.locale,
    required this.position,
    required this.canvas,
    required this.phase,
    required this.selected,
    required this.dimmed,
    required this.reduceMotion,
    required this.onTap,
  });

  final OrganEntry organ;
  final String locale;
  final Offset position;
  final Size canvas;

  /// Shared 0..1 clock for the whole body.
  final double phase;

  final bool selected;
  final bool dimmed;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Each hotspot is offset along the shared cycle by its own position, so
    // the body ripples instead of flashing in unison.
    final local = (phase + position.dy) % 1.0;
    final pulse = 0.5 - 0.5 * math.cos(local * 2 * math.pi);
    // A stronger population link breathes a little more strongly. It is a
    // hint, never the information itself — the number is written out below.
    final weight = 0.35 + 0.65 * organ.impact.barFraction;
    final base = selected ? 26.0 : 20.0;
    final radius = reduceMotion ? base : base + 3 * pulse * weight;

    final color = selected
        ? HalenColors.amberCta
        : theme.colorScheme.primary;

    return Positioned(
      left: position.dx * canvas.width - radius,
      top: position.dy * canvas.height - radius,
      child: Semantics(
        button: true,
        selected: selected,
        label: organ.name(locale),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedOpacity(
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 220),
            opacity: dimmed ? 0.35 : 1,
            child: SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: Center(
                child: Container(
                  width: radius * 1.15,
                  height: radius * 1.15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(
                      alpha: selected ? 0.30 : 0.14 + 0.10 * pulse * weight,
                    ),
                    border: Border.all(
                      color: color.withValues(alpha: selected ? 1 : 0.55),
                      width: selected ? 2 : 1.2,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single calm human outline — a silhouette, not an anatomical plate.
class _BodyPainter extends CustomPainter {
  _BodyPainter({required this.outline, required this.fill});

  final Color outline;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    final body = Path();
    // Head.
    body.addOval(
      Rect.fromCircle(center: Offset(cx, h * 0.085), radius: h * 0.062),
    );

    // Neck, shoulders, torso, legs — one closed silhouette.
    final torso = Path()
      ..moveTo(cx - w * 0.035, h * 0.150)
      ..lineTo(cx + w * 0.035, h * 0.150)
      ..cubicTo(
        cx + w * 0.055, h * 0.185,
        cx + w * 0.150, h * 0.200,
        cx + w * 0.165, h * 0.235,
      )
      // Arm down the right side.
      ..cubicTo(
        cx + w * 0.185, h * 0.330,
        cx + w * 0.175, h * 0.430,
        cx + w * 0.150, h * 0.520,
      )
      ..cubicTo(
        cx + w * 0.140, h * 0.545,
        cx + w * 0.120, h * 0.545,
        cx + w * 0.112, h * 0.520,
      )
      ..cubicTo(
        cx + w * 0.128, h * 0.430,
        cx + w * 0.125, h * 0.360,
        cx + w * 0.108, h * 0.300,
      )
      // Waist and hip.
      ..cubicTo(
        cx + w * 0.100, h * 0.420,
        cx + w * 0.105, h * 0.520,
        cx + w * 0.095, h * 0.600,
      )
      // Right leg.
      ..cubicTo(
        cx + w * 0.090, h * 0.720,
        cx + w * 0.070, h * 0.860,
        cx + w * 0.058, h * 0.960,
      )
      ..lineTo(cx + w * 0.012, h * 0.960)
      ..cubicTo(
        cx + w * 0.010, h * 0.840,
        cx + w * 0.004, h * 0.720,
        cx, h * 0.640,
      )
      // Left leg (mirror).
      ..cubicTo(
        cx - w * 0.004, h * 0.720,
        cx - w * 0.010, h * 0.840,
        cx - w * 0.012, h * 0.960,
      )
      ..lineTo(cx - w * 0.058, h * 0.960)
      ..cubicTo(
        cx - w * 0.070, h * 0.860,
        cx - w * 0.090, h * 0.720,
        cx - w * 0.095, h * 0.600,
      )
      ..cubicTo(
        cx - w * 0.105, h * 0.520,
        cx - w * 0.100, h * 0.420,
        cx - w * 0.108, h * 0.300,
      )
      // Left arm.
      ..cubicTo(
        cx - w * 0.125, h * 0.360,
        cx - w * 0.128, h * 0.430,
        cx - w * 0.112, h * 0.520,
      )
      ..cubicTo(
        cx - w * 0.120, h * 0.545,
        cx - w * 0.140, h * 0.545,
        cx - w * 0.150, h * 0.520,
      )
      ..cubicTo(
        cx - w * 0.175, h * 0.430,
        cx - w * 0.185, h * 0.330,
        cx - w * 0.165, h * 0.235,
      )
      ..cubicTo(
        cx - w * 0.150, h * 0.200,
        cx - w * 0.055, h * 0.185,
        cx - w * 0.035, h * 0.150,
      )
      ..close();

    body.addPath(torso, Offset.zero);

    canvas.drawPath(body, Paint()..color = fill);
    canvas.drawPath(
      body,
      Paint()
        ..color = outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  @override
  bool shouldRepaint(_BodyPainter old) =>
      old.outline != outline || old.fill != fill;
}

/// The population-impact bar under an organ's name (module report §7.③).
///
/// It animates from zero on selection, which is what makes a static figure
/// feel answered rather than merely displayed — and it always states which
/// quantity it is drawing.
class OrganImpactBar extends StatelessWidget {
  const OrganImpactBar({
    super.key,
    required this.impact,
    required this.caption,
    required this.color,
  });

  final OrganImpact impact;

  /// Already-localized line stating the measure and its value.
  final String caption;

  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (impact.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(caption, style: theme.textTheme.labelMedium),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: impact.barFraction),
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
