/// Ad eligibility and frequency policy (brain T21, §2 contract).
///
/// Pure policy: no SDK, no platform channels — the integration layer asks
/// this class and this class alone decides. Rules, in order:
///  - the first 7 days (trial), an active premium, SOS, payment, health
///    detail, onboarding and the widget NEVER show ads;
///  - after the trial, free users on eligible surfaces see a labelled
///    medium banner;
///  - app-open ads: eligible moments only, at most once per 24 hours;
///  - no network / no fill must never leave an empty content hole: callers
///    render the ordinary card flow when this policy says "no".
library;

/// Screens where an ad surface may exist for a free user past the trial.
enum AdSurface { todayBottom, statsBottom, guideBottom }

class AdPolicy {
  const AdPolicy._();

  /// A banner on [surface] is allowed only for a free user whose trial has
  /// ended. The SOS screen and health detail are not surfaces at all, so
  /// they are absent from [AdSurface].
  static bool bannerAllowed({
    required AdSurface surface,
    required bool trialActive,
    required bool premiumOwned,
  }) {
    if (premiumOwned || trialActive) {
      return false;
    }
    return true;
  }

  /// App-open ads: an eligible moment is one where a banner would be
  /// allowed, and at most one is shown per 24 hours. `lastShown` null means
  /// never shown.
  static bool appOpenAllowed({
    required bool trialActive,
    required bool premiumOwned,
    required DateTime? lastShown,
    required DateTime now,
  }) {
    if (premiumOwned || trialActive) {
      return false;
    }
    if (lastShown == null) {
      return true;
    }
    return now.difference(lastShown) >= const Duration(hours: 24);
  }
}
