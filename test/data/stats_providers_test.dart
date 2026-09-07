import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/stats_providers.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entities.dart';

import '../helpers/pump_app.dart';

void main() {
  test('daily stats, hourly histogram and savings reflect records',
      () async {
    final db = await seedOnboardedProfile();
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);

    final now = DateTime.now();
    await db.recordDao.insertEvent(
      CigaretteEventCompanion.insert(
        ts: DateTime(now.year, now.month, now.day, 9),
        source: RecordSource.app,
      ),
    );
    await db.recordDao.insertEvent(
      CigaretteEventCompanion.insert(
        ts: DateTime(now.year, now.month, now.day, 21, 30),
        source: RecordSource.widget,
      ),
    );
    // DailySummary rows must exist for the stats to see the day; the
    // repository maintains them in the app, tests write them directly.
    await db.statsDao.upsertSummary(
      DailySummaryCompanion.insert(
        date: '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        count: 2,
      ),
    );

    final daily = await container.read(dailyStatsProvider(7).future);
    expect(daily, hasLength(7));
    expect(daily.last.count, 2);
    expect(daily.take(6).every((d) => d.count == 0), isTrue);

    final hourly = await container.read(hourlyHistogramProvider.future);
    expect(hourly, hasLength(24));
    expect(hourly[9], 1);
    expect(hourly[21], 1);

    // Seed profile has pack price 100 / size 20 → no savings recorded here.
    final total = await container.read(totalSavingsProvider.future);
    expect(total, 0);
  });
}
