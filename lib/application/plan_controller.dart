import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../data/db/app_database.dart';
import '../domain/entities.dart';
import '../domain/nicotine_model.dart';
import '../domain/plan_engine.dart';
import 'providers.dart';

/// Writes and adapts the daily plan (report §14) and derives the BUGÜN
/// screen state. Presentation-only logic lives in the screen; everything
/// numeric comes from the pure domain layer.
class PlanController {
  PlanController(this._db);

  final AppDatabase _db;

  /// Ensures a DailyPlan row exists for [now]'s local day. The target comes
  /// from the previous 7 days' average (falling back to the calibrated
  /// baseline during week 1) reduced by the pace's weekly rate. A weekly
  /// overshoot softens the next week by 5% (report §14.4c).
  Future<DailyPlanRow> ensureTodayPlan(DateTime now) async {
    final key = dayKey(now);
    final existing = await _db.planDao.getPlan(key);
    if (existing != null) {
      return existing;
    }

    final profile = await _db.profileDao.getSmokingProfile();
    if (profile == null) {
      throw StateError('ensureTodayPlan requires an onboarded profile');
    }

    final weekStart = dayStartMinusDays(now, 7);
    final summaries =
        await _db.statsDao.getSummariesBetween(dayKey(weekStart), key);
    final days = summaries.where((s) => s.count > 0).map((s) => s.count).toList();

    final prevAvg = days.length >= 3
        ? days.reduce((a, b) => a + b) / days.length
        : calibrateBaseline(
            onboardingCpd: profile.baselineCpd,
            firstWeekDailyCounts: days,
          );

    // Weekly overshoot: the previous week's total ran above its planned
    // budget total → next week starts 5% gentler (S3 adjustment, no penalty).
    final plannedTotal = summaries
        .where((s) => s.planTarget != null)
        .fold<int>(0, (sum, s) => sum + s.planTarget!);
    final actualTotal =
        summaries.fold<int>(0, (sum, s) => sum + s.count);
    final soften = plannedTotal > 0 && actualTotal > plannedTotal;

    final speed = PlanSpeed.forPaceWithTtfc(profile.pace, profile.ttfcBand);
    var target = targetForDay(prevWeekAvg: prevAvg, speed: speed, soften: soften);

    // Quit-now users skip the taper: immediate final-week phase.
    if (profile.targetMode == TargetMode.quitNow) {
      target = 0;
    }

    final phase = profile.targetMode == TargetMode.quitNow
        ? PlanPhase.finalWeek
        : phaseForTarget(target);

    final companion = DailyPlanCompanion.insert(
      date: key,
      targetCount: target,
      phase: phase,
      tempo: profile.pace,
    );
    await _db.planDao.upsertPlan(companion);
    return (await _db.planDao.getPlan(key))!;
  }

  /// Post-record recalculation (report §14.4): redistribute the remaining
  /// budget over the rest of the waking day; detect the clustered pattern;
  /// persist a PlanAdjustment row for the plan screen's history.
  Future<Redistribution> recalculateAfterRecord({
    required DateTime now,
    required List<CigaretteEventRow> todayEvents,
    required DailyPlanRow plan,
    required int wakingDayEndHour,
  }) async {
    final medianGap = medianGapMinutes(
      [for (final e in todayEvents) e.ts],
    );

    final result = redistributeDay(
      now: now,
      targetToday: plan.targetCount,
      smokedToday: todayEvents.length,
      dayEnd: DateTime(now.year, now.month, now.day, wakingDayEndHour),
      todayEvents: [for (final e in todayEvents) e.ts],
      medianGap: medianGap,
    );

    if (result.messageKey != 'completed') {
      await _db.planDao.insertAdjustment(
        PlanAdjustmentCompanion.insert(
          date: dayKey(now),
          reason: AdjustmentReason.overshoot,
          fromCount: plan.targetCount,
          toCount: plan.targetCount,
          messageKey: result.messageKey,
        ),
      );
    }
    return result;
  }

