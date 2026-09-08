/// Harm Load — "how much am I carrying?" (module report §14.2).
///
/// NOT a disease-risk estimate. Validated models such as PLCOm2012 tell us
/// WHICH variables matter (age, BMI, smoking intensity, duration, time since
/// quitting, dependence) — this module borrows that variable selection and
/// nothing else. It produces a unitless 0–100 exposure load and the UI states
/// plainly: "this is not a disease risk estimate" (a personal cancer
/// probability would be an S5 claim).
///
/// The design requirement from the report: the number must FALL as the user
/// cuts down. So 45 of the 100 points are live (current intensity 30 +
/// dependence 15), while the cumulative 40 only ever slows down — and, after
/// quitting, is slowly relieved by a recovery credit on a years-long scale.
library;

import 'dart:math' as math;

/// Published component weights.
enum HarmComponent {
  cumulativeExposure(40),
  currentIntensity(30),
  dependenceDepth(15),
  ageAndDuration(10),
  bodySize(5);

  const HarmComponent(this.weight);

  final int weight;
}

/// Bands — worded as load, never as diagnosis.
enum HarmBand { light, moderate, heavy, veryHeavy }

HarmBand harmBandFor(int score) {
  if (score < 25) {
    return HarmBand.light;
  }
  if (score < 50) {
    return HarmBand.moderate;
  }
  return score < 75 ? HarmBand.heavy : HarmBand.veryHeavy;
}

/// Pack-years: the classic cumulative exposure measure
/// (20/day for one year = 1 pack-year).
double packYears({
  required double cigarettesPerDay,
  required double years,
}) =>
    cigarettesPerDay / 20 * years;

/// Inputs. Height and weight are OPTIONAL: leaving them out drops the body
/// component and renormalizes the remaining weights — no feature is gated on
/// them and no body judgement is ever produced.
class HarmInputs {
  const HarmInputs({
    required this.ageYears,
    required this.smokingYears,
    required this.baselineCpd,
    required this.recentCpd,
    required this.hsi,
    this.bmi,
    this.yearsSinceQuit = 0,
  });

  final int ageYears;

  /// Years the user has been smoking.
  final double smokingYears;

  /// Historical average intake, used for the cumulative component.
  final double baselineCpd;

  /// Mean cigarettes per day over the last 30 days — the moving part.
  final double recentCpd;

  /// Heaviness of Smoking Index, 0–6.
  final int hsi;

  /// Optional body-mass index; null when the user did not enter body data.
  final double? bmi;

  /// Years since the quit day, used for the recovery credit.
  final double yearsSinceQuit;
}

/// One component's contribution, for the breakdown sheet.
class HarmBreakdown {
  const HarmBreakdown({
    required this.component,
    required this.ratio,
    required this.points,
  });

  final HarmComponent component;
  final double ratio;
  final double points;
}

class HarmResult {
  const HarmResult({
    required this.score,
    required this.breakdown,
    required this.packYears,
  });

  final int score;
  final List<HarmBreakdown> breakdown;
  final double packYears;

  HarmBand get band => harmBandFor(score);
}

/// Recovery credit applied to the cumulative component after quitting:
/// a slow, years-scale relief that never reaches zero — consistent with the
/// published risk-reduction timeline (5–15 years for stroke, 10 years for
/// lung cancer risk to approach but not equal a never-smoker's).
double recoveryCredit(double yearsSinceQuit) {
  if (yearsSinceQuit <= 0) {
    return 0;
  }
  return (1 - math.exp(-yearsSinceQuit / 10)) * 0.6;
}

/// Computes the Harm Load (0–100).
HarmResult harmLoad(HarmInputs inputs) {
  final py = packYears(
    cigarettesPerDay: inputs.baselineCpd,
    years: inputs.smokingYears,
  );
  // Log scale: 40 pack-years is the reference "full" load, and each halving
  // below that costs a fixed share — matching how risk models treat
  // cumulative exposure rather than a raw linear count.
  final cumulativeRatio = py <= 0
      ? 0.0
      : (math.log(1 + py) / math.log(1 + 40)).clamp(0.0, 1.0);
  final relieved = cumulativeRatio * (1 - recoveryCredit(inputs.yearsSinceQuit));

  // 20/day is the reference for a "full" current intensity.
  final intensityRatio = (inputs.recentCpd / 20).clamp(0.0, 1.0);
  final dependenceRatio = (inputs.hsi / 6).clamp(0.0, 1.0);
  // Age and exposure duration: 40 years of smoking at age 70 is the ceiling.
  final durationRatio = ((inputs.smokingYears / 40) * 0.6 +
          ((inputs.ageYears - 18) / 52).clamp(0.0, 1.0) * 0.4)
      .clamp(0.0, 1.0);
  // BMI is only a mild modifier and only when the user chose to enter it;
  // the reference range keeps the contribution small and non-judgemental.
  final bmiRatio = inputs.bmi == null
      ? null
      : ((inputs.bmi! - 18.5) / (35 - 18.5)).clamp(0.0, 1.0);

  final ratios = <HarmComponent, double?>{
    HarmComponent.cumulativeExposure: relieved,
    HarmComponent.currentIntensity: intensityRatio,
    HarmComponent.dependenceDepth: dependenceRatio,
    HarmComponent.ageAndDuration: durationRatio,
    HarmComponent.bodySize: bmiRatio,
  };

  // Renormalize over the components that actually have data.
  final availableWeight = ratios.entries
      .where((e) => e.value != null)
      .fold<int>(0, (sum, e) => sum + e.key.weight);
  final scale = availableWeight <= 0 ? 0.0 : 100 / availableWeight;

  final breakdown = [
    for (final entry in ratios.entries)
      if (entry.value != null)
        HarmBreakdown(
          component: entry.key,
          ratio: entry.value!,
          points: entry.value! * entry.key.weight * scale,
        ),
  ];

  final score =
      breakdown.fold<double>(0, (sum, b) => sum + b.points).round().clamp(0, 100);
  return HarmResult(score: score, breakdown: breakdown, packYears: py);
}

/// Body-mass index from centimetres and kilograms; null when either is
/// missing or out of a sane range (the UI never demands these).
double? bmiFrom({double? heightCm, double? weightKg}) {
  if (heightCm == null || weightKg == null) {
    return null;
  }
  if (heightCm < 100 || heightCm > 250 || weightKg < 25 || weightKg > 350) {
    return null;
  }
  final m = heightCm / 100;
  return weightKg / (m * m);
}
