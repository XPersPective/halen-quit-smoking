import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/design/tokens.dart';
import '../../core/theme.dart';
import '../../data/repositories/library_repository.dart';
import 'entrance.dart';
import 'design/body_clock.dart';
import 'organ_shapes.dart';

/// A tappable, breathing body map (module report §7.④).
///
/// The card list this replaces was accurate and lifeless. Four decisions
/// shape what is here instead:
///
///  * **the organs are drawn.** Each discrete organ is a vector shape from
///    [OrganShapes] — a lung with its bronchial stem, a heart with its
///    aortic arch — not a coloured dot standing in for one. Diffuse systems
///    (vessels, immunity, skin) keep a ring, because inventing a shape for
///    them would be a prettier version of the same placeholder;
///  * **each organ moves its own way.** Lungs breathe on four seconds, the
///    heart does a lub-dub on one, everything else drifts. A heart that
///    breathes like a lung is uncanny, and one shared wobble is what made
///    the old version feel like a diagram;
///  * **selection is a movement, not a jump.** The chosen organ grows, the
///    others fade back, and the detail slides in underneath;
///  * **still no gore and no personal percentages.** Nothing is drawn
///    diseased, and every number attached to the figure is population-level
///    and labelled as such on the same screen.
///
/// Reduce-motion collapses the motion and the transitions to static frames;
/// nothing here is information that only the animation carries.
class BodyMapView extends StatefulWidget {
  const BodyMapView({
    super.key,
    required this.organs,
    required this.selectedKey,
    required this.onSelected,
    required this.locale,
    this.height = 360,
  });

  final List<OrganEntry> organs;

  /// The currently open organ, or null when nothing is selected.
  final String? selectedKey;

  final ValueChanged<String> onSelected;
  final String locale;
  final double height;

  /// Systems that have no single organ to draw — vessels, immunity, skin,
  /// eyes, the reproductive system. They used to sit on the figure as bare
  /// circles, which put four meaningless dots on a body that had just
  /// learned to draw real organs. They belong in a row of their own.
  static const List<String> diffuse = [
    'bloodVessels',
    'immune',
    'skin',
    'eyes',
    'reproductive',
  ];

  @override
  State<BodyMapView> createState() => _BodyMapViewState();
}

class _BodyMapViewState extends State<BodyMapView> {
  /// Where each organ sits on the figure, in fractions of the canvas.
  static const hotspots = <String, Offset>{
    'brain': Offset(0.500, 0.058),
    'mouth': Offset(0.500, 0.108),
    'lungs': Offset(0.500, 0.272),
    'heart': Offset(0.528, 0.352),
    'liver': Offset(0.436, 0.428),
    'stomach': Offset(0.566, 0.424),
    'kidneyBladder': Offset(0.500, 0.516),
  };


