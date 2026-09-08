/// S3-class withdrawal-pressure model (module report §8).
///
/// The evidence: withdrawal symptoms start within hours, PEAK on days 1–3 and
/// taper over 3–4 weeks; pre-cessation exposure predicts severity. So the
/// model is a product of two terms — a phase curve over days since the quit
/// (or taper step) and the current nicotine trough — corrected by a personal
/// offset the user teaches the app by saying how they actually feel.
///
/// The output is a BAND, never a percentage: "you are 38% angrier" is not
/// measurable and would be an S5 claim. The copy always ends with
/// "only you know how you feel".
library;

import 'dart:math' as math;

/// Three-level pressure band shown to the user.
enum PressureBand { calm, underPressure, tough }

/// Typical withdrawal-pressure curve, 0..1, for [daysSinceQuit].
///
/// Shape: rises through the first day, peaks across days 1–3, then decays
/// with a ~10-day time constant, reaching a low plateau by weeks 3–4.
double typicalPressure(double daysSinceQuit) {
  if (daysSinceQuit < 0) {
    return 0;
  }
  if (daysSinceQuit < 1) {
    return 0.55 + 0.45 * daysSinceQuit; // hours 0–24: climbing
  }
  if (daysSinceQuit <= 3) {
    return 1.0; // the documented peak
  }
  final decayed = math.exp(-(daysSinceQuit - 3) / 10);
  return (0.08 + 0.92 * decayed).clamp(0.0, 1.0);
}

/// The 28-day typical curve for the chart, one value per day, 0..1.
List<double> typicalPressureCurve({int days = 28}) =>
    [for (var d = 0; d < days; d++) typicalPressure(d.toDouble())];

/// Estimated pressure right now, 0..1.
///
/// [phase] is the typical-curve term (days since quit or since the current
/// taper step began); [trough] is 0..1 from the body-load model; [offset] is
/// the personal correction learned from the user's own reports, −0.2..+0.2.
double pressureNow({
  required double daysSincePhaseStart,
  required double trough,
  double offset = 0,
}) {
  final phase = typicalPressure(daysSincePhaseStart);
  // Phase sets the ceiling, the trough decides where inside it we sit; a
  // deep trough on a calm day still registers, a shallow trough on day 2
  // does not max out.
  final raw = phase * (0.45 + 0.55 * trough.clamp(0.0, 1.0));
  return (raw + offset).clamp(0.0, 1.0);
}

PressureBand bandForPressure(double pressure) {
  if (pressure < 0.34) {
    return PressureBand.calm;
  }
  return pressure < 0.67 ? PressureBand.underPressure : PressureBand.tough;
}

/// Learns the personal offset from past (estimate, reported) pairs: the mean
/// signed error, damped and clamped to ±0.2 so a few outliers cannot flip
/// the model. Returns 0 until [minReports] pairs exist.
double personalOffset(
  List<({double estimated, double reported})> reports, {
  int minReports = 5,
}) {
  if (reports.length < minReports) {
    return 0;
  }
  final recent = reports.length <= 30
      ? reports
      : reports.sublist(reports.length - 30);
  final mean = recent
          .map((r) => r.reported - r.estimated)
          .reduce((a, b) => a + b) /
      recent.length;
  return (mean * 0.5).clamp(-0.2, 0.2);
}

/// How often the estimate landed in the same band as the user's own report —
/// shown as "my guess matched X% of the time", the honest way to expose a
/// model's accuracy instead of hiding it.
double? estimateAccuracy(
  List<({double estimated, double reported})> reports, {
  int minReports = 5,
}) {
  if (reports.length < minReports) {
    return null;
  }
  final hits = reports
      .where((r) =>
          bandForPressure(r.estimated) == bandForPressure(r.reported))
      .length;
  return hits / reports.length;
}

/// Post-cessation weight-gain expectation (S4, population data): mean kg
/// gained by [monthsSinceQuit], from the published 1/2/3/6/12-month series
/// (~1.1, 2.3, 2.9, 4.2, 4.7 kg). Linear interpolation between anchors.
/// Shown once, in weeks 2–4, with its risk framing — never as a prediction
/// about this user.
double typicalWeightGainKg(double monthsSinceQuit) {
  // (months, kg) anchors from the published post-cessation series.
  const anchors = <(double, double)>[
    (0, 0),
    (1, 1.1),
    (2, 2.3),
    (3, 2.9),
    (6, 4.2),
    (12, 4.7),
  ];
  if (monthsSinceQuit <= 0) {
    return 0;
  }
  if (monthsSinceQuit >= 12) {
    return 4.7;
  }
  for (var i = 1; i < anchors.length; i++) {
    if (monthsSinceQuit <= anchors[i].$1) {
      final (loMonths, loKg) = anchors[i - 1];
      final (hiMonths, hiKg) = anchors[i];
      final t = (monthsSinceQuit - loMonths) / (hiMonths - loMonths);
      return loKg + (hiKg - loKg) * t;
    }
  }
  return 4.7;
}
