import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/repositories/record_repository.dart';
import 'package:halen/domain/entities.dart';

import '../helpers/pump_app.dart';

void main() {
  test('a finished day is priced after midnight, today never is', () async {
    final db = await seedOnboardedProfile(); // baseline 15, 100 per pack of 20
    final repo = RecordRepository(db);
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    // Five cigarettes yesterday, logged during that day: the row was written
    // while the day was still running, i.e. with nothing credited yet.
    for (var i = 0; i < 5; i++) {
      await db.recordDao.insertEvent(
        CigaretteEventCompanion.insert(
          ts: DateTime(yesterday.year, yesterday.month, yesterday.day, 8 + i),
          source: RecordSource.app,
        ),
      );
    }
    await db.statsDao.upsertSummary(
      DailySummaryCompanion.insert(
        date: dayKey(yesterday),
        count: 5,
      ),
    );
    await repo.logCigarette(source: RecordSource.app, at: now);

    await repo.finalizeCompletedDays();

    final y = await db.statsDao.getSummary(dayKey(yesterday));
    expect(y!.avoidedCount, 10); // 15 baseline - 5 smoked
    expect(y.savings, 50); // 10 x 5 per cigarette
    final t = await db.statsDao.getSummary(dayKey(now));
    expect(t!.avoidedCount, 0);
    await db.close();
  });
}
