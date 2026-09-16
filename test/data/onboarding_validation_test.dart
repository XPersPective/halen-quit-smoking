import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/onboarding_controller.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/data/repositories/profile_repository.dart';

void main() {
  test(
    'invalid onboarding never writes; clearing brand cannot restore old value',
    () async {
      final container = ProviderContainer();
      final db = AppDatabase(inMemoryExecutor());
      addTearDown(container.dispose);
      addTearDown(db.close);
      final controller = container.read(onboardingControllerProvider.notifier);
      expect(container.read(onboardingControllerProvider).baselineCpd, 20);
      expect(container.read(onboardingControllerProvider).pricePerPack, 0);
      final repo = ProfileRepository(db);
      expect(
        () => repo.saveOnboardingAnswers(
          container.read(onboardingControllerProvider),
        ),
        throwsFormatException,
      );
      expect(await db.profileDao.getUserProfile(), isNull);
      controller.setPricePerPack(10);
      controller.setBrandName('Example');
      expect(container.read(onboardingControllerProvider).valid, isTrue);
      controller.setBrandName(null);
      expect(container.read(onboardingControllerProvider).valid, isFalse);
      controller.setBrandName('Example');
      for (final price in [double.nan, double.infinity, -1.0, 0.0, 1000001.0]) {
        controller.setPricePerPack(price);
        expect(
          () => repo.saveOnboardingAnswers(
            container.read(onboardingControllerProvider),
          ),
          throwsFormatException,
        );
      }
      expect(await db.profileDao.getSmokingProfile(), isNull);
    },
  );
}