  /// Drawing box for each organ, as fractions of the canvas.
  static const boxes = <String, Size>{
    'brain': Size(0.120, 0.078),
    'mouth': Size(0.062, 0.024),
    'lungs': Size(0.175, 0.125),
    'heart': Size(0.082, 0.070),
    'liver': Size(0.115, 0.060),
    'stomach': Size(0.082, 0.066),
    'kidneyBladder': Size(0.120, 0.056),
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
          return BodyPulse(
            builder: (context, seconds) {
              final phase = BodyClock.phaseOf(seconds, HalenDuration.breath);
              return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _BodyPainter(
                    outline:
                        theme.colorScheme.onSurface.withValues(alpha: 0.28),
                    fill: theme.colorScheme.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),
              for (final organ in _drawOrder())
                if (hotspots[organ.key] != null && boxes[organ.key] != null)
                  _Hotspot(
                    organ: organ,
                    locale: widget.locale,
                    position: hotspots[organ.key]!,
                    box: boxes[organ.key],
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

  /// Lungs before the heart, so the heart sits in front of them the way it
  /// does in a chest — and so its tap target wins in the overlap.
  List<OrganEntry> _drawOrder() {
    const back = ['lungs'];
    return [
      ...widget.organs.where((o) => back.contains(o.key)),
      ...widget.organs.where((o) => !back.contains(o.key)),
    ];
  }
}

class _Hotspot extends StatelessWidget {
  const _Hotspot({
    required this.organ,
    required this.locale,
    required this.position,
    required this.box,
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

  /// Drawing box for a shaped organ; null keeps the abstract ring.
  final Size? box;
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
    final unit = box == null ? null : OrganShapes.pathFor(organ.key);
    final color = selected ? HalenColors.amberCta : theme.colorScheme.primary;

    // A stronger population link is drawn a little more solidly. It is a
    // hint, never the information itself — the number is written out below.
    final weight = 0.35 + 0.65 * organ.impact.barFraction;

    final Widget mark;
    final double width;
    final double height;

    if (unit != null) {
      // Each organ moves on its own rhythm, offset along the shared clock by
      // where it sits, so the body ripples instead of flashing in unison.
      final motion = motionFor(organ.key);
      final local = (phase + position.dy) % 1.0;
      final scale = reduceMotion ? 1.0 : organScale(motion, local);
      width = box!.width * canvas.width * (selected ? 1.35 : 1.0);
      height = box!.height * canvas.height * (selected ? 1.35 : 1.0);
      mark = CustomPaint(
        painter: _OrganPainter(
          unit: unit,
          color: color,
          fillAlpha: (selected ? 0.42 : 0.20 + 0.16 * weight).clamp(0.0, 1.0),
          strokeAlpha: selected ? 1.0 : 0.55 + 0.25 * weight,
          strokeWidth: selected ? 2.0 : 1.3,
          scale: scale,
        ),
        size: Size(width, height),
      );
    } else {
      // Diffuse systems: a ring, honestly abstract, pulsing on the shared
      // clock so it belongs to the same body.
      final local = (phase + position.dy) % 1.0;
      final pulse = reduceMotion ? 0.5 : 0.5 - 0.5 * math.cos(local * 2 * math.pi);
      final radius = (selected ? 20.0 : 15.0) + (reduceMotion ? 0 : 3 * pulse * weight);
      width = radius * 2;
      height = radius * 2;
      mark = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: selected ? 0.30 : 0.12 + 0.10 * pulse),
          border: Border.all(
            color: color.withValues(alpha: selected ? 1 : 0.55),
            width: selected ? 2 : 1.2,
          ),
        ),
      );
    }

    // Never smaller than the platform minimum, however small the organ is.
    final touch = Size(math.max(width, 44), math.max(height, 44));

    return Positioned(
      left: position.dx * canvas.width - touch.width / 2,
      top: position.dy * canvas.height - touch.height / 2,
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
            opacity: dimmed ? 0.32 : 1,
            child: SizedBox(
              width: touch.width,
              height: touch.height,
              child: Center(
                child: SizedBox(width: width, height: height, child: mark),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints one unit-box organ path, scaled about its own centre.
///
/// The fill is a top-lit gradient rather than a flat tint — the single
/// cheapest thing that separates a drawn organ from a diagram — and the
/// selected/detail state adds a soft glow so the organ reads as the subject.
class _OrganPainter extends CustomPainter {
  _OrganPainter({
    required this.unit,
    required this.color,
    required this.fillAlpha,
    required this.strokeAlpha,
    required this.strokeWidth,
    required this.scale,
    this.glow = false,
  });

  final Path unit;
  final Color color;
  final double fillAlpha;
  final double strokeAlpha;
  final double strokeWidth;
  final double scale;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..scale(scale)
      ..translate(-size.width / 2, -size.height / 2);
    final path = OrganShapes.scaled(unit, Offset.zero & size);
    if (glow) {
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: 0.32)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
    canvas
      ..drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(color, Colors.white, 0.40)!
                  .withValues(alpha: fillAlpha),
              color.withValues(alpha: (fillAlpha * 1.2).clamp(0.0, 1.0)),
            ],
          ).createShader(Offset.zero & size),
      )
      ..drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: strokeAlpha.clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeJoin = StrokeJoin.round,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_OrganPainter old) =>
      old.scale != scale ||
      old.color != color ||
      old.fillAlpha != fillAlpha ||
      old.strokeAlpha != strokeAlpha ||
      old.glow != glow ||
      old.unit != unit;
}

/// One organ, drawn large and alive — for the detail panel, where the shape
/// finally has the pixels to read as an organ rather than a marker.
class OrganGlyph extends StatelessWidget {
  const OrganGlyph({
    super.key,
    required this.organKey,
    required this.color,
    this.size = const Size(120, 120),
    this.glow = false,
  });

  final String organKey;
  final Color color;
  final Size size;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final unit = OrganShapes.pathFor(organKey);
    if (unit == null) {
      return const SizedBox.shrink();
    }
    // Everything reads the same four-second clock; organScale folds the
    // heart's faster rhythm out of it, so a beat and a breath stay locked to
    // one another instead of drifting apart.
    final motion = motionFor(organKey);
    return BodyPulse(
      builder: (context, seconds) => CustomPaint(
        size: size,
        painter: _OrganPainter(
          unit: unit,
          color: color,
          fillAlpha: 0.22,
          strokeAlpha: 0.95,
          strokeWidth: 2,
          glow: glow,
          scale: organScale(
            motion,
            BodyClock.phaseOf(seconds, HalenDuration.breath),
          ),
        ),
      ),
    );
  }
}

/// A single calm human outline — a silhouette, not an anatomical plate.
///
/// Drawn as separate pieces (head, neck, torso, two arms, two legs) rather
/// than one closed outline. The single-path version fused the arms into the
/// shoulders and the legs into the hips, and the result read as a snowman:
/// with the organs now drawn inside it, the body has to look like a body.
class _BodyPainter extends CustomPainter {
  _BodyPainter({required this.outline, required this.fill});

  final Color outline;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    Offset p(double x, double y) => Offset(cx + w * x, h * y);

    final head = Path()
      ..addOval(Rect.fromCircle(center: p(0, 0.078), radius: h * 0.062));

    final neck = Path()
      ..moveTo(cx - w * 0.040, h * 0.120)
      ..lineTo(cx + w * 0.040, h * 0.120)
      ..lineTo(cx + w * 0.046, h * 0.165)
      ..lineTo(cx - w * 0.046, h * 0.165)
      ..close();

    // Torso: shoulders, a waist that actually narrows, and hips.
    final torso = Path()
      ..moveTo(cx - w * 0.046, h * 0.160)
      ..cubicTo(
        cx - w * 0.110, h * 0.170,
        cx - w * 0.150, h * 0.192,
        cx - w * 0.156, h * 0.232,
      )
      ..cubicTo(
        cx - w * 0.160, h * 0.312,
        cx - w * 0.134, h * 0.360,
        cx - w * 0.120, h * 0.420,
      )
      ..cubicTo(
        cx - w * 0.110, h * 0.462,
        cx - w * 0.128, h * 0.512,
        cx - w * 0.146, h * 0.560,
      )
      ..cubicTo(
        cx - w * 0.158, h * 0.600,
        cx - w * 0.140, h * 0.622,
        cx, h * 0.624,
      )
      ..cubicTo(
        cx + w * 0.140, h * 0.622,
        cx + w * 0.158, h * 0.600,
        cx + w * 0.146, h * 0.560,
      )
      ..cubicTo(
        cx + w * 0.128, h * 0.512,
        cx + w * 0.110, h * 0.462,
        cx + w * 0.120, h * 0.420,
      )
      ..cubicTo(
        cx + w * 0.134, h * 0.360,
        cx + w * 0.160, h * 0.312,
        cx + w * 0.156, h * 0.232,
      )
      ..cubicTo(
        cx + w * 0.150, h * 0.192,
        cx + w * 0.110, h * 0.170,
        cx + w * 0.046, h * 0.160,
      )
      ..close();

    // Arms and legs as their own rounded limbs, set off the trunk.
    Path limb(List<Offset> spine, double halfWidth) {
      final path = Path();
      final left = <Offset>[];
      final right = <Offset>[];
      for (var i = 0; i < spine.length; i++) {
        final before = spine[math.max(0, i - 1)];
        final after = spine[math.min(spine.length - 1, i + 1)];
        final dir = after - before;
        final len = dir.distance;
        final normal = len == 0
            ? const Offset(1, 0)
            : Offset(-dir.dy / len, dir.dx / len);
        // Taper towards the far end so a limb is not a rectangle.
        final t = 1 - 0.35 * (i / (spine.length - 1));
        left.add(spine[i] + normal * halfWidth * t);
        right.add(spine[i] - normal * halfWidth * t);
      }
      path.moveTo(left.first.dx, left.first.dy);
      for (final o in left.skip(1)) {
        path.lineTo(o.dx, o.dy);
      }
      for (final o in right.reversed) {
        path.lineTo(o.dx, o.dy);
      }
      path.close();
      return path;
    }

    final arms = [
      for (final side in const [-1.0, 1.0])
        limb(
          [
            // The first point sits inside the trunk so the shoulder joins
            // instead of showing a seam between arm and body.
            p(side * 0.110, 0.178),
            p(side * 0.150, 0.208),
            p(side * 0.200, 0.290),
            p(side * 0.216, 0.376),
            p(side * 0.212, 0.462),
            p(side * 0.200, 0.536),
          ],
          w * 0.028,
        ),
    ];

    final legs = [
      for (final side in const [-1.0, 1.0])
        limb(
          [
            p(side * 0.072, 0.612),
            p(side * 0.078, 0.716),
            p(side * 0.072, 0.828),
            p(side * 0.064, 0.940),
          ],
          w * 0.046,
        ),
    ];

    final body = Path()..addPath(torso, Offset.zero);
    for (final piece in [head, neck, ...arms, ...legs]) {
      body.addPath(piece, Offset.zero);
    }

    canvas.drawPath(body, Paint()..color = fill);
    for (final piece in [neck, torso, head, ...arms, ...legs]) {
      canvas.drawPath(
        piece,
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeJoin = StrokeJoin.round,
      );
    }
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

/// What recovery looks like over time for one organ (module report §7.③).
///
/// A timeline, not a curve: the literature documents *when* an organ heals,
/// not a smooth per-organ percentage, so drawing one would put a y-axis
/// behind a number nothing measures. Time since the last cigarette is the
/// only axis here, and every label is paraphrased straight from the organ's
/// own sourced recovery line — the structure is new, the claims are not.
class OrganRecoveryTimeline extends StatelessWidget {
  const OrganRecoveryTimeline({
    super.key,
    required this.anchors,
    required this.locale,
  });

  final List<RecoveryAnchor> anchors;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        if (anchors.length > 1)
          Positioned(
            left: 5,
            top: 10,
            bottom: 16,
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HalenColors.emerald.withValues(alpha: 0.60),
                    HalenColors.emerald.withValues(alpha: 0.12),
                  ],
                ),
              ),
            ),
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < anchors.length; i++)
              Entrance(
                index: i,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: i == anchors.length - 1 ? 2 : 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HalenColors.emerald,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: HalenColors.emerald.withValues(alpha: 0.45),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              anchors[i].when(locale),
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: HalenColors.petrol,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(anchors[i].label(locale),
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
