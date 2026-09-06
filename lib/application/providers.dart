import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/repositories/profile_repository.dart';

/// The single app database instance. `main()` opens it (SQLCipher-encrypted)
/// and overrides this provider; widget tests override it with an in-memory
/// database instead.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider must be overridden with an opened AppDatabase',
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(databaseProvider));
});

/// True once the user finished onboarding — either a full smoking profile
/// or an under-18 user row exists.
final hasOnboardedProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  final profile = await db.profileDao.getSmokingProfile();
  if (profile != null) {
    return true;
  }
  final user = await db.profileDao.getUserProfile();
  return user != null;
});
