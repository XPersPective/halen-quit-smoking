/// Pure entitlement logic (report §12/§28): the 24-hour feature-gated trial
/// starts at first launch without any payment method; store access comes from
/// a store-verified one-time lifetime purchase.
library;

class PremiumAccess {
  const PremiumAccess({required this.storeOwned, required this.trialActive});

  /// True when a verified store product currently grants access.
  final bool storeOwned;
  final bool trialActive;

  /// The feature gate: a store entitlement, or an active trial.
  bool get premium => storeOwned || trialActive;

  /// Where access comes from — drives paywall visibility wording.
  PremiumSource get source => storeOwned
      ? PremiumSource.store
      : (trialActive ? PremiumSource.trial : PremiumSource.free);
}

enum PremiumSource { store, trial, free }

const trialDuration = Duration(hours: 24);

/// Trial window arithmetic.
PremiumAccess evaluateAccess({
  required bool storeVerifiedOwned,
  required DateTime? trialStartedAt,
  required DateTime now,
}) {
  if (storeVerifiedOwned) {
    return const PremiumAccess(storeOwned: true, trialActive: false);
  }
  if (trialStartedAt == null || now.isBefore(trialStartedAt)) {
    return const PremiumAccess(storeOwned: false, trialActive: false);
  }
  final active = now.isBefore(trialStartedAt.add(trialDuration));
  return PremiumAccess(storeOwned: false, trialActive: active);
}
