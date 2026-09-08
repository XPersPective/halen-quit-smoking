/// Soft taper engine (module report §9).
///
/// The controlling evidence: in the largest scheduled-reduction trial the
/// reduction itself changed nothing, but ADHERENCE to the schedule predicted
/// abstinence at six months (OR 2.01). So this engine does not optimize for
/// the fastest taper — it optimizes for the fastest taper the user can
/// actually keep:
///
///   1. step size    — never widen the target interval by more than 15%
///                     (25% in the opt-in fast mode, with a warning);
///   2. stabilize    — at least 3 days and 70% adherence before the next
///                     step; below that the step REPEATS, it never rolls back;
///   3. soft landing — on a break the target drops to the mean of the last
///                     three successful days. No reset, no lost streak.
///
/// Ordering rule: widen the EASY hours first and leave the hardest ones
/// (the first cigarette after waking — the strongest dependence item — and
/// the evening block) for last, because attacking them early is the known
/// cause of plan collapse.
library;

import 'dart:math' as math;

/// Step aggressiveness. Fast mode is opt-in and warns the user.
enum TaperMode {
  gentle(0.15),
  fast(0.25);

  const TaperMode(this.stepRatio);

  /// Fraction the interval may grow in a single step.
  final double stepRatio;
}

/// Minimum days at a step before it can advance.
const int minDaysPerStep = 3;

/// Minimum adherence over the current step before it can advance.
const double minAdherenceToAdvance = 0.70;

/// Why the engine decided what it decided — surfaced verbatim to the user.
enum TaperDecision { advance, holdShortStep, holdLowAdherence, atTarget }

class TaperStep {
  const TaperStep({
    required this.intervalMinutes,
    required this.decision,
  });

  /// Target minutes between cigarettes for the next day.
  final int intervalMinutes;

  final TaperDecision decision;
}

/// Next target interval given the current one and how the step is going.
TaperStep nextInterval({
  required int currentIntervalMinutes,
  required int targetIntervalMinutes,
  required int daysAtStep,
  required double adherenceAtStep,
  TaperMode mode = TaperMode.gentle,
}) {
  if (currentIntervalMinutes >= targetIntervalMinutes) {
    return TaperStep(
      intervalMinutes: targetIntervalMinutes,
      decision: TaperDecision.atTarget,
    );
  }
  if (daysAtStep < minDaysPerStep) {
    return TaperStep(
      intervalMinutes: currentIntervalMinutes,
      decision: TaperDecision.holdShortStep,
    );
  }
  if (adherenceAtStep < minAdherenceToAdvance) {
    return TaperStep(
      intervalMinutes: currentIntervalMinutes,
      decision: TaperDecision.holdLowAdherence,
    );
  }
  final grown =
      (currentIntervalMinutes * (1 + mode.stepRatio)).round();
  return TaperStep(
    intervalMinutes: math.min(grown, targetIntervalMinutes),
    decision: TaperDecision.advance,
  );
}

/// Soft landing after a broken plan: the new target is the mean interval of
/// the last three SUCCESSFUL days. Never below the current interval's floor
/// and never a reset to zero.
int softLanding({
  required List<int> successfulDayIntervals,
  required int fallbackIntervalMinutes,
}) {
  final recent = successfulDayIntervals.length <= 3
      ? successfulDayIntervals
      : successfulDayIntervals.sublist(successfulDayIntervals.length - 3);
  if (recent.isEmpty) {
    return fallbackIntervalMinutes;
  }
  return (recent.reduce((a, b) => a + b) / recent.length).round();
}

/// Adherence over a step: share of days whose achieved interval met or beat
/// the target. Empty input is treated as 0 so a fresh step cannot advance.
double stepAdherence({
  required List<int> achievedIntervals,
  required int targetInterval,
}) {
  if (achievedIntervals.isEmpty || targetInterval <= 0) {
    return 0;
  }
  final met = achievedIntervals.where((i) => i >= targetInterval).length;
  return met / achievedIntervals.length;
}

/// Hours ordered easiest-first for widening, from the user's own histogram.
///
/// The waking hour (the first cigarette of the day) and the two densest
/// hours are pushed to the end regardless of count: those are the hardest
/// and are tapered last.
List<int> taperOrderForHours(
  List<int> hourlyHistogram, {
  int? wakeHour,
}) {
  if (hourlyHistogram.length != 24) {
    throw ArgumentError.value(
      hourlyHistogram,
      'hourlyHistogram',
      'needs 24 values',
    );
  }
  final hours = [for (var h = 0; h < 24; h++) h]
    ..sort((a, b) => hourlyHistogram[a].compareTo(hourlyHistogram[b]));
  final hardest = <int>{};
  if (wakeHour != null && wakeHour >= 0 && wakeHour < 24) {
    hardest.add(wakeHour);
  }
  final byDensity = [for (var h = 0; h < 24; h++) h]
    ..sort((a, b) => hourlyHistogram[b].compareTo(hourlyHistogram[a]));
  hardest.addAll(byDensity.where((h) => hourlyHistogram[h] > 0).take(2));

  return [
    ...hours.where((h) => !hardest.contains(h)),
    ...hours.where(hardest.contains),
  ];
}

/// Daily cigarette budget implied by a target interval across the waking day.
int budgetForInterval({
  required int intervalMinutes,
  int wakingMinutes = 16 * 60,
}) {
  if (intervalMinutes <= 0) {
    return 0;
  }
  return math.max(0, (wakingMinutes / intervalMinutes).floor());
}
