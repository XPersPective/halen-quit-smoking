import 'package:drift/drift.dart' hide Column;
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/purchase_service.dart';

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
  Future<List<ProductDetails>> productDetails() async => const [];

  @override
  Future<bool> buy() async => false;

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
}
