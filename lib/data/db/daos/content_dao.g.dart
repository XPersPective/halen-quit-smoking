// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_dao.dart';

// ignore_for_file: type=lint
mixin _$ContentDaoMixin on DatabaseAccessor<AppDatabase> {
  $MotivationContentTable get motivationContent =>
      attachedDatabase.motivationContent;
  ContentDaoManager get managers => ContentDaoManager(this);
}

class ContentDaoManager {
  final _$ContentDaoMixin _db;
  ContentDaoManager(this._db);
  $$MotivationContentTableTableManager get motivationContent =>
      $$MotivationContentTableTableManager(
        _db.attachedDatabase,
        _db.motivationContent,
      );
}
