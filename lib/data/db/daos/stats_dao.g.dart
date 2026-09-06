// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_dao.dart';

// ignore_for_file: type=lint
mixin _$StatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CigaretteEventTable get cigaretteEvent => attachedDatabase.cigaretteEvent;
  $CravingEventTable get cravingEvent => attachedDatabase.cravingEvent;
  $DailySummaryTable get dailySummary => attachedDatabase.dailySummary;
  StatsDaoManager get managers => StatsDaoManager(this);
}

class StatsDaoManager {
  final _$StatsDaoMixin _db;
  StatsDaoManager(this._db);
  $$CigaretteEventTableTableManager get cigaretteEvent =>
      $$CigaretteEventTableTableManager(
        _db.attachedDatabase,
        _db.cigaretteEvent,
      );
  $$CravingEventTableTableManager get cravingEvent =>
      $$CravingEventTableTableManager(_db.attachedDatabase, _db.cravingEvent);
  $$DailySummaryTableTableManager get dailySummary =>
      $$DailySummaryTableTableManager(_db.attachedDatabase, _db.dailySummary);
}
