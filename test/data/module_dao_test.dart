import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/plan_kinds.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('mood reports round-trip with the estimate they were checked against',
      () async {
    final now = DateTime(2026, 9, 8, 14);
    await db.moduleDao.insertMood(
      MoodLogCompanion.insert(ts: now, reportedBand: 2, estimated: 0.8),
    );
    final rows = await db.moduleDao.moodsSince(now.subtract(const Duration(days: 1)));
    expect(rows.single.reportedBand, 2);
    expect(rows.single.estimated, 0.8);
    expect(rows.single.prompted, isFalse);
  });

  test('support completions are idempotent per day and card', () async {
    await db.moduleDao.setSupportDone('2026-09-08', 'walk5');
    await db.moduleDao.setSupportDone('2026-09-08', 'walk5');
    final rows = await db.moduleDao.watchSupportSince('2026-09-01').first;
    expect(rows.length, 1);
    expect(rows.single.done, isTrue);
  });

  test('index snapshots overwrite the same day and read back in order',
      () async {
    await db.moduleDao.putIndexSnapshot(
      date: '2026-09-07',
      progressScore: 40,
      harmLoad: 70,
    );
    await db.moduleDao.putIndexSnapshot(
      date: '2026-09-08',
      progressScore: 44,
      harmLoad: 69,
    );
    await db.moduleDao.putIndexSnapshot(
      date: '2026-09-08',
      progressScore: 46,
      harmLoad: 68,
    );
    final rows = await db.moduleDao.indexSnapshotsSince('2026-09-01');
    expect(rows.map((r) => r.date), ['2026-09-07', '2026-09-08']);
    expect((await db.moduleDao.latestIndexSnapshot())!.progressScore, 46);
  });

  test('plan state is created on demand and switching keeps a history',
      () async {
    final now = DateTime(2026, 9, 8);
    final created = await db.moduleDao.ensurePlanState(now: now);
    expect(created.kind, PlanKind.gradualTaper);
    expect(await db.moduleDao.switchesLast30Days(now), 0);

    await db.moduleDao.switchPlan(kind: PlanKind.dailyQuota, now: now);
    final switched = await db.moduleDao.getPlanState();
    expect(switched!.kind, PlanKind.dailyQuota);
    expect(switched.daysAtStep, 0);
    expect(await db.moduleDao.switchesLast30Days(now), 1);
  });

  test('old plan switches fall out of the 30-day window', () async {
    final past = DateTime(2026, 7, 1);
    final now = DateTime(2026, 9, 8);
    await db.moduleDao.switchPlan(kind: PlanKind.dailyQuota, now: past);
    expect(await db.moduleDao.switchesLast30Days(now), 0);
  });

  test('the savings goal is a single row the user can replace or clear',
      () async {
    await db.moduleDao.setSavingsGoal(label: 'Trip', amount: 1000);
    await db.moduleDao.setSavingsGoal(label: 'Bike', amount: 500);
    final goal = await db.moduleDao.watchSavingsGoal().first;
    expect(goal!.label, 'Bike');
    expect(goal.amount, 500);

    await db.moduleDao.clearSavingsGoal();
    expect(await db.moduleDao.watchSavingsGoal().first, isNull);
  });

  test('craving records can name the technique that was used', () async {
    await db.cravingDao.insertCraving(
      CravingEventCompanion.insert(
        ts: DateTime(2026, 9, 8, 15),
        intensity: CravingIntensity.medium,
        outcome: CravingOutcome.resisted,
        techniqueKey: const Value('walk5'),
      ),
    );
    final rows = await db.cravingDao.watchAll().first;
    expect(rows.single.techniqueKey, 'walk5');
  });
}
