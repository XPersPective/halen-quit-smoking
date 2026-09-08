/// Progress Score — "am I getting better?" (module report §14.1).
///
/// Measures BEHAVIOUR, not health. The published weights live here and the
/// "How is this calculated?" screen reads them from this file so the screen
/// can never drift from the formula:
///
///   35  plan adherence over 14 days   (adherence predicts abstinence)
///   30  consumption trend vs baseline (the actual goal)
///   20  craving coping rate           (the skill the user can build)
///   10  logging consistency           (without data nothing else is real)
///    5  nicotine baseline fall        (the physiological direction)
///
/// Design rules encoded below: a 14-day window, a ±[maxDailyDelta] daily
/// change clamp so one bad day cannot crater the score, and no reset ever.
library;

import 'dart:math' as math;

/// Published component weights (0–100 total).
enum ProgressComponent {
  adherence(35),
  consumptionTrend(30),
  cravingCoping(20),
  loggingConsistency(10),
  nicotineBaselineFall(5);

  const ProgressComponent(this.weight);

  final int weight;
}

/// Bands — deliberately non-judgemental, no red.
enum ProgressBand { starting, onTrack, strong, veryStrong }

ProgressBand progressBandFor(int score) {
  if (score < 40) {
    return ProgressBand.starting;
  }
  if (score < 70) {
    return ProgressBand.onTrack;
  }
  return score < 90 ? ProgressBand.strong : ProgressBand.veryStrong;
}

/// Largest movement allowed in one day, in points.
const int maxDailyDelta = 4;

/// Days of history the score looks at.
const int progressWindowDays = 14;

/// Inputs, all derived from the user's own records.
class ProgressInputs {
  const ProgressInputs({
    required this.adherence14d,
    required this.baselineCpd,
    required this.recentCpd,
    required this.cravingsResisted,
    required this.cravingsTotal,
    required this.daysLogged,
    required this.daysInWindow,
    required this.nicotineBaselineFall,
  });

  /// Mean plan adherence over the window, 0..1.
  final double adherence14d;

  /// Calibrated baseline cigarettes per day.
  final double baselineCpd;

  /// Mean cigarettes per day over the window.
  final double recentCpd;

  /// Resisted cravings in the window.
  final int cravingsResisted;

  /// All craving records in the window.
  final int cravingsTotal;

  /// Days in the window carrying at least one record or an explicit
  /// zero-day confirmation.
  final int daysLogged;

  /// Window length actually available (may be < 14 for new users).
  final int daysInWindow;

  /// Fall of the modelled nicotine baseline against the window start, 0..1.
  final double nicotineBaselineFall;
}

/// One component's contribution, for the breakdown sheet.
class ProgressBreakdown {
  const ProgressBreakdown({
    required this.component,
    required this.ratio,
    required this.points,
  });

  final ProgressComponent component;

  /// The component's normalized performance, 0..1.
  final double ratio;

  /// Points earned out of the component's weight.
  final double points;
}

/// Full result: the score, its band and the per-component breakdown.
class ProgressResult {
  const ProgressResult({required this.score, required this.breakdown});

  final int score;
  final List<ProgressBreakdown> breakdown;

  ProgressBand get band => progressBandFor(score);
}

/// Computes the Progress Score (0–100) from [inputs].
///
/// [previousScore], when given, clamps the movement to ±[maxDailyDelta] so
/// the number behaves like a trend rather than a mood.
ProgressResult progressScore(ProgressInputs inputs, {int? previousScore}) {
  final trendRatio = inputs.baselineCpd <= 0
      ? 0.0
      : (1 - inputs.recentCpd / inputs.baselineCpd).clamp(0.0, 1.0);
  final copingRatio = inputs.cravingsTotal <= 0
      ? 0.5 // no cravings logged yet — neutral, never punitive
      : (inputs.cravingsResisted / inputs.cravingsTotal).clamp(0.0, 1.0);
  final loggingRatio = inputs.daysInWindow <= 0
      ? 0.0
      : (inputs.daysLogged / inputs.daysInWindow).clamp(0.0, 1.0);

  final ratios = <ProgressComponent, double>{
    ProgressComponent.adherence: inputs.adherence14d.clamp(0.0, 1.0),
    ProgressComponent.consumptionTrend: trendRatio,
    ProgressComponent.cravingCoping: copingRatio,
    ProgressComponent.loggingConsistency: loggingRatio,
    ProgressComponent.nicotineBaselineFall:
        inputs.nicotineBaselineFall.clamp(0.0, 1.0),
  };

  final breakdown = [
    for (final component in ProgressComponent.values)
      ProgressBreakdown(
        component: component,
        ratio: ratios[component]!,
        points: ratios[component]! * component.weight,
      ),
  ];

  final raw = breakdown
      .fold<double>(0, (sum, b) => sum + b.points)
      .round()
      .clamp(0, 100);
  final score = previousScore == null
      ? raw
      : raw.clamp(
          previousScore - maxDailyDelta,
          previousScore + maxDailyDelta,
        );
  return ProgressResult(score: score, breakdown: breakdown);
}

/// Change over [days] for the "▲ 6 points in 7 days" line that is shown
/// BEFORE the absolute number (trend beats absolute, module report §15.3).
int progressDelta(List<int> history, {int days = 7}) {
  if (history.length < 2) {
    return 0;
  }
  final last = history.last;
  final index = math.max(0, history.length - 1 - days);
  return last - history[index];
}
