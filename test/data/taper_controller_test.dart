import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/taper_controller.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/plan_kinds.dart';
import 'package:halen/domain/soft_taper.dart';

void main() {
  late AppDatabase db;
  late TaperController controller;
  final now = DateTime(2026, 9, 9, 20);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    controller = TaperController(db);
  });
  tearDown(() => db.close());

  /// Seeds [days] days of records spaced [gapMinutes] apart.
  Future<void> seedDays({required int days, required int gapMinutes}) async {
    for (var d = 0; d < days; d++) {
      final dayStart = DateTime(now.year, now.month, now.day - d, 8);
      for (var i = 0; i < 6; i++) {
        await db.recordDao.insertEvent(
          CigaretteEventCompanion.insert(
            ts: dayStart.add(Duration(minutes: gapMinutes * i)),
            source: RecordSource.app,
          ),
        );
      }
    }
  }

  test('a fresh taper seeds from the user own rhythm', () async {
    await seedDays(days: 5, gapMinutes: 90);
    await controller.runDailyStep(now);

    final state = await db.moduleDao.getPlanState();
    // Seeded at ~90 minutes and held, because the step has no history yet.
    expect(state!.intervalMinutes, closeTo(90, 2));
    expect(state.daysAtStep, 1);
  });

  test('the step holds until three days and 70% adherence are in', () async {
    await seedDays(days: 5, gapMinutes: 90);
    await controller.runDailyStep(now);
    final first = (await db.moduleDao.getPlanState())!.intervalMinutes;

    final second = await controller.runDailyStep(
      now.add(const Duration(days: 1)),
    );
    expect(second!.decision, TaperDecision.holdShortStep);
    expect((await db.moduleDao.getPlanState())!.intervalMinutes, first);
  });

  test('it acts once a day and replays its decision without writing',
      () async {
    await seedDays(days: 5, gapMinutes: 90);
    final first = await controller.runDailyStep(now);
    final afterFirst = await db.moduleDao.getPlanState();

    final replay = await controller.runDailyStep(now);
    final afterReplay = await db.moduleDao.getPlanState();

    expect(replay!.decision, first!.decision);
    expect(replay.intervalMinutes, first.intervalMinutes);
    // Nothing moved: a second read on the same day is not a second step.
    expect(afterReplay!.daysAtStep, afterFirst!.daysAtStep);
    expect(afterReplay.intervalMinutes, afterFirst.intervalMinutes);
  });

  test('it advances by at most 15% once the step is earned', () async {
    await seedDays(days: 7, gapMinutes: 120);
    await controller.runDailyStep(now);
    await db.moduleDao.updatePlanState(
      const PlanStateCompanion(daysAtStep: Value(4)),
    );

    // A step is a NEW day's decision, never a second one on the same day.
    final step = await controller.runDailyStep(now.add(const Duration(days: 1)));
    expect(step!.decision, TaperDecision.advance);
    final state = await db.moduleDao.getPlanState();
    expect(state!.intervalMinutes, lessThanOrEqualTo((120 * 1.15).round() + 1));
    expect(state.intervalMinutes, greaterThan(120));
    // Advancing restarts the stabilization window.
    expect(state.daysAtStep, 0);
  });

  test('a soft landing lowers the target without resetting anything',
      () async {
    await seedDays(days: 7, gapMinutes: 60);
    await controller.runDailyStep(now);
    await db.moduleDao.updatePlanState(
      const PlanStateCompanion(intervalMinutes: Value(200)),
    );

    final landed = await controller.applySoftLanding(now);
    expect(landed, lessThan(200));
    expect(landed, greaterThan(0));
    final state = await db.moduleDao.getPlanState();
    expect(state!.intervalMinutes, landed);
    expect(state.daysAtStep, 0);
  });

  test('non-interval plans are left alone', () async {
    await db.moduleDao.switchPlan(kind: PlanKind.dailyQuota, now: now);
    expect(await controller.runDailyStep(now), isNull);
  });

  test('a user with no history still gets a sane starting interval', () async {
    await controller.runDailyStep(now);
    expect((await db.moduleDao.getPlanState())!.intervalMinutes, 60);
  });
}