  /// Applies the tempo adaptation decision (report §14.5) after a 7-day
  /// adherence check: ≥85% suggests a faster pace; ≤55% extends the phase
  /// by lowering the target floor (never below 1 before the final week).
  Future<TempoDecision> adaptTempo({
    required DateTime now,
    required double adherence7,
  }) async {
    final decision = tempoDecision(adherence7: adherence7);
    final profile = await _db.profileDao.getSmokingProfile();
    if (profile == null || decision == TempoDecision.keep) {
      return decision;
    }

    if (decision == TempoDecision.suggestFaster) {
      // Only a suggestion is stored — the user applies it from the plan
      // screen (tempoUpApply). Nothing changes silently here.
      await _db.planDao.insertAdjustment(
        PlanAdjustmentCompanion.insert(
          date: dayKey(now),
          reason: AdjustmentReason.paceUp,
          fromCount: 0,
          toCount: 0,
          messageKey: 'tempo_up_suggested',
        ),
      );
    } else {
      // Extend the phase: step down to the next slower pace automatically.
      final Pace slower = switch (profile.pace) {
        Pace.fast => Pace.standard,
        Pace.standard => Pace.calm,
        Pace.calm => Pace.calm,
      };
      if (slower != profile.pace) {
        await _db.profileDao.saveSmokingProfile(
          SmokingProfileCompanion(pace: Value(slower)),
        );
        await _db.planDao.insertAdjustment(
          PlanAdjustmentCompanion.insert(
            date: dayKey(now),
            reason: AdjustmentReason.paceDown,
            fromCount: 0,
            toCount: 0,
            messageKey: 'tempo_extended',
          ),
        );
      }
    }
    return decision;
  }
}

/// Assembled BUGÜN state — all numbers already S2/S3-classified by their
/// producing domain functions.
class TodayState {
  const TodayState({
    required this.target,
    required this.smoked,
    required this.resistedToday,
    required this.lastCigarette,
    required this.nextSuggestion,
    required this.dayCompleted,
    required this.savingsToday,
    required this.avoidedToday,
    required this.nicotineCurve,
    required this.phase,
    required this.isFirstDay,
    required this.daysSinceStart,
  });

  final int target;
  final int smoked;
  final int resistedToday;
  final DateTime? lastCigarette;
  final DateTime? nextSuggestion;
  final bool dayCompleted;
  final double savingsToday;
  final int avoidedToday;
  final List<int> nicotineCurve;
  final PlanPhase phase;
  final bool isFirstDay;
  final int daysSinceStart;

  double get adherence =>
      target <= 0 ? 1.0 : (smoked <= target ? 1.0 : target / smoked);
}

/// Reactive BUGÜN state. `now` is captured per stream emission; midnight
/// rolls the day key on the next DB write (records dominate screen lifetime).
final todayStateProvider = FutureProvider<TodayState>((ref) async {
  final db = ref.watch(databaseProvider);
  final controller = PlanController(db);
  final now = DateTime.now();

  final profile = await db.profileDao.getSmokingProfile();
  if (profile == null) {
    throw StateError('todayStateProvider requires an onboarded profile');
  }

  final plan = await controller.ensureTodayPlan(now);
  final dayStart = now.dayStart;
  final events =
      await db.recordDao.getEventsBetween(dayStart, dayStart.add(const Duration(days: 1)));
  final resisted =
      await db.cravingDao.countResistedBetween(dayStart, dayStart.add(const Duration(days: 1)));
  final summary = await db.statsDao.getSummary(dayKey(now));

  const nicotine = NicotineModel();
  final curve = nicotine.normalizedCurve(
    now.dayStart,
    now.dayStart.add(const Duration(days: 1)),
    [for (final e in events) e.ts],
  );

  final medianGap = medianGapMinutes([for (final e in events) e.ts]);
  final wakingMinutes = 16 * 60; // 08:00–24:00 default waking window.
  final suggestion = nextSuggestion(
    now: now,
    lastCigarette: events.isEmpty ? null : events.last.ts,
    medianGap: medianGap,
    smokedToday: events.length,
    targetToday: plan.targetCount,
    minutesAwake: now.difference(dayStart).inMinutes.clamp(0, wakingMinutes),
    wakingDayMinutes: wakingMinutes,
  );

  return TodayState(
    target: plan.targetCount,
    smoked: events.length,
    resistedToday: resisted,
    lastCigarette: events.isEmpty ? null : events.last.ts,
    nextSuggestion: suggestion,
    dayCompleted: plan.targetCount > 0 && events.length >= plan.targetCount,
    savingsToday: summary?.savings ?? 0,
    avoidedToday: summary?.avoidedCount ?? 0,
    nicotineCurve: curve,
    phase: plan.phase,
    isFirstDay: now.difference(profile.startedAt).inDays < 1 && events.isEmpty,
    daysSinceStart: now.difference(profile.startedAt).inDays.clamp(0, 1 << 30),
  );
});
