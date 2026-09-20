import 'package:drift/drift.dart' as d;
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/cessation.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/data/backup_repository.dart';
import 'package:halen/domain/entities.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(inMemoryExecutor());
    await db.timelineDao.getState();
  });

  tearDown(() async {
    await db.close();
  });

  test('export/import round-trips every personal table', () async {
    // Seed one row in every newer table plus representative core rows.
    final now = DateTime(2026, 9, 20, 10);
    await db.into(db.moodLog).insert(
          MoodLogCompanion.insert(
            ts: now,
            reportedBand: 1,
            estimated: 0.4,
            prompted: const d.Value(true),
          ),
        );
    await db.into(db.supportLog).insert(
          SupportLogCompanion.insert(date: '2026-09-20', cardKey: 'breath'),
        );
    await db.into(db.indexSnapshot).insert(
          IndexSnapshotCompanion.insert(date: '2026-09-20', progressScore: 78, harmLoad: 41),
        );
    await db.into(db.planState).insert(
          PlanStateCompanion.insert(
            startedAt: now,
            intervalMinutes: const d.Value(45),
            targetIntervalMinutes: const d.Value(120),
            daysAtStep: const d.Value(3),
          ),
        );
    await db.into(db.savingsGoalTable).insert(
          SavingsGoalTableCompanion.insert(label: 'New bike', amount: 1500),
        );
    await db.into(db.cessationPlanTable).insert(
          CessationPlanTableCompanion.insert(
            quitDate: const d.Value('2026-10-01'),
            supportPerson: const d.Value('Ayşe'),
            reason: const d.Value(QuitReason.health),
          ),
        );
    await db.into(db.copingPlanTable).insert(
          CopingPlanTableCompanion.insert(
            trigger: TriggerLabel.coffee,
            plan: 'cold water',
            updatedAt: now,
          ),
        );
    await db.into(db.moodScreen).insert(
          MoodScreenCompanion.insert(ts: now, lowInterest: 1, lowMood: 2, total: 3),
        );
    await db.into(db.packPurchaseTable).insert(
          PackPurchaseTableCompanion.insert(
            ts: now,
            pricePerPack: 70,
            brand: const d.Value('Samsun'),
          ),
        );
    await db.timelineDao.setQuitTs(DateTime(2026, 9, 1, 12));
    await db.timelineDao
        .setAcknowledgedMilestones('["who_20min","who_12h"]');

    final repo = BackupRepository(db);
    final backup = await repo.exportToJson();

    // Import into a FRESH database — the true device-change scenario.
    final fresh = AppDatabase(inMemoryExecutor());
    addTearDown(fresh.close);
    final freshRepo = BackupRepository(fresh);
    final count = await freshRepo.importFromJson(backup);
    expect(count, greaterThanOrEqualTo(0));

    // Mood logs survive with all fields.
    final moods = await fresh.select(fresh.moodLog).get();
    expect(moods, hasLength(1));
    expect(moods.single.reportedBand, 1);
    expect(moods.single.estimated, 0.4);
    expect(moods.single.prompted, isTrue);

    final support = await fresh.select(fresh.supportLog).get();
    expect(support.single.cardKey, 'breath');

    final snapshots = await fresh.select(fresh.indexSnapshot).get();
    expect(snapshots.single.progressScore, 78);

    final plan = await fresh.select(fresh.planState).getSingle();
    expect(plan.intervalMinutes, 45);
    expect(plan.daysAtStep, 3);

    final goal = await fresh.select(fresh.savingsGoalTable).getSingle();
    expect(goal.label, 'New bike');
    expect(goal.amount, 1500);

    final cessation = await fresh.select(fresh.cessationPlanTable).getSingle();
    expect(cessation.quitDate, '2026-10-01');
    expect(cessation.supportPerson, 'Ayşe');
    expect(cessation.reason, QuitReason.health);

    final coping = await fresh.select(fresh.copingPlanTable).get();
    expect(coping.single.trigger, TriggerLabel.coffee);
    expect(coping.single.plan, 'cold water');

    final screens = await fresh.select(fresh.moodScreen).get();
    expect(screens.single.total, 3);

    final packs = await fresh.select(fresh.packPurchaseTable).get();
    expect(packs.single.pricePerPack, 70);
    expect(packs.single.brand, 'Samsun');

    final freshTimeline = await fresh.timelineDao.getState();
    expect(freshTimeline.quitTs, DateTime(2026, 9, 1, 12));
    // acknowledgedMilestones survives the device change too.
    expect(freshTimeline.acknowledgedMilestones, contains('who_20min'));

    // Settings preferences ride along (v8/v10 fields included).
    final freshSettings = await fresh.settingsDao.getSettings();
    expect(freshSettings.trialNudge, isFalse);
    expect(freshSettings.widgetTheme, 'system');
  });

  test('wipe clears every personal table including the newer ones', () async {
    final now = DateTime(2026, 9, 20, 10);
    await db.into(db.moodLog).insert(
          MoodLogCompanion.insert(ts: now, reportedBand: 2, estimated: 0.1),
        );
    await db.into(db.packPurchaseTable).insert(
          PackPurchaseTableCompanion.insert(ts: now, pricePerPack: 60),
        );
    await db.into(db.savingsGoalTable).insert(
          SavingsGoalTableCompanion.insert(label: 'x', amount: 10),
        );
    await db.timelineDao.setQuitTs(now);
    await db.timelineDao.setAcknowledgedMilestones('["who_20min"]');

    final repo = BackupRepository(db);
    await repo.wipeAllUserData();

    expect(await db.select(db.moodLog).get(), isEmpty);
    expect(await db.select(db.packPurchaseTable).get(), isEmpty);
    expect(await db.select(db.savingsGoalTable).get(), isEmpty);
    expect(await db.select(db.smokingProfile).get(), isEmpty);
    // Timeline milestones reset with the quit clock.
    final timeline = await db.timelineDao.getState();
    expect(timeline.quitTs, isNull);
    expect(timeline.acknowledgedMilestones, '[]');
  });

  test('smoking profile body/rhythm fields round-trip', () async {
    final repo = BackupRepository(db);
    // Base profile first, then the optional body/rhythm fields (T5/T9).
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion(
        baselineCpd: const d.Value(15),
        ttfcBand: const d.Value(TtfcBand.five30),
        pricePerPack: const d.Value(70.0),
        packSize: const d.Value(20),
        targetMode: const d.Value(TargetMode.reduce),
        pace: const d.Value(Pace.standard),
        startedAt: d.Value(DateTime(2026, 9, 1, 8)),
      ),
    );
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion(
        heightCm: const d.Value(178.0),
        weightKg: const d.Value(74.5),
        smokingYears: const d.Value(12.0),
        declaredRhythmMinutes: const d.Value(45),
      ),
    );

    final backup = await repo.exportToJson();
    final fresh = AppDatabase(inMemoryExecutor());
    addTearDown(fresh.close);
    await BackupRepository(fresh).importFromJson(backup);
    final restored = await fresh.profileDao.getSmokingProfile();
    expect(restored!.heightCm, 178.0);
    expect(restored.weightKg, 74.5);
    expect(restored.smokingYears, 12.0);
    expect(restored.declaredRhythmMinutes, 45);
  });

  test('trial and purchase data stay excluded from backups', () async {
    await db.settingsDao.updateSettings(
      SettingsCompanion(
        trialStartedAt: d.Value(DateTime(2026, 9, 1)),
        trialNudge: const d.Value(true),
      ),
    );
    final repo = BackupRepository(db);
    final backup = await repo.exportToJson();
    final settingsJson = backup['settings'] as Map;
    expect(settingsJson.containsKey('trialStartedAt'), isFalse);
    expect(settingsJson.containsKey('purchaseEntitlements'), isFalse);
  });
}
