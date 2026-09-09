import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Vector organ shapes for the body map (module report §7.④).
///
/// The first body map put a coloured dot on each organ. A dot is a legend
/// entry, not an organ: it tells you where to tap and nothing else, and on a
/// screen someone opens to face what smoking does to them, that reads as a
/// placeholder.
///
/// So each organ that *is* a discrete organ gets a drawn shape here, in a
/// normalized 0..1 box that the map scales onto the figure. Two rules hold
/// the drawings honest:
///
///  * **suggestive, not clinical.** These are recognisable silhouettes — a
///    lung with its bronchial stem, a heart with its two great vessels, a
///    kidney's bean. They are not pathology plates, and nothing in them is
///    drawn diseased: the app never illustrates damage as if it were the
///    user's own tissue.
///  * **diffuse systems stay abstract.** Blood vessels, immunity and skin do
///    not have one shape to draw, so they keep a ring marker instead of a
///    fake organ. Inventing an anatomy for them would be the same lie as the
///    dot, only better dressed.
class OrganShapes {
  const OrganShapes._();

  /// Organs drawn as shapes. Anything not listed falls back to a ring marker.
  static const drawn = {
    'lungs',
    'heart',
    'brain',
    'liver',
    'stomach',
    'kidneyBladder',
    'mouth',
  };

  /// The unit-box path for [key], or null when the organ stays abstract.
  static Path? pathFor(String key) => switch (key) {
        'lungs' => _lungs(),
        'heart' => _heart(),
        'brain' => _brain(),
        'liver' => _liver(),
        'stomach' => _stomach(),
        'kidneyBladder' => _kidneys(),
        'mouth' => _mouth(),
        _ => null,
      };

  /// Both lobes with the trachea and the two main bronchi between them.
  /// The lobes taper to a base and the left one carries the cardiac notch —
  /// without those two details a lung draws as a balloon.
  static Path _lungs() {
    final path = Path();
    // Trachea and carina.
    path
      ..moveTo(0.475, 0.00)
      ..lineTo(0.525, 0.00)
      ..lineTo(0.525, 0.20)
      ..lineTo(0.655, 0.30)
      ..lineTo(0.625, 0.35)
      ..lineTo(0.500, 0.255)
      ..lineTo(0.375, 0.35)
      ..lineTo(0.345, 0.30)
      ..lineTo(0.475, 0.20)
      ..close();

    // Left lobe (viewer's left): apex at the bronchus, a concave notch on the
    // inner edge where the heart sits, tapering to a base.
    path
      ..moveTo(0.415, 0.22)
      ..cubicTo(0.24, 0.30, 0.13, 0.52, 0.16, 0.74)
      ..cubicTo(0.18, 0.90, 0.26, 1.00, 0.34, 0.99)
      ..cubicTo(0.40, 0.98, 0.43, 0.88, 0.435, 0.74)
      ..cubicTo(0.44, 0.66, 0.40, 0.60, 0.425, 0.52)
      ..cubicTo(0.45, 0.44, 0.435, 0.30, 0.415, 0.22)
      ..close();

    // Right lobe: fuller, three lobes' worth of volume, same taper.
    path
      ..moveTo(0.585, 0.22)
      ..cubicTo(0.76, 0.30, 0.87, 0.52, 0.84, 0.74)
      ..cubicTo(0.82, 0.90, 0.74, 1.00, 0.66, 0.99)
      ..cubicTo(0.60, 0.98, 0.57, 0.88, 0.565, 0.74)
      ..cubicTo(0.56, 0.60, 0.57, 0.36, 0.585, 0.22)
      ..close();
    return path;
  }

  /// An anatomical heart: broad base at the top, a pointed apex down and to
  /// the left, and the two great vessels as stubs rather than a decorative
  /// arch. Without the apex it draws as a peach.
  static Path _heart() {
    final path = Path()
      ..moveTo(0.34, 0.22)
      ..cubicTo(0.64, 0.12, 0.94, 0.30, 0.90, 0.54)
      ..cubicTo(0.86, 0.74, 0.62, 0.90, 0.40, 0.99)
      ..lineTo(0.29, 1.00)
      ..cubicTo(0.19, 0.84, 0.11, 0.60, 0.16, 0.42)
      ..cubicTo(0.20, 0.28, 0.26, 0.22, 0.34, 0.22)
      ..close();
    // Aorta and pulmonary trunk: two short stubs off the base.
    path
      ..moveTo(0.44, 0.19)
      ..lineTo(0.56, 0.15)
      ..lineTo(0.58, 0.02)
      ..lineTo(0.48, 0.02)
      ..close()
      ..moveTo(0.63, 0.18)
      ..lineTo(0.75, 0.21)
      ..lineTo(0.80, 0.08)
      ..lineTo(0.70, 0.05)
      ..close();
    return path;
  }

  /// A brain: outline plus the folds that make it read as one at 40 px.
  static Path _brain() {
    final path = Path()
      ..moveTo(0.50, 0.06)
      ..cubicTo(0.24, 0.06, 0.08, 0.26, 0.10, 0.50)
      ..cubicTo(0.12, 0.72, 0.26, 0.88, 0.44, 0.90)
      ..lineTo(0.44, 0.98)
      ..lineTo(0.56, 0.98)
      ..lineTo(0.56, 0.90)
      ..cubicTo(0.74, 0.88, 0.88, 0.72, 0.90, 0.50)
      ..cubicTo(0.92, 0.26, 0.76, 0.06, 0.50, 0.06)
      ..close();
    // Central sulcus and two folds — drawn as thin closed slivers so the
    // whole organ can still be filled with one paint.
    for (final fold in const [
      [0.50, 0.10, 0.50, 0.86],
      [0.28, 0.24, 0.34, 0.76],
      [0.72, 0.24, 0.66, 0.76],
    ]) {
      path
        ..moveTo(fold[0], fold[1])
        ..cubicTo(
          fold[0] + 0.10, fold[1] + 0.22,
          fold[2] - 0.10, fold[3] - 0.22,
          fold[2], fold[3],
        )
        ..cubicTo(
          fold[2] - 0.07, fold[3] - 0.22,
          fold[0] + 0.13, fold[1] + 0.22,
          fold[0] + 0.03, fold[1],
        )
        ..close();
    }
    return path;
  }

