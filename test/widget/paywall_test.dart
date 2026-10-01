import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart' hide Column;
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/purchase_service.dart';
import 'package:halen/presentation/screens/paywall/paywall_screen.dart';

import '../helpers/pump_app.dart';

/// Drives entitlementProvider with a fake purchase service whose store is
/// unavailable (start is a no-op) — the local trial clock and the optional
/// owned row decide the gate.
class FakePurchaseService extends PurchaseService {
  FakePurchaseService(super.db, {required this.owned});

  final bool owned;

  @override
  Future<void> start() async {}

  @override
  Future<List<ProductDetails>> productDetails() async =>
      PurchaseService.fallbackProducts();

  @override
  Future<bool> buy([String? productId]) async => false;

  @override
  Future<void> restore() async {
    if (owned) {
      await db.purchaseDao.upsertEntitlement(
        PurchaseEntitlementCompanion.insert(
          store: 'appstore',
          productId: PurchaseService.productId,
          purchaseToken: 'fake-token',
          state: 'owned',
          lastVerifiedAt: DateTime.now(),
        ),
      );
    }
  }
}

void main() {
  Future<AppDatabase> boot(
    WidgetTester tester, {
    required DateTime? trialStartedAt,
    required bool owned,
  }) async {
    final db = await seedOnboardedProfile();
    await db.settingsDao.updateSettings(
      SettingsCompanion(trialStartedAt: Value(trialStartedAt)),
    );
    if (owned) {
      await db.purchaseDao.upsertEntitlement(
        PurchaseEntitlementCompanion.insert(
          store: 'appstore',
          productId: PurchaseService.productId,
          purchaseToken: 't',
          state: 'owned',
          lastVerifiedAt: DateTime.now(),
        ),
      );
    }
    useLargeTestSurface(tester);
    // The override must live in the SAME scope as the database override:
    // riverpod 3 instantiates entitlementProvider (which depends on the
    // database) in the scope where that dependency is overridden.
    await pumpHalenApp(
      tester,
      database: db,
      extraOverrides: [
        purchaseServiceProvider.overrideWithValue(
          FakePurchaseService(db, owned: owned),
        ),
      ],
    );
    await tester.pumpAndSettle();
    return db;
  }

  testWidgets('active trial keeps the plan engine unlocked', (tester) async {
    final db = await boot(
      tester,
      trialStartedAt: DateTime.now().subtract(const Duration(days: 2)),
      owned: false,
    );

    // Trial active: the plan engine is accessible from the shell.
    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Premium'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('expired trial sees the premium lock', (tester) async {
    final db = await boot(
      tester,
      trialStartedAt: DateTime.now().subtract(const Duration(days: 9)),
      owned: false,
    );

    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    // Locked card + unlock CTA.
    expect(find.textContaining('Premium'), findsWidgets);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('lifetime owner never sees the lock', (tester) async {
    final db = await boot(
      tester,
      trialStartedAt: DateTime.now().subtract(const Duration(days: 30)),
      owned: true,
    );

    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Premium'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('paywall offers only the one-time lifetime unlock',
      (tester) async {
    useLargeTestSurface(tester);
    final db = await seedOnboardedProfile();
    final fakeService = FakePurchaseService(db, owned: false);

    await pumpModuleWidget(
      tester,
      db: db,
      child: const PaywallScreen(),
      locale: const Locale('tr'),
      extraOverrides: [
        purchaseServiceProvider.overrideWithValue(fakeService),
      ],
      scrollable: false,
    );
    await tester.pumpAndSettle();

    // One product, no subscription wording anywhere.
    expect(find.text('Ömür Boyu Erişim'), findsOneWidget);
    expect(find.text(r'$0.99'), findsOneWidget);
    expect(find.textContaining('Abonelik ve otomatik yenileme yoktur'),
        findsOneWidget);
    expect(find.textContaining('Yıllık'), findsNothing);
    expect(find.textContaining('Aylık'), findsNothing);
    expect(find.text('7 günlük Halen Premium denemen'), findsOneWidget);

    await tester.tap(find.text('Ömür Boyu Sahip Ol'));
    await tester.pumpAndSettle();

    // Verify restore button and compliance links exist
    expect(find.byIcon(Icons.restore_rounded), findsWidgets);
    expect(find.text('Kullanım Koşulları (EULA)'), findsOneWidget);
    expect(find.text('Gizlilik Politikası'), findsOneWidget);

    // Tap Terms of Service link -> opens legal dialog
    await tester.tap(find.text('Kullanım Koşulları (EULA)'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'),
      findsOneWidget,
    );
    expect(
      find.textContaining('https://play.google.com/about/play-terms/'),
      findsOneWidget,
    );
    await tester.tap(find.text('Kapat'));
    await tester.pumpAndSettle();

    await disposeApp(tester);
    await db.close();
  });
}
