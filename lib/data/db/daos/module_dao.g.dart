// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_dao.dart';

// ignore_for_file: type=lint
mixin _$ModuleDaoMixin on DatabaseAccessor<AppDatabase> {
  $MoodLogTable get moodLog => attachedDatabase.moodLog;
  $SupportLogTable get supportLog => attachedDatabase.supportLog;
  $IndexSnapshotTable get indexSnapshot => attachedDatabase.indexSnapshot;
  $PlanStateTable get planState => attachedDatabase.planState;
  $SavingsGoalTableTable get savingsGoalTable =>
      attachedDatabase.savingsGoalTable;
  ModuleDaoManager get managers => ModuleDaoManager(this);
}

class ModuleDaoManager {
  final _$ModuleDaoMixin _db;
  ModuleDaoManager(this._db);
  $$MoodLogTableTableManager get moodLog =>
      $$MoodLogTableTableManager(_db.attachedDatabase, _db.moodLog);
  $$SupportLogTableTableManager get supportLog =>
      $$SupportLogTableTableManager(_db.attachedDatabase, _db.supportLog);
  $$IndexSnapshotTableTableManager get indexSnapshot =>
      $$IndexSnapshotTableTableManager(_db.attachedDatabase, _db.indexSnapshot);
  $$PlanStateTableTableManager get planState =>
      $$PlanStateTableTableManager(_db.attachedDatabase, _db.planState);
  $$SavingsGoalTableTableTableManager get savingsGoalTable =>
      $$SavingsGoalTableTableTableManager(
        _db.attachedDatabase,
        _db.savingsGoalTable,
      );
}
