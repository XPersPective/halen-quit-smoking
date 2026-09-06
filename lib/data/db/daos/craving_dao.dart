import 'package:drift/drift.dart';

import '../app_database.dart';
import '../../../domain/entities.dart';
import '../tables.dart';
part 'craving_dao.g.dart';

@DriftAccessor(tables: [CravingEvent])
class CravingDao extends DatabaseAccessor<AppDatabase> {
  CravingDao(super.db);

  Future<int> insertCraving(CravingEventCompanion companion) =>
      into(attachedDatabase.cravingEvent).insert(companion);

  Stream<List<CravingEventRow>> watchCravingsBetween(
    DateTime startInclusive,
    DateTime endExclusive,
  ) {
    return (select(attachedDatabase.cravingEvent)
          ..where((c) => c.ts.isBiggerOrEqualValue(startInclusive))
          ..where((c) => c.ts.isSmallerThanValue(endExclusive))
          ..orderBy([(c) => OrderingTerm.desc(c.ts)]))
        .watch();
  }

  Future<List<CravingEventRow>> getCravingsBetween(
    DateTime startInclusive,
    DateTime endExclusive,
  ) {
    return (select(attachedDatabase.cravingEvent)
          ..where((c) => c.ts.isBiggerOrEqualValue(startInclusive))
          ..where((c) => c.ts.isSmallerThanValue(endExclusive)))
        .get();
  }

  Future<int> countResistedBetween(DateTime start, DateTime end) async {
    final table = attachedDatabase.cravingEvent;
    final countExp = table.id.count();
    final query = selectOnly(table)
      ..addColumns([countExp])
      ..where(table.ts.isBiggerOrEqualValue(start) &
          table.ts.isSmallerThanValue(end) &
          table.outcome.equalsValue(CravingOutcome.resisted));
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }
}
