import 'dart:async';
import 'dart:io' show Platform;

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_policy.dart';

/// Thin, honest integration layer for the ad SDK (brain T21).
///
/// All policy decisions live in [AdPolicy]; this class only talks to the
/// SDK. Everything is a no-op off mobile platforms and safe to call in
/// tests. Shipped with Google's official TEST ad unit IDs — the real IDs
/// arrive with the publisher account and are swapped in one place.
///
/// google_mobile_ads 9.x ships banner/interstitial/rewarded but no
/// app-open format; the policy supports app-open, its format decision is
/// tracked in .project-brain (PB-21).
class HalenAds {
  HalenAds._();

  static final HalenAds instance = HalenAds._();

  bool _initialized = false;
  Future<void>? _initWork;
  DateTime? lastAppOpenShown;

  /// Google's published TEST app id / unit ids — never real inventory.
  /// Release uses the publisher's real ids from the AdMob account.
  static const testAppIdAndroid =
      'ca-app-pub-3940256099942544~3347511713';
  static const testAppIdIos = 'ca-app-pub-3940256099942544~1458002511';
  static const testBannerUnitAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const testBannerUnitIos = 'ca-app-pub-3940256099942544/2934735716';
  static const testAppOpenUnitAndroid =
      'ca-app-pub-3940256099942544/3419835294';
  static const testAppOpenUnitIos = 'ca-app-pub-3940256099942544/5662855259';

  static bool get platformSupported =>
      Platform.isAndroid || Platform.isIOS;

  /// Initializes the SDK once, on mobile only. Never throws: ads must not
  /// break the app (brain §2).
  Future<void> ensureInitialized() async {
    if (!platformSupported || _initialized) {
      return;
    }
    _initWork ??= _initGuarded();
    await _initWork;
  }

  Future<void> _initGuarded() async {
    try {
      await MobileAds.instance.initialize();
    } catch (_) {
      // SDK init failure must never surface to the user.
    } finally {
      _initialized = true;
    }
  }

  /// UMP consent: asks Google when the user may be in a regulated region.
  /// Errors resolve to "ads not shown" — consent is never faked.
  Future<bool> consentGranted() async {
    if (!platformSupported) {
      return false;
    }
    try {
      await ensureInitialized();
      final info = ConsentInformation.instance;
      final done = Completer<bool>();
      info.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
            done.complete(await info.canRequestAds());
          } catch (_) {
            done.complete(false);
          }
        },
        (formError) => done.complete(false),
      );
      return await done.future;
    } catch (_) {
      return false;
    }
  }

  /// Creates a labelled medium-rectangle banner for [surface], or null when
  /// the policy says no. Caller owns dispose() and the label row.
  BannerAd? createBanner({
    required AdSurface surface,
    required bool trialActive,
    required bool premiumOwned,
    required void Function() onLoaded,
  }) {
    if (!platformSupported) {
      return null;
    }
    if (!AdPolicy.bannerAllowed(
      surface: surface,
      trialActive: trialActive,
      premiumOwned: premiumOwned,
    )) {
      return null;
    }
    final unit = Platform.isIOS ? testBannerUnitIos : testBannerUnitAndroid;
    final ad = BannerAd(
      adUnitId: unit,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    )..load();
    return ad;
  }

  /// App-open ads are not shipped by google_mobile_ads 9.x; the policy cap
  /// ([AdPolicy.appOpenAllowed], 1/24h) is implemented and tested, the
  /// format needs a native or third-party solution — tracked in brain.

  bool appOpenAllowedNow({required bool trialActive,
      required bool premiumOwned}) {
    return AdPolicy.appOpenAllowed(
      trialActive: trialActive,
      premiumOwned: premiumOwned,
      lastShown: lastAppOpenShown,
      now: DateTime.now(),
    );
  }
}
