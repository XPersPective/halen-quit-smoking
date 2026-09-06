import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';
import '../../../core/dates.dart';
part 'plan_dao.g.dart';

@DriftAccessor(tables: [DailyPlan, PlanAdjustment])
class PlanDao extends DatabaseAccessor<AppDatabase> {
  PlanDao(super.db);

  Stream<DailyPlanRow?> watchPlan(String date) =>
      (select(attachedDatabase.dailyPlan)..where((p) => p.date.equals(date))).watchSingleOrNull();

  Future<DailyPlanRow?> getPlan(String date) =>
      (select(attachedDatabase.dailyPlan)..where((p) => p.date.equals(date))).getSingleOrNull();

  Future<void> upsertPlan(DailyPlanCompanion companion) =>
      into(attachedDatabase.dailyPlan).insert(companion, mode: InsertMode.insertOrReplace);

  Future<List<DailyPlanRow>> getPlansBetween(String startKey, String endKey) {
    return (select(attachedDatabase.dailyPlan)
          ..where((p) => p.date.isBiggerOrEqualValue(startKey))
          ..where((p) => p.date.isSmallerOrEqualValue(endKey))
          ..orderBy([(p) => OrderingTerm.asc(p.date)]))
        .get();
  }

  Future<List<DailyPlanRow>> getPlansFrom(String startKey) {
    return (select(attachedDatabase.dailyPlan)
          ..where((p) => p.date.isBiggerOrEqualValue(startKey))
          ..orderBy([(p) => OrderingTerm.asc(p.date)]))
        .get();
  }

  Future<void> insertAdjustment(PlanAdjustmentCompanion companion) =>
      into(attachedDatabase.planAdjustment).insert(companion);

  Stream<List<PlanAdjustmentRow>> watchAdjustmentsForDay(String date) {
    return (select(attachedDatabase.planAdjustment)
          ..where((a) => a.date.equals(date))
          ..orderBy([(a) => OrderingTerm.desc(a.id)]))
        .watch();
  }

  Future<List<PlanAdjustmentRow>> getAdjustmentsForDay(String date) {
    return (select(attachedDatabase.planAdjustment)
          ..where((a) => a.date.equals(date)))
        .get();
  }

  /// Latest plan row that carries a confirmed quit date (phase quit/after).
  Future<DailyPlanRow?> getQuitPlan() {
    return (select(attachedDatabase.dailyPlan)
          ..where((p) => p.quitDate.isNotNull())
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .getSingleOrNull();
  }

  String dayKeyFor(DateTime d) => dayKey(d);
}
