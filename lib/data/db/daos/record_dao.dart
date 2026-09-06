import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
part 'record_dao.g.dart';

@DriftAccessor(tables: [CigaretteEvent])
class RecordDao extends DatabaseAccessor<AppDatabase> {
  RecordDao(super.db);

  Stream<List<CigaretteEventRow>> watchEventsBetween(
    DateTime startInclusive,
    DateTime endExclusive,
  ) {
    return (select(attachedDatabase.cigaretteEvent)
          ..where((e) => e.ts.isBiggerOrEqualValue(startInclusive))
          ..where((e) => e.ts.isSmallerThanValue(endExclusive))
          ..orderBy([(e) => OrderingTerm.asc(e.ts)]))
        .watch();
  }

  Future<List<CigaretteEventRow>> getEventsBetween(
    DateTime startInclusive,
    DateTime endExclusive,
  ) {
    return (select(attachedDatabase.cigaretteEvent)
          ..where((e) => e.ts.isBiggerOrEqualValue(startInclusive))
          ..where((e) => e.ts.isSmallerThanValue(endExclusive))
          ..orderBy([(e) => OrderingTerm.asc(e.ts)]))
        .get();
  }

  Future<int> insertEvent(CigaretteEventCompanion companion) =>
      into(attachedDatabase.cigaretteEvent).insert(companion);

  Future<int> deleteEvent(int id) =>
      (delete(attachedDatabase.cigaretteEvent)..where((e) => e.id.equals(id))).go();

  Future<int> countBetween(DateTime start, DateTime end) async {
    final table = attachedDatabase.cigaretteEvent;
    final countExp = table.id.count();
    final query = selectOnly(table)
      ..addColumns([countExp])
      ..where(table.ts.isBiggerOrEqualValue(start) &
          table.ts.isSmallerThanValue(end));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<DateTime?> lastTsBefore(DateTime end) async {
    final query = select(attachedDatabase.cigaretteEvent)
      ..where((e) => e.ts.isSmallerThanValue(end))
      ..orderBy([(e) => OrderingTerm.desc(e.ts)])
      ..limit(1);
    final rows = await query.get();
    return rows.isEmpty ? null : rows.first.ts;
  }
}
