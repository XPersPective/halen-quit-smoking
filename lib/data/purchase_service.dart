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
///  - Android: lifetime in-app product and auto-renewable subscriptions;
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

  /// Store product identifiers.
  static const productIdLifetime = 'com.crazypenguin.halenquitsmoking.lifetime';
  static const productIdAnnual = 'com.crazypenguin.halenquitsmoking.annual';
  static const productIdMonthly = 'com.crazypenguin.halenquitsmoking.monthly';

  /// Legacy alias for single lifetime product
  static const productId = productIdLifetime;

  /// All supported monetization tiers
  static const productIds = {
    productIdAnnual,
    productIdMonthly,
    productIdLifetime,
  };

  /// Store-specific subscription management URLs for user convenience
  static const String manageSubscriptionsUrlApple =
      'https://apps.apple.com/account/subscriptions';
  static const String manageSubscriptionsUrlGoogle =
      'https://play.google.com/store/account/subscriptions';

  static Uri get manageSubscriptionsUri => Uri.parse(
    Platform.isIOS ? manageSubscriptionsUrlApple : manageSubscriptionsUrlGoogle,
  );

  /// Offline/preview fallback products when store billing is unavailable
  static List<ProductDetails> fallbackProducts({String currencySymbol = '₺'}) {
    return [
      ProductDetails(
        id: productIdAnnual,
        title: 'Halen Yıllık',
        description:
            'Yıllık Premium plan; mağaza koşulları ödeme ekranında gösterilir',
        price: '${currencySymbol}399,99/yıl',
        rawPrice: 399.99,
        currencyCode: 'TRY',
        currencySymbol: currencySymbol,
      ),
      ProductDetails(
        id: productIdMonthly,
        title: 'Halen Aylık',
        description: 'Esnek aylık abonelik',
        price: '${currencySymbol}59,99/ay',
        rawPrice: 59.99,
        currencyCode: 'TRY',
        currencySymbol: currencySymbol,
      ),
      ProductDetails(
        id: productIdLifetime,
        title: 'Halen Ömür Boyu',
        description: 'Tek seferlik sınırsız lisans',
        price: '${currencySymbol}799,99',
        rawPrice: 799.99,
        currencyCode: 'TRY',
        currencySymbol: currencySymbol,
      ),
    ];
  }

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
      _purchaseWork = _purchaseWork.then((_) => _onPurchases(purchases));
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
        // active product (including an expired subscription). Preserve the
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

  /// Buys the selected product (non-consumable / auto-renewable subscription).
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
