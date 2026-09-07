/// Deterministic rule engine for the adaptive taper plan (report §14).
///
/// Pure Dart — no Flutter, no I/O, no clock reads: every function takes `now`
/// explicitly so behavior is fully testable. The engine never punishes: on
/// overshoot it redistributes the remaining budget and reports
/// "Yeniden hesapladık." (we recalculated).
library;

import 'dart:math' as math;

import 'entities.dart';

/// Reduction speed of the current plan.
class PlanSpeed {
  const PlanSpeed({required this.pace, required this.weeklyRate});

  final Pace pace;
  final double weeklyRate;

  /// Mid-point of the pace's tolerated weekly reduction band
  /// (calm 8–10%, standard 12–15%, fast 18–22% — report §14).
  static PlanSpeed forPace(Pace pace) =>
      PlanSpeed(pace: pace, weeklyRate: (pace.minWeeklyRate + pace.maxWeeklyRate) / 2);

  /// Slower start for heavy dependence: TTFC < 5 min adds +1 week of
  /// flexibility, realized as a lower starting rate (report §14.5).
  static PlanSpeed forPaceWithTtfc(Pace pace, TtfcBand ttfc) {
    final rate = ttfc == TtfcBand.under5
        ? pace.minWeeklyRate
        : (pace.minWeeklyRate + pace.maxWeeklyRate) / 2;
    return PlanSpeed(pace: pace, weeklyRate: rate);
  }
}

/// Baseline consumption calibrated from real records (report §14 inputs).
double calibrateBaseline({
  required int onboardingCpd,
  required List<int> firstWeekDailyCounts,
}) {
  final days = firstWeekDailyCounts.where((c) => c > 0).toList();
  if (days.length < 3) {
    // Not enough real data yet — estimate from onboarding (report §4:
    // empty-state starts from onboarding data).
    return onboardingCpd.toDouble();
  }
  return days.reduce((a, b) => a + b) / days.length;
}

/// Daily budget: `target = prev week avg × (1 − weekly rate)`, rounded DOWN
/// to a whole cigarette (report §14.1). [soften] applies the 5% softening
/// used after a weekly overshoot (report §14.4).
int targetForDay({
  required double prevWeekAvg,
  required PlanSpeed speed,
  bool soften = false,
}) {
  final base = soften ? prevWeekAvg * 0.95 : prevWeekAvg;
  final target = (base * (1 - speed.weeklyRate)).floor();
  return target < 0 ? 0 : target;
}

/// A target time window for one planned cigarette, minutes from midnight.
/// A window wrapping midnight (e.g. 22:00–02:00) has [endMinute] smaller
/// than [startMinute]; [contains] treats it as cyclic.
class DayWindow {
  const DayWindow({required this.startMinute, required this.endMinute});

  final int startMinute;
  final int endMinute;

  bool get wrapsMidnight => endMinute <= startMinute;

  bool contains(int minuteOfDay) {
    if (wrapsMidnight) {
      return minuteOfDay >= startMinute || minuteOfDay < endMinute;
    }
    return minuteOfDay >= startMinute && minuteOfDay < endMinute;
  }
}

