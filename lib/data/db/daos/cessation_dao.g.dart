// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cessation_dao.dart';

// ignore_for_file: type=lint
mixin _$CessationDaoMixin on DatabaseAccessor<AppDatabase> {
  $CessationPlanTableTable get cessationPlanTable =>
      attachedDatabase.cessationPlanTable;
  $CopingPlanTableTable get copingPlanTable => attachedDatabase.copingPlanTable;
  $MoodScreenTable get moodScreen => attachedDatabase.moodScreen;
  CessationDaoManager get managers => CessationDaoManager(this);
}

class CessationDaoManager {
  final _$CessationDaoMixin _db;
  CessationDaoManager(this._db);
  $$CessationPlanTableTableTableManager get cessationPlanTable =>
      $$CessationPlanTableTableTableManager(
        _db.attachedDatabase,
        _db.cessationPlanTable,
      );
  $$CopingPlanTableTableTableManager get copingPlanTable =>
      $$CopingPlanTableTableTableManager(
        _db.attachedDatabase,
        _db.copingPlanTable,
      );
  $$MoodScreenTableTableManager get moodScreen =>
      $$MoodScreenTableTableManager(_db.attachedDatabase, _db.moodScreen);
}
