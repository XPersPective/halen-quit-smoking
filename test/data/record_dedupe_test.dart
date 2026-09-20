import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/data/repositories/record_repository.dart';
import 'package:halen/domain/entities.dart';

void main() {
  late AppDatabase db;
  late RecordRepository repo;

  setUp(() {
    db = AppDatabase(inMemoryExecutor());
    repo = RecordRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('double tap inside the feedback window records one cigarette', () async {
    final now = DateTime.now();
    final a = await repo.logCigarette(source: RecordSource.app, at: now);
    final b = await repo.logCigarette(source: RecordSource.app, at: now);
    expect(b, a);
    expect(await db.recordDao.watchAll().first, hasLength(1));
  });

  test('a genuinely later log is a new record, never swallowed', () async {
    final now = DateTime.now();
    await repo.logCigarette(source: RecordSource.app, at: now);
    final later = now.add(const Duration(seconds: 5));
    final b = await repo.logCigarette(source: RecordSource.app, at: later);
    final events = await db.recordDao.watchAll().first;
    expect(events, hasLength(2));
    expect(events.map((e) => e.id), containsAll([1, 2]));
    expect(b, 2);
  });

  test('craving logs dedupe inside the same window', () async {
    final now = DateTime.now();
    await repo.logCraving(outcome: CravingOutcome.resisted, at: now);
    await repo.logCraving(outcome: CravingOutcome.resisted, at: now);
    expect(await db.cravingDao.watchAll().first, hasLength(1));
    await repo.logCraving(
      outcome: CravingOutcome.resisted,
      at: now.add(const Duration(seconds: 5)),
    );
    expect(await db.cravingDao.watchAll().first, hasLength(2));
  });

  test('backdated widget writes that collide with now still dedupe', () async {
    final now = DateTime.now();
    // A quick-log may arrive millisecond-late either side of now.
    await repo.logCigarette(source: RecordSource.app, at: now);
    await repo.logCigarette(
      source: RecordSource.widget,
      at: now.add(const Duration(milliseconds: 400)),
    );
    expect(await db.recordDao.watchAll().first, hasLength(1));
  });
}
