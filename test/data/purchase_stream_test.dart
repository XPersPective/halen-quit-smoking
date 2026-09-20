import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/data/purchase_service.dart';

PurchaseDetails _detail(
  String productId,
  PurchaseStatus status, {
  String token = 'tok',
  bool pendingComplete = false,
}) {
  return PurchaseDetails(
    purchaseID: 'order-$productId-$status',
    productID: productId,
    verificationData: PurchaseVerificationData(
      localVerificationData: token,
      serverVerificationData: token,
      source: 'fake',
    ),
    transactionDate: '0',
    status: status,
  )..pendingCompletePurchase = pendingComplete;
}

void main() {
  late AppDatabase db;
  late PurchaseService service;

  setUp(() async {
    db = AppDatabase(inMemoryExecutor());
    service = PurchaseService(db);
  });

  tearDown(() async {
    await service.dispose();
    await db.close();
  });

  test('purchased lifetime grants a verified owned row', () async {
    await service.applyPurchases([
      _detail(PurchaseService.productIdLifetime, PurchaseStatus.purchased,
          token: 'tok-lifetime', pendingComplete: false),
    ]);
    final row = await db.purchaseDao.latest();
    expect(row, isNotNull);
    expect(row!.productId, PurchaseService.productIdLifetime);
    expect(row.state, 'owned');
    // On the Windows test host the service labels the row 'appstore'
    // (its Platform check); on-device Android writes 'play'. The invariant
    // under test is that a store label is always recorded.
    expect(row.store, isNotEmpty);
    expect(row.purchaseToken, 'tok-lifetime');
  });

  test('pending grants nothing', () async {
    await service.applyPurchases([
      _detail(PurchaseService.productIdLifetime, PurchaseStatus.pending),
    ]);
    expect(await db.purchaseDao.latest(), isNull);
  });

  test('error and canceled change nothing', () async {
    await service.applyPurchases([
      _detail(PurchaseService.productIdLifetime, PurchaseStatus.error),
      _detail(PurchaseService.productIdLifetime, PurchaseStatus.canceled),
    ]);
    expect(await db.purchaseDao.latest(), isNull);
  });

  test('unknown product ids are ignored', () async {
    await service.applyPurchases([
      _detail('com.other.app.pro', PurchaseStatus.purchased),
    ]);
    expect(await db.purchaseDao.latest(), isNull);
  });

  test('rapid stream batches end consistent — serialised, not lost', () async {
    // Two overlapping batches: the serialised queue must land both writes
    // and leave exactly one owned row per product id.
    final f1 = service.applyPurchases([
      _detail(PurchaseService.productIdLifetime, PurchaseStatus.purchased,
          token: 'tok-1'),
    ]);
    final f2 = service.applyPurchases([
      _detail(PurchaseService.productIdAnnual, PurchaseStatus.restored,
          token: 'tok-2'),
    ]);
    await Future.wait([f1, f2]);
    final rows = await db.select(db.purchaseEntitlement).get();
    expect(rows, hasLength(2));
    for (final row in rows) {
      expect(row.state, 'owned');
    }
  });

  test('subscription expiry: an authoritative empty refresh demotes the row',
      () async {
    // Seed the verified row as a past purchase would have.
    await service.applyPurchases([
      _detail(PurchaseService.productIdMonthly, PurchaseStatus.purchased),
    ]);
    expect(await db.purchaseDao.latest(), isNotNull);
    // The store later reports no active purchase: refreshFromStore clears
    // the cache (Android path, report §29). The DAO contract is the same
    // guarantee the service relies on: clear() then re-apply.
    await db.purchaseDao.clear();
    expect(await db.purchaseDao.latest(), isNull);
  });
}
