/// Pure entitlement logic (report §12/§28): the 7-day feature-gated trial
/// starts at first launch without any payment method; store access comes from
/// a store-verified lifetime purchase or active subscription.
library;

class PremiumAccess {
  const PremiumAccess({
    required this.storeOwned,
    required this.trialActive,
    required this.trialDaysLeft,
  });

  /// True when a verified store product currently grants access.
  final bool storeOwned;
  final bool trialActive;
  final int trialDaysLeft;

  /// The feature gate: a store entitlement, or an active trial.
  bool get premium => storeOwned || trialActive;

  /// Where access comes from — drives paywall visibility wording.
  PremiumSource get source => storeOwned
      ? PremiumSource.store
      : (trialActive ? PremiumSource.trial : PremiumSource.free);
}

enum PremiumSource { store, trial, free }

/// Trial window arithmetic.
PremiumAccess evaluateAccess({
  required bool storeVerifiedOwned,
  required DateTime? trialStartedAt,
  required DateTime now,
  int trialDays = 7,
}) {
  if (storeVerifiedOwned) {
    return const PremiumAccess(
      storeOwned: true,
      trialActive: false,
      trialDaysLeft: 0,
    );
  }
  if (trialStartedAt == null) {
    return const PremiumAccess(
      storeOwned: false,
      trialActive: false,
      trialDaysLeft: 0,
    );
  }
  final elapsed = now.difference(trialStartedAt).inDays;
  final daysLeft = (trialDays - elapsed).clamp(0, trialDays);
  return PremiumAccess(
    storeOwned: false,
    trialActive: daysLeft > 0,
    trialDaysLeft: daysLeft,
  );
}