/// Clusters the hour-of-day histogram into dense blocks (report §14.2:
/// simple window clustering, not k-means). Adjacent hours (±1h gap) merge;
/// the day is treated as cyclic (22:00 wraps to 00:00). Returns at most
/// [maxWindows] windows sorted by density (densest first).
List<DayWindow> dayWindows(List<int> hourlyHistogram, {int maxWindows = 6}) {
  if (hourlyHistogram.length != 24) {
    throw ArgumentError.value(hourlyHistogram, 'hourlyHistogram', 'needs 24 values');
  }
  final maxCount = hourlyHistogram
      .reduce((a, b) => a > b ? a : b);
  if (maxCount == 0) {
    return const [];
  }
  final threshold = maxCount * 0.5;

  // Seed blocks: contiguous (cyclic) hours above the threshold.
  final seeds = <(int, int)>[];
  var started = false;
  var (int s, int e) = (0, 0);
  for (var h = 0; h < 24; h++) {
    final above = hourlyHistogram[h] >= threshold;
    if (above && !started) {
      (s, e) = (h, h);
      started = true;
    } else if (above && started) {
      e = h;
    }
    if (!above && started) {
      seeds.add((s, e));
      started = false;
    }
  }
  if (started) {
    // Wrap: merge a trailing block with a leading 00:xx block.
    if (seeds.isNotEmpty && seeds.first.$1 == 0) {
      seeds[0] = (s, seeds.first.$2 + 24);
    } else {
      seeds.add((s, e));
    }
  }

  // Merge blocks whose gap is ≤ 1 hour (cyclically).
  final merged = <(int, int)>[...seeds]..sort((a, b) => a.$1.compareTo(b.$1));
  var changed = true;
  while (changed && merged.length > 1) {
    changed = false;
    for (var i = 0; i < merged.length; i++) {
      for (var j = 0; j < merged.length; j++) {
        if (i == j) {
          continue;
        }
        final (s1, e1) = merged[i];
        final (s2, e2) = merged[j];
        final gap = _cyclicGapMinutes(e1, s2);
        if (gap <= 60) {
          merged[i] = (s1, e2 > e1 ? e2 : e1);
          merged.removeAt(j);
          changed = true;
          break;
        }
      }
      if (changed) {
        break;
      }
    }
  }

  // Window covers the block padded to the full hour after its last hour.
  // A block ending at 23:00 (no wrap) runs to 24:00; a merged cyclic block
  // (e.g. hours 22..25 = 22,23,0,1) ends at (e+1)%24 — here 02:00.
  final windows = [
    for (final (s, e) in merged)
      DayWindow(
        startMinute: (s % 24) * 60,
        endMinute: _endMinuteFor(e),
      ),
  ];
  // Rank by total count inside the block, keep the densest [maxWindows].
  windows.sort((a, b) => _blockWeight(b, hourlyHistogram).compareTo(_blockWeight(a, hourlyHistogram)));
  return windows.take(maxWindows).toList();
}

int _blockWeight(DayWindow w, List<int> histogram) {
  var weight = 0;
  for (var h = 0; h < 24; h++) {
    if (w.contains(h * 60 + 30)) {
      weight += histogram[h];
    }
  }
  return weight;
}

int _endMinuteFor(int endHour) {
  final next = (endHour + 1) % 24;
  return next == 0 ? 1440 : next * 60;
}

int _cyclicGapMinutes(int fromHour, int toHour) =>
    ((toHour - fromHour) % 24) * 60;

/// Median gap in minutes between consecutive cigarette events (sorted).
/// Null when fewer than two events.
int? medianGapMinutes(List<DateTime> events) {
  if (events.length < 2) {
    return null;
  }
  final sorted = [...events]..sort();
  final gaps = [
    for (var i = 1; i < sorted.length; i++) sorted[i].difference(sorted[i - 1]).inMinutes,
  ]..sort();
  final mid = gaps.length ~/ 2;
  return gaps.length.isOdd ? gaps[mid] : ((gaps[mid - 1] + gaps[mid]) / 2).round();
}

/// Target gap range for the next cigarette: median gap ±25% buffer
/// (report §14.2). Below 5/day the plan uses only a min-gap rule, so
/// [minOnly] drops the upper bound.
({int minGapMinutes, int? maxGapMinutes}) targetGapRange(
  int? medianGap, {
  bool minOnly = false,
}) {
  if (medianGap == null) {
    return (minGapMinutes: 0, maxGapMinutes: null);
  }
  final minGap = (medianGap * 0.75).round();
  return (
    minGapMinutes: minGap,
    maxGapMinutes: minOnly ? null : (medianGap * 1.25).round(),
  );
}

/// Next cigarette suggestion: `last + median gap × tempo factor`
/// (report §14.3). The factor delays the suggestion when the user is pacing
/// ahead of plan (over-consuming relative to the remaining budget) and
/// returns null when the daily budget is exhausted ("bugünlük tamamlandı").
DateTime? nextSuggestion({
  required DateTime now,
  required DateTime? lastCigarette,
  required int? medianGap,
  required int smokedToday,
  required int targetToday,
  required int minutesAwake,
  required int wakingDayMinutes,
}) {
  if (lastCigarette == null || medianGap == null || medianGap <= 0) {
    return null;
  }
  if (targetToday <= 0 || smokedToday >= targetToday) {
    return null; // Daily budget used up — no further suggestion today.
  }
  final plannedRate = targetToday / wakingDayMinutes;
  final actualRate = minutesAwake <= 0 ? 0.0 : smokedToday / minutesAwake;
  // Over plan pace → delay proportionally; at/below plan → keep rhythm.
  final tempoFactor = actualRate > plannedRate && plannedRate > 0
      ? (actualRate / plannedRate).clamp(1.0, 3.0)
      : 1.0;
  final delayMinutes = (medianGap * tempoFactor).round();
  final suggestion = lastCigarette.add(Duration(minutes: delayMinutes));
  // A suggestion exactly at `now` is still actionable ("en erken şimdi").
  return suggestion.isBefore(now) ? null : suggestion;
}

