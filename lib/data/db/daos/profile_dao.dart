import 'package:drift/drift.dart';

import '../../../domain/entities.dart';
import '../tables.dart';
import '../app_database.dart';
part 'profile_dao.g.dart';

@DriftAccessor(tables: [UserProfile, SmokingProfile])
class ProfileDao extends DatabaseAccessor<AppDatabase> {
  ProfileDao(super.db);

  Future<void> saveUserProfile({
    required String locale,
    required AgeBand ageBand,
  }) async {
    await into(attachedDatabase.userProfile).insert(
      UserProfileCompanion.insert(
        createdAt: DateTime.now(),
        locale: locale,
        ageBand: ageBand,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<UserProfileRow?> getUserProfile() => select(attachedDatabase.userProfile).getSingleOrNull();

  Future<void> saveSmokingProfile(SmokingProfileCompanion companion) async {
    final existing = await getSmokingProfile();
    if (existing == null) {
      await into(attachedDatabase.smokingProfile).insert(
        companion.copyWith(startedAt: Value(DateTime.now())),
      );
    } else {
      await (update(attachedDatabase.smokingProfile)).write(companion);
    }
  }

  Future<SmokingProfileRow?> getSmokingProfile() =>
      select(attachedDatabase.smokingProfile).getSingleOrNull();

  Stream<SmokingProfileRow?> watchSmokingProfile() =>
      select(attachedDatabase.smokingProfile).watchSingleOrNull();

  Stream<UserProfileRow?> watchUserProfile() =>
      select(attachedDatabase.userProfile).watchSingleOrNull();
}
