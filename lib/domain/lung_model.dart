/// S4-class lung-function scenarios (module report §6).
///
/// The app cannot measure FEV1 — that needs a spirometer — so it never
/// produces a personal "lung age". What it CAN do honestly is draw the
/// published population decline rates for three scenarios and let the user
/// see the gap between them:
///
///   never-smoker    ~30 mL/year
///   sustained quit  ~28–35 mL/year (post-quit decline stays above never)
///   current smoker  ~40 mL/year, up to ~62–80 mL/year at heavy intake
///
/// Every curve is labelled "typical" and carries the line "this is not a
/// scan of your lungs". The report is explicit that claiming full recovery
/// is not supported: quitting SLOWS the line, it does not reset it.
library;

import 'dart:math' as math;

/// Published annual FEV1 decline rates in mL/year.
abstract final class Fev1Decline {
  static const double neverSmoker = 30;
  static const double sustainedQuitter = 33;
  static const double currentSmokerLight = 40;
  static const double currentSmokerHeavy = 70;

  /// Decline for a current smoker at [cigarettesPerDay], interpolated
  /// between the light and heavy published rates (15/day is the heavy
  /// threshold in the source cohort).
  static double forIntake(double cigarettesPerDay) {
    final t = (cigarettesPerDay / 15).clamp(0.0, 1.0);
    return currentSmokerLight + (currentSmokerHeavy - currentSmokerLight) * t;
  }
}

/// One point of a lung-function scenario curve.
class LungPoint {
  const LungPoint({required this.age, required this.percentOfPeak});

  /// Age in years.
  final int age;

  /// Typical FEV1 as a percentage of the young-adult peak (0–100).
  final double percentOfPeak;
}

/// The three scenarios drawn on the lung chart.
enum LungScenario { neverSmoked, keepThisPace, quitToday }

/// Typical FEV1 trajectory as a percentage of peak, from [fromAge] to
/// [toAge]. Peak FEV1 is reached at ~25 and a reference peak of 4.0 L is
/// used only to convert mL/year into a percentage slope; the absolute litre
/// value is never shown.
List<LungPoint> typicalFev1Curve({
  required LungScenario scenario,
  required int fromAge,
  int toAge = 80,
  double cigarettesPerDay = 15,
  int? quitAge,
}) {
  const referencePeakMl = 4000.0;
  const peakAge = 25;
  final start = math.max(fromAge, 18);
  final points = <LungPoint>[];
  var percent = 100.0;

  // Rewind: everyone shares the never-smoker slope before [fromAge] only for
  // curve continuity; the chart starts at the user's current age anyway.
  for (var age = start; age <= toAge; age++) {
    points.add(LungPoint(age: age, percentOfPeak: percent.clamp(0, 100)));
    if (age < peakAge) {
      continue;
    }
    final declineMl = switch (scenario) {
      LungScenario.neverSmoked => Fev1Decline.neverSmoker,
      LungScenario.keepThisPace => Fev1Decline.forIntake(cigarettesPerDay),
      LungScenario.quitToday => age >= (quitAge ?? start)
          ? Fev1Decline.sustainedQuitter
          : Fev1Decline.forIntake(cigarettesPerDay),
    };
    percent -= declineMl / referencePeakMl * 100;
  }
  return points;
}

/// Percentage-point gap at [atAge] between carrying on and quitting today —
/// the number the shaded area on the chart is worth.
double scenarioGapAt({
  required int fromAge,
  required int atAge,
  required double cigarettesPerDay,
}) {
  double valueAt(LungScenario scenario) {
    final curve = typicalFev1Curve(
      scenario: scenario,
      fromAge: fromAge,
      toAge: atAge,
      cigarettesPerDay: cigarettesPerDay,
      quitAge: fromAge,
    );
    return curve.isEmpty ? 0 : curve.last.percentOfPeak;
  }

  return valueAt(LungScenario.quitToday) - valueAt(LungScenario.keepThisPace);
}

/// Mist level drawn inside the lung illustration, 0..1, from the relative
/// particle load (module report §1). Never a "percent cleaned" claim: the
/// UI labels it as more/less, and the value only ever moves the artwork.
double mistLevel({required int tarLoadVsBaseline}) =>
    (tarLoadVsBaseline / 100).clamp(0.0, 1.0);
