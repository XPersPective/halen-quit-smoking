/// Plan system and plan-switching rules (module report §13).
///
/// Four plans, because the category's blind spot is the irregular ("random")
/// smoker: an interval-based taper fails them every day and they delete the
/// app. A daily-quota plan keeps that segment inside the product.
///
/// Switching is possible but deliberate: a 7-day minimum, a data-backed
/// report card shown before the switch, a data-backed suggestion, no history
/// loss, and a gentle note after too many switches. Track Only can always be
/// left immediately — it is the no-pressure entry point, never a trap.
library;

import 'dart:math' as math;

enum PlanKind {
  /// Widening the interval between cigarettes.
  gradualTaper,

  /// A daily ceiling with no clock constraints — for irregular smokers.
  dailyQuota,

  /// A chosen quit date with withdrawal support.
  quitDay,

  /// No target, no judgement, records only.
  trackOnly,
}

/// Minimum days in a plan before switching (Track Only is exempt).
const int minDaysInPlan = 7;

/// Switches within 30 days after which the gentle note appears.
const int frequentSwitchThreshold = 3;

/// Why a switch was allowed or held.
enum SwitchVerdict { allowed, tooSoon, allowedWithNote }

/// Can the user change plans right now?
SwitchVerdict canSwitchPlan({
  required PlanKind current,
  required int daysInCurrentPlan,
  required int switchesLast30Days,
}) {
  if (current == PlanKind.trackOnly) {
    return SwitchVerdict.allowed;
  }
  if (daysInCurrentPlan < minDaysInPlan) {
    return SwitchVerdict.tooSoon;
  }
  return switchesLast30Days >= frequentSwitchThreshold
      ? SwitchVerdict.allowedWithNote
      : SwitchVerdict.allowed;
}

/// The four numbers shown before a switch, so the decision is made on data.
class PlanReportCard {
  const PlanReportCard({
    required this.daysInPlan,
    required this.adherence,
    required this.hardestHour,
    required this.cravingsResisted,
  });

  final int daysInPlan;

  /// Mean adherence in this plan, 0..1.
  final double adherence;

  /// The hour of day with the most records while in this plan; null when
  /// there is not enough data to name one.
  final int? hardestHour;

  final int cravingsResisted;
}

/// Data-backed plan suggestion — a suggestion, never an imposition.
///
/// High variance in the hour-of-day pattern means the user has no rhythm for
/// an interval plan to hold on to, so a daily quota fits better.
PlanKind? suggestedPlan({
  required PlanKind current,
  required double intervalVariationCoefficient,
  required double adherence,
  required bool wantsToQuitNow,
}) {
  if (wantsToQuitNow && current != PlanKind.quitDay) {
    return PlanKind.quitDay;
  }
  if (current == PlanKind.gradualTaper &&
      (intervalVariationCoefficient > 0.7 || adherence < 0.4)) {
    return PlanKind.dailyQuota;
  }
  if (current == PlanKind.dailyQuota &&
      intervalVariationCoefficient <= 0.4 &&
      adherence >= 0.7) {
    return PlanKind.gradualTaper;
  }
  return null;
}

/// Coefficient of variation of the gaps between cigarettes — the measure of
/// "is this person regular enough for an interval plan?".
double intervalVariationCoefficient(List<DateTime> events) {
  if (events.length < 4) {
    return 0;
  }
  final sorted = [...events]..sort();
  final gaps = <double>[
    for (var i = 1; i < sorted.length; i++)
      sorted[i].difference(sorted[i - 1]).inMinutes.toDouble(),
  ];
  final mean = gaps.reduce((a, b) => a + b) / gaps.length;
  if (mean <= 0) {
    return 0;
  }
  final variance =
      gaps.map((g) => (g - mean) * (g - mean)).reduce((a, b) => a + b) /
          gaps.length;
  return (variance <= 0 ? 0.0 : math.sqrt(variance)) / mean;
}
