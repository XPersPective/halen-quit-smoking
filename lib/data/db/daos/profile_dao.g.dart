// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dao.dart';

// ignore_for_file: type=lint
mixin _$ProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfileTable get userProfile => attachedDatabase.userProfile;
  $SmokingProfileTable get smokingProfile => attachedDatabase.smokingProfile;
  ProfileDaoManager get managers => ProfileDaoManager(this);
}

class ProfileDaoManager {
  final _$ProfileDaoMixin _db;
  ProfileDaoManager(this._db);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db.attachedDatabase, _db.userProfile);
  $$SmokingProfileTableTableManager get smokingProfile =>
      $$SmokingProfileTableTableManager(
        _db.attachedDatabase,
        _db.smokingProfile,
      );
}
