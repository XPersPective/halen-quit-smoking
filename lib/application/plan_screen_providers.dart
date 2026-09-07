import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../data/db/app_database.dart';
import '../domain/entities.dart';
import '../domain/plan_engine.dart';
import 'providers.dart';

/// Today's plan row (or null before the first record of the day creates it).
final todayPlanProvider = StreamProvider<DailyPlanRow?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.planDao.watchPlan(dayKey(DateTime.now()));
});

/// Latest plan adjustments for the "Yeniden hesapladık" feed.
final recentAdjustmentsProvider = StreamProvider<List<PlanAdjustmentRow>>(
  (ref) {
    final db = ref.watch(databaseProvider);
    // Adjustments across the last 14 days, newest first.
    final since = dayKey(dayStartMinusDays(DateTime.now(), 14));
    return db.planDao.watchAdjustmentsSince(since);
  },
);

/// The interval quit-weeks estimate (S3) from the last 7 days' average.
final quitEstimateProvider = FutureProvider<({int minWeeks, int maxWeeks})?>(
  (ref) async {
    final db = ref.watch(databaseProvider);
    final profile = await db.profileDao.getSmokingProfile();
    if (profile == null) {
      return null;
    }
    final now = DateTime.now();
    final summaries = await db.statsDao.getSummariesBetween(
      dayKey(dayStartMinusDays(now, 7)),
      dayKey(now),
    );
    final days = summaries.where((s) => s.count > 0).map((s) => s.count).toList();
    if (days.length < 3) {
      return null; // Not enough real data — stay silent (honesty rule).
    }
    return quitWeeksEstimate(
      last7DayAvg: days.reduce((a, b) => a + b) / days.length,
      pace: profile.pace,
    );
  },
);

/// Plan-screen controller: quit-day confirmation (report §14.6).
class PlanScreenController {
  PlanScreenController(this._ref);

  final Ref _ref;

  /// Confirms the quit day: stamps the plan and starts the health timeline.
  Future<void> confirmQuitDay(DateTime day) async {
    final db = _ref.read(databaseProvider);
    await db.planDao.upsertPlan(DailyPlanCompanion.insert(
      date: dayKey(day),
      targetCount: 0,
      phase: PlanPhase.quit,
      tempo: (await db.profileDao.getSmokingProfile())!.pace,
      quitDate: Value(dayKey(day)),
    ));
    await db.timelineDao.setQuitTs(day);
    _ref.invalidate(todayPlanProvider);
    _ref.invalidate(quitEstimateProvider);
  }
}

final planScreenControllerProvider =
    Provider<PlanScreenController>((ref) => PlanScreenController(ref));
