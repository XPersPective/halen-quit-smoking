import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/data/repositories/profile_repository.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/onboarding.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(inMemoryExecutor());
  });

  tearDown(() async {
    await db.close();
  });

  test('creates the 13-table schema with default settings and timeline rows',
      () async {
    final settings = await db.settingsDao.getSettings();
    expect(settings.id, 1);
    expect(settings.notifLevel, NotificationDensity.standard);
    expect(settings.theme, ThemeOption.system);
    expect(settings.haptics, true);
    expect(settings.trialStartedAt, isNull);

    final timeline = await db.timelineDao.getState();
    expect(timeline.quitTs, isNull);
  });

  test('cigarette events round-trip with enum sources', () async {
    final now = DateTime(2026, 9, 6, 8, 30);
    await db.recordDao.insertEvent(CigaretteEventCompanion.insert(
      ts: now,
      source: RecordSource.widget,
      triggerLabel: const Value(TriggerLabel.coffee),
    ));
    final events = await db.recordDao.getEventsBetween(
      DateTime(2026, 9, 6),
      DateTime(2026, 9, 7),
    );
    expect(events, hasLength(1));
    expect(events.single.source, RecordSource.widget);
    expect(events.single.triggerLabel, TriggerLabel.coffee);
  });

  test('onboarding answers persist into profile and trigger tables', () async {
    final repo = ProfileRepository(db);
    await repo.saveOnboardingAnswers(
      const OnboardingAnswers(
        ageBand: AgeBand.y35to44,
        baselineCpd: 15,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 130,
        packSize: 20,
        triggers: {TriggerLabel.coffee, TriggerLabel.afterMeal},
        targetMode: TargetMode.reduce,
        brandName: 'Example',
      ),
      locale: 'tr',
    );

    expect(await repo.hasOnboarded(), isTrue);
    final profile = await db.profileDao.getSmokingProfile();
    expect(profile!.baselineCpd, 15);
    expect(profile.pace, Pace.standard);
    expect(profile.pricePerPack, 130);

    final user = await db.profileDao.getUserProfile();
    expect(user!.ageBand, AgeBand.y35to44);
    expect(user.locale, 'tr');
  });

  test('pace update writes through', () async {
    final repo = ProfileRepository(db);
    await repo.saveOnboardingAnswers(
      const OnboardingAnswers(
        ageBand: AgeBand.y25to34,
        baselineCpd: 10,
        ttfcBand: TtfcBand.under5,
        pricePerPack: 10,
        packSize: 20,
        triggers: {},
        targetMode: TargetMode.undecided,
        brandName: 'Example',
      ),
    );
    await repo.updatePace(Pace.calm);
    expect((await db.profileDao.getSmokingProfile())!.pace, Pace.calm);
  });

  test('craving resisted counting works', () async {
    final day = DateTime(2026, 9, 6);
    await db.cravingDao.insertCraving(CravingEventCompanion.insert(
      ts: day.add(const Duration(hours: 9)),
      intensity: CravingIntensity.medium,
      outcome: CravingOutcome.resisted,
    ));
    await db.cravingDao.insertCraving(CravingEventCompanion.insert(
      ts: day.add(const Duration(hours: 10)),
      intensity: CravingIntensity.strong,
      outcome: CravingOutcome.smoked,
    ));
    expect(
      await db.cravingDao.countResistedBetween(day, day.add(const Duration(days: 1))),
      1,
    );
  });

  test('store entitlement upsert cannot leave a revoked product owned', () async {
    final now = DateTime(2026, 9, 6, 12);
    final product = 'com.crazypenguin.halenquitsmoking.monthly';
    await db.purchaseDao.upsertEntitlement(
      PurchaseEntitlementCompanion.insert(
        store: 'play',
        productId: product,
        purchaseToken: 'old-token',
        state: 'owned',
        lastVerifiedAt: now,
      ),
    );
    await db.purchaseDao.upsertEntitlement(
      PurchaseEntitlementCompanion.insert(
        store: 'play',
        productId: product,
        purchaseToken: 'new-token',
        state: 'revoked',
        lastVerifiedAt: now.add(const Duration(minutes: 1)),
      ),
    );

    expect(await db.purchaseDao.hasOwnedEntitlement(), isFalse);
    expect(
      (await db.purchaseDao.latest())!.purchaseToken,
      'new-token',
    );
  });
}
