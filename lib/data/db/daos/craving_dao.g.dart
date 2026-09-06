// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'craving_dao.dart';

// ignore_for_file: type=lint
mixin _$CravingDaoMixin on DatabaseAccessor<AppDatabase> {
  $CravingEventTable get cravingEvent => attachedDatabase.cravingEvent;
  CravingDaoManager get managers => CravingDaoManager(this);
}

class CravingDaoManager {
  final _$CravingDaoMixin _db;
  CravingDaoManager(this._db);
  $$CravingEventTableTableManager get cravingEvent =>
      $$CravingEventTableTableManager(_db.attachedDatabase, _db.cravingEvent);
}
