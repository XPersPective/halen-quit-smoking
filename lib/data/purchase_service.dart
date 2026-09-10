import 'dart:async';
import 'dart:io' show Platform;

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'db/app_database.dart';

/// Store-managed lifetime entitlement (report §29).
///
/// Platform contracts implemented here:
///  - iOS: non-consumable "Halen Lifetime"; ownership is re-verified from
///    the store on every cold start; revocation arrives via the purchase
///    stream and demotes the local row;
///  - Android: one-time in-app product; purchases are acknowledged
///    immediately (Play auto-refunds unacknowledged purchases after 3
///    days); pending purchases grant nothing until purchased;
///  - the UI NEVER trusts a local boolean: the DB row records
///    store/product/token/state/lastVerifiedAt and is refreshed from the
///    store, so reinstall/redevice restores and refunds demote correctly.
class PurchaseService {
  PurchaseService(this.db, {InAppPurchase? iap}) : _injectedIap = iap;

  final AppDatabase db;

  final InAppPurchase? _injectedIap;
  InAppPurchase? _resolvedIap;

  /// The store handle, resolved on first use rather than in the constructor.
  ///
  /// `InAppPurchase.instance` builds a platform billing client the moment it
  /// is touched, and the constructor runs as soon as the provider is read —
  /// which meant the billing client was being constructed on every launch
  /// before [start] had a chance to decide there is no store here, and
  /// before the paywall was anywhere near the screen. Resolving it lazily
  /// keeps that cost, and that platform channel, inside the code paths that
  /// genuinely need a store.
  InAppPurchase get _iap =>
      _resolvedIap ??= _injectedIap ?? InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Both stores use the same product id suffix; the App Store / Play
  /// Console products must be created with this id
  /// (`com.halenquitsmoking.app.lifetime`).
  static const productId = 'com.halenquitsmoking.app.lifetime';

  bool _started = false;

  /// Wires the purchase stream and refreshes the entitlement from the
  /// store. Must be awaited on every cold start (report §29). Mobile only —
  /// the dev/preview Windows build has no store.
  Future<void> start() async {
    if (_started) {
      return;
    }
    _started = true;
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    final available = await _iap.isAvailable();
    if (!available) {
      return;
    }
    _subscription = _iap.purchaseStream.listen(
      _onPurchases,
      onDone: () => _subscription?.cancel(),
    );
    await refreshFromStore();
  }

  /// Store-side ownership check. Android is silent (queryPurchasesAsync);
  /// iOS needs an explicit restore — called from the Restore button and on
  /// cold start only when a stale verified row exists.
  Future<void> refreshFromStore() async {
    final query = await _iap.queryProductDetails({productId});
    if (query.notFoundIDs.contains(productId) && query.productDetails.isEmpty) {
      // Store not configured (e.g. local dev) — keep current state.
      return;
    }
    // Android: silent ownership query (queryPurchasesAsync path).
    if (Platform.isAndroid) {
      final addition =
          _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition?>();
      if (addition != null) {
        final response = await addition.queryPastPurchases();
        await _onPurchases(response.pastPurchases);
        return;
      }
    }
    // iOS: SK2 Transaction.currentEntitlements surfaces through the
    // purchase stream on start; a stale local row forces a sync.
    final row = await db.purchaseDao.latest();
    final stale = row == null ||
        DateTime.now().difference(row.lastVerifiedAt) >
            const Duration(hours: 24);
    if (stale && row != null) {
      await _iap.restorePurchases();
    } else if (row == null) {
      // No local state yet — nothing owned as far as we know.
      return;
    }
  }

  /// Localized product info (price etc. resolved from the store console).
  Future<List<ProductDetails>> productDetails() async {
    final query = await _iap.queryProductDetails({productId});
    return query.productDetails;
  }

  /// Buys the lifetime unlock (non-consumable).
  Future<bool> buy() async {
    final query = await _iap.queryProductDetails({productId});
    final product = query.productDetails.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw StateError('Lifetime product not available'),
    );
    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Restore button (paywall + settings, report §29: mandatory-practical).
  Future<void> restore() => _iap.restorePurchases();

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != productId) {
        continue;
      }
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Pending never grants access; purchased/restored does.
          await db.purchaseDao.upsertEntitlement(
            PurchaseEntitlementCompanion.insert(
              store: Platform.isAndroid ? 'play' : 'appstore',
              productId: productId,
              purchaseToken: purchase.verificationData.localVerificationData,
              state: 'owned',
              lastVerifiedAt: DateTime.now(),
            ),
          );
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        case PurchaseStatus.pending:
          // No entitlement until it completes (report §29).
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          // Refund/revocation demotes the entitlement.
          await _demote();
      }
    }
  }

  Future<void> _demote() async {
    final row = await db.purchaseDao.latest();
    if (row != null) {
      await db.purchaseDao.upsertEntitlement(
        PurchaseEntitlementCompanion.insert(
          store: row.store,
          productId: row.productId,
          purchaseToken: row.purchaseToken,
          state: 'revoked',
          lastVerifiedAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
