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
    if (!answers.valid) {
      throw const FormatException('Invalid onboarding answers');
    }
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
          brandName: Value(answers.brandName!.trim()),
            targetMode: Value(answers.targetMode),
            pace: const Value(Pace.standard),
            declaredRhythmMinutes: Value(answers.rhythmMinutes),
        ),
      );
      // Seed the trigger table with the user's selection.
      await _db.delete(_db.trigger).go();
      for (final label in answers.triggers) {
        await _db
            .into(_db.trigger)
            .insert(TriggerCompanion.insert(labelKey: label));
      }
    });
  }

  Future<bool> hasOnboarded() async =>
      await _db.profileDao.getSmokingProfile() != null;

  /// Under-18 selection (report §39): user row only — no plan is created.
  Future<void> saveUnder18Profile({String locale = 'en'}) {
    return _db.profileDao.saveUserProfile(
      locale: locale,
      ageBand: AgeBand.under18,
    );
  }

  Future<void> updatePace(Pace pace) async {
    await _db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion(pace: Value(pace)),
    );
  }
}
