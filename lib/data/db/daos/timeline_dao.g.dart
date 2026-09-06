// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_dao.dart';

// ignore_for_file: type=lint
mixin _$TimelineDaoMixin on DatabaseAccessor<AppDatabase> {
  $HealthTimelineStateTable get healthTimelineState =>
      attachedDatabase.healthTimelineState;
  TimelineDaoManager get managers => TimelineDaoManager(this);
}

class TimelineDaoManager {
  final _$TimelineDaoMixin _db;
  TimelineDaoManager(this._db);
  $$HealthTimelineStateTableTableManager get healthTimelineState =>
      $$HealthTimelineStateTableTableManager(
        _db.attachedDatabase,
        _db.healthTimelineState,
      );
}
