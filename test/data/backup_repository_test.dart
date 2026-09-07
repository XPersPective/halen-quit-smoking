import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' as d hide Column;
import 'package:halen/data/backup_repository.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/entities.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(inMemoryExecutor());
  });

  tearDown(() async {
    await db.close();
  });

  test('export → import round-trips all user data', () async {
    final source = BackupRepository(db);

    await db.profileDao.saveUserProfile(
        locale: 'en', ageBand: AgeBand.y25to34);
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion.insert(
        baselineCpd: 15,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        targetMode: TargetMode.reduce,
        pace: Pace.standard,
        startedAt: DateTime(2026, 9, 1),
      ),
    );
    await db.recordDao.insertEvent(
      CigaretteEventCompanion.insert(
        ts: DateTime(2026, 9, 7, 9),
        source: RecordSource.widget,
        triggerLabel: const d.Value(TriggerLabel.coffee),
      ),
    );
    await db.cravingDao.insertCraving(
      CravingEventCompanion.insert(
        ts: DateTime(2026, 9, 7, 10),
        intensity: CravingIntensity.strong,
        outcome: CravingOutcome.resisted,
      ),
    );
    await db.statsDao.upsertSummary(
      DailySummaryCompanion.insert(date: '2026-09-07', count: 1),
    );

    final exported = await source.exportToJson();
    expect(exported['format'], 'halen-backup');

    // Import into a fresh database (device-change scenario).
    final target = AppDatabase(inMemoryExecutor());
    final importer = BackupRepository(target);
    final importedEvents = await importer.importFromJson(exported);
    expect(importedEvents, 1);

    final profile = await target.profileDao.getSmokingProfile();
    expect(profile, isNotNull);
    expect(profile!.baselineCpd, 15);
    expect(profile.pace, Pace.standard);

    final events = await target.select(target.cigaretteEvent).get();
    expect(events.single.source, RecordSource.widget);
    expect(events.single.triggerLabel, TriggerLabel.coffee);

    final cravings = await target.select(target.cravingEvent).get();
    expect(cravings.single.outcome, CravingOutcome.resisted);

    final summaries = await target.select(target.dailySummary).get();
    expect(summaries.single.date, '2026-09-07');

    final user = await target.profileDao.getUserProfile();
    expect(user!.ageBand, AgeBand.y25to34);

    await target.close();
  });

  test('import rejects foreign files and newer formats', () async {
    final repo = BackupRepository(db);
    expect(
      () => repo.importFromJson({'format': 'other', 'version': 1}),
      throwsFormatException,
    );
    expect(
      () => repo.importFromJson({'format': 'halen-backup', 'version': 99}),
      throwsFormatException,
    );
  });

  test('wipe removes user rows but keeps defaults', () async {
    await db.profileDao.saveUserProfile(
        locale: 'en', ageBand: AgeBand.y35to44);
    await db.recordDao.insertEvent(
      CigaretteEventCompanion.insert(
        ts: DateTime(2026, 9, 7, 9),
        source: RecordSource.app,
      ),
    );

    final repo = BackupRepository(db);
    await repo.wipeAllUserData();

    expect(await db.profileDao.getUserProfile(), isNull);
    expect(await db.select(db.cigaretteEvent).get(), isEmpty);
    // Settings default row survives (schema defaults).
    final settings = await db.settingsDao.getSettings();
    expect(settings.id, 1);
  });
}
