import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
part 'timeline_dao.g.dart';

@DriftAccessor(tables: [HealthTimelineState])
class TimelineDao extends DatabaseAccessor<AppDatabase> {
  TimelineDao(super.db);

  Future<TimelineStateRow> getState() async {
    final existing =
        await (select(attachedDatabase.healthTimelineState)).getSingleOrNull();
    if (existing != null) return existing;
    await into(attachedDatabase.healthTimelineState)
        .insert(HealthTimelineStateCompanion.insert(), mode: InsertMode.insertOrIgnore);
    return (select(attachedDatabase.healthTimelineState)).getSingle();
  }

  Stream<TimelineStateRow?> watchState() =>
      select(attachedDatabase.healthTimelineState).watchSingleOrNull();

  Future<void> setQuitTs(DateTime? quitTs) {
    return (update(attachedDatabase.healthTimelineState)..where((t) => t.id.equals(1)))
        .write(HealthTimelineStateCompanion(quitTs: Value(quitTs)));
  }

  Future<void> setAcknowledgedMilestones(String json) {
    return (update(attachedDatabase.healthTimelineState)..where((t) => t.id.equals(1)))
        .write(HealthTimelineStateCompanion(acknowledgedMilestones: Value(json)));
  }
}
