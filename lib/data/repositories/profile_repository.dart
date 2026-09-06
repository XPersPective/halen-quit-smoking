import 'package:drift/drift.dart';

import '../../domain/entities.dart';
import '../../domain/onboarding.dart';
import '../db/app_database.dart';

/// Persists onboarding answers into UserProfile, SmokingProfile and Trigger.
class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  Future<void> saveOnboardingAnswers(
    OnboardingAnswers answers, {
    String locale = 'en',
  }) {
    return _db.transaction(() async {
      await _db.profileDao.saveUserProfile(
        locale: locale,
        ageBand: answers.ageBand,
      );
      await _db.profileDao.saveSmokingProfile(
        SmokingProfileCompanion(
          baselineCpd: Value(answers.baselineCpd),
          ttfcBand: Value(answers.ttfcBand),
          pricePerPack: Value(answers.pricePerPack),
          packSize: Value(answers.packSize),
          brandId: answers.brandName == null
              ? const Value.absent()
              : const Value('manual'),
          brandName: Value(answers.brandName),
          targetMode: Value(answers.targetMode),
          pace: const Value(Pace.standard),
        ),
      );
      // Seed the trigger table with the user's selection.
      await _db.delete(_db.trigger).go();
      for (final label in answers.triggers) {
        await _db.into(_db.trigger).insert(
              TriggerCompanion.insert(labelKey: label),
            );
      }
    });
  }

  Future<bool> hasOnboarded() async =>
      await _db.profileDao.getSmokingProfile() != null;

  Future<void> updatePace(Pace pace) async {
    await _db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion(pace: Value(pace)),
    );
  }
}
