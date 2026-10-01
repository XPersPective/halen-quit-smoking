import 'dart:async';
import 'dart:io' show Platform;

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'db/app_database.dart';

/// Store-managed entitlement (report §29).
///
/// Platform contracts implemented here:
///  - iOS: non-consumable "Halen Lifetime"; ownership is re-verified from
///    the store on every cold start; revocation arrives via the purchase
///    stream and demotes the local row;
///  - Android: one lifetime in-app product (no subscriptions — owner
///    decision 2026-10-01: buy once, use forever);
///    purchases are acknowledged immediately (Play auto-refunds
///    unacknowledged purchases after 3 days); pending purchases grant nothing;
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
  Future<void> _purchaseWork = Future<void>.value();
  bool _iosRestoreActive = false;
  final List<PurchaseEntitlementCompanion> _iosRestoreRows = [];

  /// The only store product: a one-time, non-consumable lifetime unlock.
  static const productIdLifetime = 'com.crazypenguin.halenquitsmoking.lifetime';

  /// Legacy alias for single lifetime product
  static const productId = productIdLifetime;

  static const productIds = {productIdLifetime};

  /// Offline/preview fallback product when store billing is unavailable
  /// (desktop previews only — mobile never shows an invented price).
  static List<ProductDetails> fallbackProducts() => [
    ProductDetails(
      id: productIdLifetime,
      title: 'Halen Lifetime',
      description: 'One-time purchase, yours forever',
      price: r'$0.99',
      rawPrice: 0.99,
      currencyCode: 'USD',
      currencySymbol: r'$',
    ),
  ];

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
    _subscription = _iap.purchaseStream.listen((purchases) {
      // Stream callbacks are not awaited by Stream.listen. Serialising the
      // writes makes restore() safe to await before reading entitlement.
      applyPurchases(purchases);
    }, onDone: () => _subscription?.cancel());
    await refreshFromStore();
  }

  /// Store-side ownership check. Android is silent (queryPurchasesAsync);
  /// iOS needs an explicit restore — called from the Restore button and on
  /// cold start only when a stale verified row exists.
  Future<void> refreshFromStore({bool forceIosRestore = false}) async {
    // Product metadata and ownership are separate store calls. A product
    // catalog miss must not prevent Android from checking an already-owned
    // product, so ownership refresh continues even when metadata is absent.
    try {
      await _iap.queryProductDetails(productIds);
    } catch (_) {
      // Keep the last verified cache when metadata is temporarily unavailable.
    }
    // Android: silent ownership query (queryPurchasesAsync path).
    if (Platform.isAndroid) {
      final addition = _iap
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition?>();
      if (addition != null) {
        final response = await addition.queryPastPurchases();
        // A successful response is authoritative: an empty list means no
        // owned product (e.g. refunded). Preserve the
        // last verified cache only when the store query itself failed.
        if (response.error == null) {
          await db.purchaseDao.clear();
        }
        await _onPurchases(response.pastPurchases);
        return;
      }
    }
    // iOS: restore is idempotent and also covers a reinstall with no local
    // row. The listener is already attached above, so current entitlements
    // are written before the caller reads the local entitlement.
    final row = await db.purchaseDao.latest();
    final stale =
        row == null ||
        DateTime.now().difference(row.lastVerifiedAt) >
            const Duration(hours: 24);
    if (forceIosRestore || stale) {
      _iosRestoreActive = true;
      _iosRestoreRows.clear();
      try {
        await _iap.restorePurchases();
        await _purchaseWork;
        // A successful iOS restore is authoritative, including an empty
        // result. Replace the cache so refunds/revocations cannot leave a
        // stale local entitlement behind.
        await db.purchaseDao.replaceEntitlements(_iosRestoreRows);
      } finally {
        _iosRestoreActive = false;
        _iosRestoreRows.clear();
      }
    }
  }

  /// Localized product info (price etc. resolved from the store console).
  /// Desktop/preview builds use placeholders; mobile builds never show a
  /// fabricated price when the store cannot be queried.
  Future<List<ProductDetails>> productDetails() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return fallbackProducts();
    }
    try {
      return (await _iap.queryProductDetails(productIds)).productDetails;
    } catch (_) {
      // Network or store failure — the paywall must not invent a price.
    }
    return const [];
  }

  /// Buys the lifetime unlock (non-consumable).
  /// Defaults to [productIdLifetime] if unspecified.
  Future<bool> buy([String? productId]) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw StateError('Store purchases are available on iOS and Android only');
    }
    final effectiveId = productId ?? productIdLifetime;
    // Never pass [fallbackProducts] to the billing API: those values are only
    // for desktop previews and are not backed by a store product.
    final products = await productDetails();
    final product = products.firstWhere(
      (p) => p.id == effectiveId,
      orElse: () => throw StateError(
        'Product $effectiveId is unavailable in the current store region',
      ),
    );
    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Restore button (paywall top bar + bottom, report §29: mandatory-practical).
  Future<void> restore() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    await refreshFromStore(forceIosRestore: Platform.isIOS);
  }

  /// Queues a batch of purchase updates onto the serialised write queue —
  /// the same path the stream uses (visible for tests, brain T20: the
  /// store-stream contract is unit-testable without a billing client).
  Future<void> applyPurchases(List<PurchaseDetails> purchases) {
    _purchaseWork = _purchaseWork.then((_) => _onPurchases(purchases));
    return _purchaseWork;
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!productIds.contains(purchase.productID)) {
        continue;
      }
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Pending never grants access; purchased/restored does.
          final row = PurchaseEntitlementCompanion.insert(
            store: Platform.isAndroid ? 'play' : 'appstore',
            productId: purchase.productID,
            purchaseToken: purchase.verificationData.localVerificationData,
            state: 'owned',
            lastVerifiedAt: DateTime.now(),
          );
          if (_iosRestoreActive && Platform.isIOS) {
            _iosRestoreRows.add(row);
          } else {
            await db.purchaseDao.upsertEntitlement(row);
          }
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
        case PurchaseStatus.pending:
          // No entitlement until it completes (report §29).
          break;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          // A failed or cancelled new transaction is not a refund/revocation
          // of an already-owned product. Store ownership refresh handles
          // actual loss of entitlement.
          break;
      }
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
