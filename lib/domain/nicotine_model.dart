/// S3-class nicotine exposure proxy (report §18).
///
/// Honesty rules enforced by this model's shape:
///  - every cigarette contributes a fixed 1.2 mg systemic-absorption
///    assumption (Benowitz NEJM 2010: 1–1.5 mg);
///  - the plasma proxy is C(t) = Σ d·2^(−Δt/2h) with t½ = 2 h
///    (Hukkanen 2005: plasma nicotine half-life 1–3 h);
///  - the UI may only render the curve NORMALIZED to 0–100 — absolute
///    ng/mL values are never produced for display.
library;

import 'dart:math' as math;

class NicotineModel {
  const NicotineModel({
    this.absorptionMgPerCigarette = 1.2,
    this.halfLifeHours = 2.0,
  });

  final double absorptionMgPerCigarette;
  final double halfLifeHours;

  /// Proxy concentration (arbitrary units proportional to the absorbed dose)
  /// at [at] from cigarettes smoked at [events].
  double proxyAt(DateTime at, List<DateTime> events) {
    var c = 0.0;
    for (final ts in events) {
      final deltaHours = at.difference(ts).inMicroseconds / 3.6e9;
      if (deltaHours < 0) {
        continue; // Future dose — not yet in the body.
      }
      c += absorptionMgPerCigarette * math.pow(0.5, deltaHours / halfLifeHours).toDouble();
    }
    return c;
  }

  /// Curve sampled every [stepMinutes] from [start] to [end], proxy units.
  List<double> proxyCurve(
    DateTime start,
    DateTime end,
    List<DateTime> events, {
    int stepMinutes = 15,
  }) {
    final curve = <double>[];
    var t = start;
    while (t.isBefore(end)) {
      curve.add(proxyAt(t, events));
      t = t.add(Duration(minutes: stepMinutes));
    }
    return curve;
  }

  /// The only value the UI may show: the curve normalized to 0–100
  /// ("estimated exposure", S3). 100 = the given reference peak.
  List<int> normalizedCurve(
    DateTime start,
    DateTime end,
    List<DateTime> events, {
    int stepMinutes = 15,
  }) {
    final raw = proxyCurve(start, end, events, stepMinutes: stepMinutes);
    final peak = raw.fold(0.0, math.max);
    if (peak <= 0) {
      return List.filled(raw.length, 0);
    }
    return [for (final v in raw) (v / peak * 100).round().clamp(0, 100)];
  }

  /// Representative post-quit decay curve (S4/S3 display only): normalized
  /// 0–100 exposure falling from a steady-state proxy after the last
  /// cigarette — used on quit-day cards, never as a personal measurement.
  List<int> quitDecayCurve({int hours = 48, int stepMinutes = 60}) {
    final points = <int>[];
    for (var m = 0; m <= hours * 60; m += stepMinutes) {
      final v = math.pow(0.5, m / 60.0 / halfLifeHours).toDouble();
      points.add((v * 100).round().clamp(0, 100));
    }
    return points;
  }
}