/// Result of the dynamic recalculation after a record (report §14.4).
class Redistribution {
  const Redistribution({
    required this.remainingBudget,
    required this.minGapMinutes,
    required this.messageKey,
    this.completedDay = false,
  });

  final int remainingBudget;
  final int minGapMinutes;
  final String messageKey;
  final bool completedDay;
}

/// Recomputes the rest of the day after a record: spreads the remaining
/// budget evenly over the remaining waking minutes. `messageKey` is one of
/// `completed`, `recalculated`, `clustered` — presentation maps them to
/// positive, no-red UI copy ("Yeniden hesapladık.").
Redistribution redistributeDay({
  required DateTime now,
  required int targetToday,
  required int smokedToday,
  required DateTime dayEnd,
  required List<DateTime> todayEvents,
  required int? medianGap,
}) {
  final remainingBudget = targetToday - smokedToday;
  if (remainingBudget <= 0) {
    return const Redistribution(
      remainingBudget: 0,
      minGapMinutes: 0,
      messageKey: 'completed',
      completedDay: true,
    );
  }
  final remainingMinutes = dayEnd.difference(now).inMinutes.clamp(1, 24 * 60);
  final minGap = (remainingMinutes / remainingBudget).ceil();

  final clustered = isClusteredPattern(todayEvents, medianGap: medianGap);
  return Redistribution(
    remainingBudget: remainingBudget,
    minGapMinutes: minGap,
    messageKey: clustered ? 'clustered' : 'recalculated',
  );
}

/// Cluster ("sıkışma") pattern: the last three gaps are all below half the
/// median gap — consumption is piling up on the planned intervals
/// (report §14.4b).
bool isClusteredPattern(List<DateTime> todayEvents, {required int? medianGap}) {
  if (medianGap == null || medianGap <= 0 || todayEvents.length < 4) {
    return false;
  }
  final sorted = [...todayEvents]..sort();
  final gaps = [
    for (var i = 1; i < sorted.length; i++) sorted[i].difference(sorted[i - 1]).inMinutes,
  ];
  final last3 = gaps.length < 3 ? gaps : gaps.sublist(gaps.length - 3);
  return last3.length == 3 && last3.every((g) => g < medianGap / 2);
}

/// Tempo adaptation decision from the 7-day adherence (report §14.5).
enum TempoDecision { suggestFaster, extendPhase, keep }

TempoDecision tempoDecision({required double adherence7}) {
  if (adherence7 >= 0.85) {
    return TempoDecision.suggestFaster;
  }
  if (adherence7 <= 0.55) {
    return TempoDecision.extendPhase;
  }
  return TempoDecision.keep;
}

/// Plan phase for a daily budget (report §14.6): at ≤3/day the plan enters
/// its final week and asks the user to confirm a quit date.
PlanPhase phaseForTarget(int targetToday) =>
    targetToday <= 3 && targetToday > 0
        ? PlanPhase.finalWeek
        : PlanPhase.reduction;

/// Interval estimate "if the last 7 days keep this pace" (report §14.7).
/// Returns whole weeks to reach the quit threshold (3/day) at the pace's
/// fastest and slowest tolerated rates. S3-classed: the UI must show this as
/// a two-sided interval estimate, never a promise.
({int minWeeks, int maxWeeks})? quitWeeksEstimate({
  required double last7DayAvg,
  required Pace pace,
}) {
  const quitThreshold = 3.0;
  if (last7DayAvg <= quitThreshold) {
    return (minWeeks: 1, maxWeeks: 1);
  }
  int weeksAtRate(double rate) {
    final weeks = math.log(last7DayAvg / quitThreshold) / -math.log(1 - rate);
    return weeks.ceil().clamp(1, 52);
  }

  final fast = weeksAtRate(pace.maxWeeklyRate);
  final slow = weeksAtRate(pace.minWeeklyRate);
  return (minWeeks: fast, maxWeeks: slow);
}
