import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../data/db/app_database.dart';
import '../domain/plan_kinds.dart';
import '../domain/soft_taper.dart';
import 'providers.dart';

/// Runs the soft taper (module report §9) once per day.
///
/// The rule the largest scheduled-reduction trial actually supports is that
/// ADHERENCE, not speed, predicts abstinence — so this controller optimizes
/// for a taper the user can keep:
///
///  * a step widens the target gap by at most 15% (25% in opt-in fast mode);
///  * it advances only after 3 days AND 70% adherence, otherwise it REPEATS
///    the step — it never rolls back, because rolling back reads as failure;
///  * on a broken day the target lands softly on the mean of the last three
///    successful days. Nothing resets, ever.
class TaperController {
  TaperController(this._db);

  final AppDatabase _db;

  /// Applies at most one taper decision per calendar day.
  ///
  /// Returns the decision taken so the UI can say what happened in the user's
  /// own words, or null when the active plan is not an interval taper.
  ///
  /// Re-running on the same day replays the stored decision WITHOUT writing:
  /// the daily provider is read from the widget tree, and a write on every
  /// build would feed straight back into the plan-state stream.
  Future<TaperStep?> runDailyStep(DateTime now) async {
    final state = await _db.moduleDao.ensurePlanState(now: now);
    if (state.kind != PlanKind.gradualTaper) {
      return null;
    }
    if (state.lastStepDate == dayKey(now) && state.lastStepDecision != null) {
      return TaperStep(
        intervalMinutes: state.intervalMinutes ?? await _seedInterval(now),
        decision: state.lastStepDecision!,
      );
    }

    final achieved = await _achievedIntervals(now, days: 7);
    final current = state.intervalMinutes ?? await _seedInterval(now);
    final target = state.targetIntervalMinutes ?? current * 3;

    final step = nextInterval(
      currentIntervalMinutes: current,
      targetIntervalMinutes: target,
      daysAtStep: state.daysAtStep,
      adherenceAtStep: stepAdherence(
        achievedIntervals: achieved,
        targetInterval: current,
      ),
      mode: state.taperMode,
    );

    await _db.moduleDao.updatePlanState(
      PlanStateCompanion(
        intervalMinutes: Value(step.intervalMinutes),
        targetIntervalMinutes: Value(target),
        // Advancing starts a fresh stabilization window; holding extends it.
        daysAtStep: Value(
          step.decision == TaperDecision.advance ? 0 : state.daysAtStep + 1,
        ),
        lastStepDate: Value(dayKey(now)),
        lastStepDecision: Value(step.decision),
      ),
    );
    return step;
  }

  /// Soft landing after a broken plan (never a reset): the target drops to
  /// the mean interval of the last three successful days.
  Future<int> applySoftLanding(DateTime now) async {
    final state = await _db.moduleDao.ensurePlanState(now: now);
    final achieved = await _achievedIntervals(now, days: 14);
    final successful = [
      for (final interval in achieved)
        if (state.intervalMinutes == null || interval >= state.intervalMinutes!)
          interval,
    ];
    // When NO day met the target, falling back to that same target would
    // leave the user stuck against a wall. The honest landing is their real
    // recent rhythm — "re-tuned to you", exactly as the copy promises.
    final landed = softLanding(
      successfulDayIntervals: successful,
      fallbackIntervalMinutes: await _seedInterval(now),
    );
    await _db.moduleDao.updatePlanState(
      PlanStateCompanion(
        intervalMinutes: Value(landed),
        daysAtStep: const Value(0),
      ),
    );
    return landed;
  }

  /// The hours to widen next, easiest first (module report §9.③).
  ///
  /// The wake-up cigarette and the two densest hours are always tapered LAST:
  /// the first cigarette after waking is the strongest dependence item there
  /// is, and attacking it early is the documented way plans collapse.
  Future<List<int>> hoursOrderedForTaper(DateTime now) async {
    final histogram = await _db.statsDao.hourlyHistogram(
      dayStartMinusDays(now, 27),
      now,
    );
    if (histogram.length != 24 || histogram.every((h) => h == 0)) {
      return const [];
    }
    final firstOfDay = await _db.statsDao.getSummariesBetween(
      dayKey(dayStartMinusDays(now, 6)),
      dayKey(now),
    );
    final wakeHours = [
      for (final summary in firstOfDay)
        if (summary.firstTs != null) summary.firstTs!.hour,
    ];
    final wakeHour = wakeHours.isEmpty
        ? null
        : (wakeHours.reduce((a, b) => a + b) / wakeHours.length).round();
    return taperOrderForHours(histogram, wakeHour: wakeHour);
  }

  /// The daily ceiling implied by the current target interval — what the
  /// quota plan shows instead of a clock.
  Future<int> dailyCeiling(DateTime now) async {
    final state = await _db.moduleDao.ensurePlanState(now: now);
    return budgetForInterval(
      intervalMinutes: state.intervalMinutes ?? await _seedInterval(now),
    );
  }

  /// Mean achieved gap for each of the last [days] days, oldest first.
  /// Days with fewer than two records contribute nothing — a single record
  /// says nothing about spacing.
  Future<List<int>> _achievedIntervals(DateTime now, {required int days}) async {
    final result = <int>[];
    for (var i = days - 1; i >= 0; i--) {
      final start = dayStartMinusDays(now, i);
      final events = await _db.recordDao.getEventsBetween(
        start,
        start.add(const Duration(days: 1)),
      );
      if (events.length < 2) {
        continue;
      }
      final times = [for (final e in events) e.ts]..sort();
      final total = times.last.difference(times.first).inMinutes;
      result.add((total / (times.length - 1)).round());
    }
    return result;
  }

  /// First interval for a fresh taper: the user's own recent rhythm, or a
  /// conservative hour when there is not enough history to know it.
  Future<int> _seedInterval(DateTime now) async {
    final achieved = await _achievedIntervals(now, days: 7);
    if (achieved.isNotEmpty) {
      return (achieved.reduce((a, b) => a + b) / achieved.length).round();
    }
    // Before any real log exists the plan starts from what the user said in
    // onboarding; without it the generic 60-minute default stands.
    final profile = await _db.profileDao.getSmokingProfile();
    return profile?.declaredRhythmMinutes ?? 60;
  }
}

final taperControllerProvider = Provider<TaperController>(
  (ref) => TaperController(ref.watch(databaseProvider)),
);

/// Today's taper decision.
///
/// Deliberately does NOT watch the plan-state stream: this provider writes to
/// that table, so watching it would rebuild-write-rebuild forever. A plan
/// switch invalidates it explicitly instead (see PlanKindController).
final dailyTaperStepProvider = FutureProvider<TaperStep?>((ref) async {
  return ref.watch(taperControllerProvider).runDailyStep(DateTime.now());
});
