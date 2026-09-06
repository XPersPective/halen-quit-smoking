// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_dao.dart';

// ignore_for_file: type=lint
mixin _$PlanDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyPlanTable get dailyPlan => attachedDatabase.dailyPlan;
  $PlanAdjustmentTable get planAdjustment => attachedDatabase.planAdjustment;
  PlanDaoManager get managers => PlanDaoManager(this);
}

class PlanDaoManager {
  final _$PlanDaoMixin _db;
  PlanDaoManager(this._db);
  $$DailyPlanTableTableManager get dailyPlan =>
      $$DailyPlanTableTableManager(_db.attachedDatabase, _db.dailyPlan);
  $$PlanAdjustmentTableTableManager get planAdjustment =>
      $$PlanAdjustmentTableTableManager(
        _db.attachedDatabase,
        _db.planAdjustment,
      );
}