  /// The liver's wedge: domed under the diaphragm, deep on the right, and
  /// tapering to a thin point on the left. Its lower border has to rise
  /// asymmetrically — drawn symmetrically it reads as a bowl, which is
  /// exactly what the first attempt looked like.
  static Path _liver() => Path()
    ..moveTo(0.03, 0.26)
    ..cubicTo(0.22, 0.02, 0.66, 0.00, 0.97, 0.16)
    ..cubicTo(1.00, 0.46, 0.94, 0.74, 0.80, 0.92)
    ..cubicTo(0.70, 1.00, 0.58, 0.96, 0.44, 0.74)
    ..cubicTo(0.30, 0.54, 0.12, 0.42, 0.03, 0.26)
    ..close()
    // Falciform ligament: the notch dividing the two lobes.
    ..moveTo(0.50, 0.06)
    ..lineTo(0.56, 0.08)
    ..lineTo(0.50, 0.56)
    ..lineTo(0.43, 0.48)
    ..close();

  /// A stomach as the J it is: the oesophagus enters at the top, the fundus
  /// domes up and to the left above it, the greater curvature sweeps down,
  /// and the pylorus leaves narrow to the right.
  static Path _stomach() => Path()
    ..moveTo(0.36, 0.06)
    ..lineTo(0.48, 0.02)
    // Lesser curvature: the short inner edge down to the pylorus.
    ..cubicTo(0.54, 0.22, 0.62, 0.38, 0.72, 0.50)
    ..cubicTo(0.82, 0.60, 0.92, 0.64, 0.99, 0.64)
    ..lineTo(0.97, 0.80)
    ..cubicTo(0.84, 0.80, 0.70, 0.74, 0.60, 0.66)
    // Greater curvature: the long outer sweep back up to the fundus.
    ..cubicTo(0.40, 1.00, 0.04, 0.88, 0.06, 0.48)
    ..cubicTo(0.07, 0.22, 0.20, 0.02, 0.36, 0.06)
    ..close();

  /// The pair of beans, hila facing the spine.
  static Path _kidneys() {
    Path bean(bool mirrored) {
      final path = Path()
        ..moveTo(0.30, 0.10)
        ..cubicTo(0.06, 0.14, 0.02, 0.52, 0.14, 0.80)
        ..cubicTo(0.22, 0.98, 0.42, 0.98, 0.44, 0.78)
        ..cubicTo(0.46, 0.60, 0.36, 0.56, 0.36, 0.46)
        ..cubicTo(0.36, 0.34, 0.46, 0.28, 0.44, 0.20)
        ..cubicTo(0.42, 0.12, 0.36, 0.09, 0.30, 0.10)
        ..close();
      if (!mirrored) {
        return path;
      }
      return path.transform(
        (Matrix4.identity()
              ..translateByDouble(1.0, 0.0, 0.0, 1.0)
              ..scaleByDouble(-1.0, 1.0, 1.0, 1.0))
            .storage,
      );
    }

    return Path()
      ..addPath(bean(false), Offset.zero)
      ..addPath(bean(true), Offset.zero);
  }

  /// Lips — the mouth and throat entry.
  static Path _mouth() => Path()
    ..moveTo(0.04, 0.50)
    ..cubicTo(0.22, 0.18, 0.40, 0.28, 0.50, 0.38)
    ..cubicTo(0.60, 0.28, 0.78, 0.18, 0.96, 0.50)
    ..cubicTo(0.78, 0.88, 0.22, 0.88, 0.04, 0.50)
    ..close();

  /// Scales a unit-box path into [box].
  static Path scaled(Path unit, Rect box) => unit.transform(
        (Matrix4.identity()
              ..translateByDouble(box.left, box.top, 0, 1)
              ..scaleByDouble(box.width, box.height, 1, 1))
            .storage,
      );
}

/// How each drawn organ moves. Motion is per-organ because a heart that
/// breathes like a lung is uncanny, and a liver that beats is nonsense.
enum OrganMotion {
  /// Slow inflate/deflate, four seconds — the lungs.
  breathe,

  /// A double thump on a one-second cycle — the heart.
  beat,

  /// A barely-there swell, so the organ is alive without asking for attention.
  drift,
}

OrganMotion motionFor(String key) => switch (key) {
      'lungs' => OrganMotion.breathe,
      'heart' => OrganMotion.beat,
      _ => OrganMotion.drift,
    };

/// Scale factor at clock position [phase] (0..1) for [motion].
double organScale(OrganMotion motion, double phase) => switch (motion) {
      OrganMotion.breathe => 1 + 0.055 * (0.5 - 0.5 * math.cos(phase * 2 * math.pi)),
      OrganMotion.beat => 1 + 0.05 * _beat(phase),
      OrganMotion.drift => 1 + 0.02 * (0.5 - 0.5 * math.cos(phase * 2 * math.pi)),
    };

/// Two quick contractions and a long rest — lub-dub, then the diastole.
double _beat(double phase) {
  final t = (phase * 4) % 1.0;
  if (t < 0.12) {
    return math.sin(t / 0.12 * math.pi);
  }
  if (t < 0.26) {
    return 0.6 * math.sin((t - 0.14) / 0.12 * math.pi);
  }
  return 0;
}
