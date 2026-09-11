# -*- coding: utf-8 -*-
"""Wires BodySilhouettePainter and body-space organ placement into the map."""
import io
import sys

P = 'lib/presentation/widgets/body_map_view.dart'
s = io.open(P, encoding='utf-8').read()


def replace(old, new):
    global s
    if old not in s:
        sys.exit('ANCHOR MISSING:\n---\n%s\n---' % old[:240])
    s = s.replace(old, new, 1)


def cut(start, end_exclusive):
    global s
    a = s.index(start)
    b = s.index(end_exclusive, a)
    s = s[:a] + s[b:]


# Bigger stage: the figure is the subject of this screen.
replace('    this.height = 360,', '    this.height = 420,')

# The canvas-fraction maps only lined up at one screen width; organs now
# live in body space (BodyGeometry.organs).
cut('  /// Where each organ sits on the figure, in fractions of the canvas.',
    '  @override\n  Widget build(BuildContext context) {')

# The painter.
replace('''              Positioned.fill(
                child: CustomPaint(
                  painter: _BodyPainter(
                    outline:
                        theme.colorScheme.onSurface.withValues(alpha: 0.28),
                    fill: theme.colorScheme.primary.withValues(alpha: 0.05),
                  ),
                ),
              ),''', '''              Positioned.fill(
                child: CustomPaint(
                  painter: BodySilhouettePainter(
                    tint: theme.colorScheme.primary,
                    outline: theme.colorScheme.onSurface,
                    highlight: theme.brightness == Brightness.dark
                        ? theme.colorScheme.primary
                        : Colors.white,
                  ),
                ),
              ),''')

# Hotspots in body space.
replace('''              for (final organ in _drawOrder())
                if (hotspots[organ.key] != null && boxes[organ.key] != null)
                  _Hotspot(
                    organ: organ,
                    locale: widget.locale,
                    position: hotspots[organ.key]!,
                    box: boxes[organ.key],
                    canvas: size,
                    phase: phase,''', '''              for (final organ in _drawOrder())
                if (BodyGeometry.organs[organ.key] case final placement?)
                  _Hotspot(
                    organ: organ,
                    locale: widget.locale,
                    center: frame.point(placement.$1),
                    boxSize: frame.box(placement.$2),
                    phaseOffset: placement.$1.dy,
                    phase: phase,''')
replace('''          final size = Size(constraints.maxWidth, widget.height);''',
        '''          final frame =
              BodyFrame(Size(constraints.maxWidth, widget.height));''')

# _Hotspot takes pixels now.
replace('''    required this.organ,
    required this.locale,
    required this.position,
    required this.box,
    required this.canvas,
    required this.phase,''', '''    required this.organ,
    required this.locale,
    required this.center,
    required this.boxSize,
    required this.phaseOffset,
    required this.phase,''')
replace('''  final OrganEntry organ;
  final String locale;
  final Offset position;

  /// Drawing box for a shaped organ; null keeps the abstract ring.
  final Size? box;
  final Size canvas;
''', '''  final OrganEntry organ;
  final String locale;

  /// Where the organ sits, in pixels.
  final Offset center;

  /// The organ's drawing box, in pixels.
  final Size boxSize;

  /// The organ's height on the body (0..1), used to stagger its phase so
  /// the body ripples rather than pulsing in unison.
  final double phaseOffset;
''')
replace('''    final unit = box == null ? null : OrganShapes.pathFor(organ.key);''',
        '''    final unit = OrganShapes.pathFor(organ.key);''')
replace('''      final local = (phase + position.dy) % 1.0;
      final scale = reduceMotion ? 1.0 : organScale(motion, local);
      width = box!.width * canvas.width * (selected ? 1.35 : 1.0);
      height = box!.height * canvas.height * (selected ? 1.35 : 1.0);''',
        '''      final local = (phase + phaseOffset) % 1.0;
      final scale = reduceMotion ? 1.0 : organScale(motion, local);
      width = boxSize.width * (selected ? 1.35 : 1.0);
      height = boxSize.height * (selected ? 1.35 : 1.0);''')
replace('''      final local = (phase + position.dy) % 1.0;
      final pulse''', '''      final local = (phase + phaseOffset) % 1.0;
      final pulse''')
replace('''      left: position.dx * canvas.width - touch.width / 2,
      top: position.dy * canvas.height - touch.height / 2,''',
        '''      left: center.dx - touch.width / 2,
      top: center.dy - touch.height / 2,''')

# The old figure goes.
cut('/// A single calm human outline',
    "/// The population-impact bar under an organ's name")

replace("import 'organ_shapes.dart';",
        "import 'body_silhouette.dart';\nimport 'organ_shapes.dart';")

io.open(P, 'w', encoding='utf-8').write(s)
print('silhouette wired')
