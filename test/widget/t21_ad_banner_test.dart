import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entitlement.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/domain/ad_policy.dart';
import 'package:halen/presentation/widgets/ads/halen_ad_banner.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pump(
    WidgetTester tester, {
    PremiumAccess Function()? access,
  }) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          androidTrialTestOverride,
          if (access != null)
            entitlementProvider.overrideWith((ref) async => access()),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: HalenAdBanner(
              surface: AdSurface.statsBottom,
              previewMode: true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('trial: no banner at all (policy refusal collapses the slot)', (
    tester,
  ) async {
    final now = DateTime.now();
    await db.settingsDao.updateSettings(
      SettingsCompanion(
        trialStartedAt: d.Value(now.subtract(const Duration(hours: 12))),
      ),
    );
    await pump(tester);
    expect(find.text('Ad'), findsNothing, reason: 'trial users see no ads');
    await disposeApp(tester);
  });

  testWidgets('free past trial: labelled placeholder is shown', (tester) async {
    final now = DateTime.now();
    await db.settingsDao.updateSettings(
      SettingsCompanion(
        trialStartedAt: d.Value(now.subtract(const Duration(days: 30))),
      ),
    );
    await pump(tester);
    expect(
      find.text('Ad'),
      findsNWidgets(2), // label row + placeholder
      reason: 'the banner is labelled, never disguised as content',
    );
    await disposeApp(tester);
  });

  testWidgets('the mounted slot follows trial expiry and purchase', (
    tester,
  ) async {
    var access = const PremiumAccess(storeOwned: false, trialActive: true);
    await pump(tester, access: () => access);
    final banner = find.byType(HalenAdBanner);
    final container = ProviderScope.containerOf(tester.element(banner));
    expect(find.text('Ad'), findsNothing);

    access = const PremiumAccess(storeOwned: false, trialActive: false);
    container.invalidate(entitlementProvider);
    await tester.pumpAndSettle();
    expect(find.text('Ad'), findsNWidgets(2));

    access = const PremiumAccess(storeOwned: true, trialActive: false);
    container.invalidate(entitlementProvider);
    await tester.pumpAndSettle();
    expect(find.text('Ad'), findsNothing);
    await disposeApp(tester);
  });
}
