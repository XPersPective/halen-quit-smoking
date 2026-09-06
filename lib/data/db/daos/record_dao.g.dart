// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_dao.dart';

// ignore_for_file: type=lint
mixin _$RecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $CigaretteEventTable get cigaretteEvent => attachedDatabase.cigaretteEvent;
  RecordDaoManager get managers => RecordDaoManager(this);
}

class RecordDaoManager {
  final _$RecordDaoMixin _db;
  RecordDaoManager(this._db);
  $$CigaretteEventTableTableManager get cigaretteEvent =>
      $$CigaretteEventTableTableManager(
        _db.attachedDatabase,
        _db.cigaretteEvent,
      );
}
