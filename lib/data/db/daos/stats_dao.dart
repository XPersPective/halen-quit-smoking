import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
import '../../../core/dates.dart';
part 'stats_dao.g.dart';

/// Read-side aggregates plus DailySummary maintenance.
@DriftAccessor(tables: [CigaretteEvent, CravingEvent, DailySummary])
class StatsDao extends DatabaseAccessor<AppDatabase> {
  StatsDao(super.db);

  /// (dateKey, count) per local day in range, day-keyed.
  Future<List<(String, int)>> dailyCounts(
    DateTime startInclusive,
    DateTime endExclusive,
  ) async {
    final events = await select(attachedDatabase.cigaretteEvent).get();
    final buckets = <String, int>{};
    for (final e in events) {
      if (!e.ts.isBefore(startInclusive) && e.ts.isBefore(endExclusive)) {
        final key = dayKey(e.ts);
        buckets[key] = (buckets[key] ?? 0) + 1;
      }
    }
    final keys = buckets.keys.toList()..sort();
    return [for (final k in keys) (k, buckets[k]!)];
  }

  /// Hour-of-day histogram (0..23) over the range.
  Future<List<int>> hourlyHistogram(
    DateTime startInclusive,
    DateTime endExclusive,
  ) async {
    final counts = List.filled(24, 0);
    final events = await (select(attachedDatabase.cigaretteEvent)
          ..where((e) => e.ts.isBiggerOrEqualValue(startInclusive))
          ..where((e) => e.ts.isSmallerThanValue(endExclusive)))
        .get();
    for (final e in events) {
      counts[e.ts.hour] += 1;
    }
    return counts;
  }

  Future<void> upsertSummary(DailySummaryCompanion companion) =>
      into(attachedDatabase.dailySummary).insert(companion, mode: InsertMode.insertOrReplace);

  Stream<List<DailySummaryRow>> watchSummariesBetween(
    String startKey,
    String endKey,
  ) {
    return (select(attachedDatabase.dailySummary)
          ..where((s) => s.date.isBiggerOrEqualValue(startKey))
          ..where((s) => s.date.isSmallerOrEqualValue(endKey))
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .watch();
  }

  Future<List<DailySummaryRow>> getSummariesBetween(
    String startKey,
    String endKey,
  ) {
    return (select(attachedDatabase.dailySummary)
          ..where((s) => s.date.isBiggerOrEqualValue(startKey))
          ..where((s) => s.date.isSmallerOrEqualValue(endKey))
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .get();
  }

  Future<DailySummaryRow?> getSummary(String dateKey) =>
      (select(attachedDatabase.dailySummary)..where((s) => s.date.equals(dateKey)))
          .getSingleOrNull();

  Stream<DailySummaryRow?> watchSummary(String dateKey) =>
      (select(attachedDatabase.dailySummary)..where((s) => s.date.equals(dateKey)))
          .watchSingleOrNull();

  Future<int> totalAvoidedFromSummaries() async {
    final sum = attachedDatabase.dailySummary.avoidedCount.sum();
    final query = selectOnly(attachedDatabase.dailySummary)..addColumns([sum]);
    final row = await query.getSingle();
    return row.read(sum) ?? 0;
  }
}
