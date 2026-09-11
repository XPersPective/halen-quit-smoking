import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';
import '../../core/haptics.dart';
import '../../core/theme.dart';
import '../../data/repositories/library_repository.dart';
import 'entrance.dart';
import 'design/body_clock.dart';
import 'body_silhouette.dart';
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
    this.height = 420,
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frame =
              BodyFrame(Size(constraints.maxWidth, widget.height));
          return BodyPulse(
            builder: (context, seconds) {
              final phase = BodyClock.phaseOf(seconds, HalenDuration.breath);
              return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: BodySilhouettePainter(
                    tint: theme.colorScheme.primary,
                    outline: theme.colorScheme.onSurface,
                    highlight: theme.brightness == Brightness.dark
                        ? theme.colorScheme.primary
                        : Colors.white,
                  ),
                ),
              ),
              for (final organ in _drawOrder())
                if (BodyGeometry.organs[organ.key] case final placement?)
                  _Hotspot(
                    organ: organ,
                    locale: widget.locale,
                    center: frame.point(placement.$1),
                    boxSize: frame.box(placement.$2),
                    phaseOffset: placement.$1.dy,
                    phase: phase,
                    selected: widget.selectedKey == organ.key,
                    dimmed: widget.selectedKey != null &&
                        widget.selectedKey != organ.key,
                    reduceMotion: reduceMotion,
                    onTap: () {
                      HalenHaptics.select(context);
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
    required this.center,
    required this.boxSize,
    required this.phaseOffset,
    required this.phase,
    required this.selected,
    required this.dimmed,
    required this.reduceMotion,
    required this.onTap,
  });

  final OrganEntry organ;
  final String locale;

  /// Where the organ sits, in pixels.
  final Offset center;

  /// The organ's drawing box, in pixels.
  final Size boxSize;

  /// The organ's height on the body (0..1), used to stagger its phase so
  /// the body ripples rather than pulsing in unison.
  final double phaseOffset;

  /// Shared 0..1 clock for the whole body.
  final double phase;

  final bool selected;
  final bool dimmed;
  final bool reduceMotion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unit = OrganShapes.pathFor(organ.key);
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
      final local = (phase + phaseOffset) % 1.0;
      final scale = reduceMotion ? 1.0 : organScale(motion, local);
      width = boxSize.width * (selected ? 1.35 : 1.0);
      height = boxSize.height * (selected ? 1.35 : 1.0);
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
      final local = (phase + phaseOffset) % 1.0;
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
      left: center.dx - touch.width / 2,
      top: center.dy - touch.height / 2,
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
        const SizedBox(height: HalenSpace.x2),
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
                      const SizedBox(width: HalenSpace.x3),
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
                            const SizedBox(height: HalenSpace.x1),
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
