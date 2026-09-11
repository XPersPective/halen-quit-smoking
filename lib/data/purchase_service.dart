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

  /// Store product identifiers.
  static const productIdLifetime = 'com.halenquitsmoking.app.lifetime';
  static const productIdAnnual = 'com.halenquitsmoking.app.annual';
  static const productIdMonthly = 'com.halenquitsmoking.app.monthly';

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
        Platform.isIOS
            ? manageSubscriptionsUrlApple
            : manageSubscriptionsUrlGoogle,
      );

  /// Offline/preview fallback products when store billing is unavailable
  static List<ProductDetails> fallbackProducts({String currencySymbol = '₺'}) {
    return [
      ProductDetails(
        id: productIdAnnual,
        title: 'Halen Yıllık',
        description: '7 gün ücretsiz deneme, ardından yıllık abonelik',
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
    final query = await _iap.queryProductDetails(productIds);
    if (query.notFoundIDs.toSet().containsAll(productIds) &&
        query.productDetails.isEmpty) {
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
  /// Falls back to default placeholder pricing if store is unreachable.
  Future<List<ProductDetails>> productDetails() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return fallbackProducts();
    }
    try {
      final query = await _iap.queryProductDetails(productIds);
      if (query.productDetails.isNotEmpty) {
        return query.productDetails;
      }
    } catch (_) {
      // Network or store failure — fall through to fallbacks
    }
    return fallbackProducts();
  }

  /// Buys the selected product (non-consumable / auto-renewable subscription).
  /// Defaults to [productIdLifetime] if unspecified.
  Future<bool> buy([String? productId]) async {
    final effectiveId = productId ?? productIdLifetime;
    final products = await productDetails();
    final product = products.firstWhere(
      (p) => p.id == effectiveId,
      orElse: () => throw StateError('Product $effectiveId not available'),
    );
    final param = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Restore button (paywall + settings, report §29: mandatory-practical).
  Future<void> restore() => _iap.restorePurchases();

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!productIds.contains(purchase.productID)) {
        continue;
      }
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // Pending never grants access; purchased/restored does.
          await db.purchaseDao.upsertEntitlement(
            PurchaseEntitlementCompanion.insert(
              store: Platform.isAndroid ? 'play' : 'appstore',
              productId: purchase.productID,
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
          await _demote(purchase.productID);
      }
    }
  }

  Future<void> _demote([String? pid]) async {
    final row = await db.purchaseDao.latest();
    if (row != null) {
      await db.purchaseDao.upsertEntitlement(
        PurchaseEntitlementCompanion.insert(
          store: row.store,
          productId: pid ?? row.productId,
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
