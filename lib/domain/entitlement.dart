/// Pure entitlement logic (report §12/§28): the 7-day feature-gated trial
/// starts at first launch without any payment method; lifetime comes from
/// a store-verified one-time purchase.
library;

class PremiumAccess {
  const PremiumAccess({
    required this.lifetimeOwned,
    required this.trialActive,
    required this.trialDaysLeft,
  });

  final bool lifetimeOwned;
  final bool trialActive;
  final int trialDaysLeft;

  /// The feature gate: lifetime, or an active trial.
  bool get premium => lifetimeOwned || trialActive;

  /// Where access comes from — drives paywall visibility wording.
  PremiumSource get source => lifetimeOwned
      ? PremiumSource.lifetime
      : (trialActive ? PremiumSource.trial : PremiumSource.free);
}

enum PremiumSource { lifetime, trial, free }

/// Trial window arithmetic.
PremiumAccess evaluateAccess({
  required bool storeVerifiedOwned,
  required DateTime? trialStartedAt,
  required DateTime now,
  int trialDays = 7,
}) {
  if (storeVerifiedOwned) {
    return const PremiumAccess(
      lifetimeOwned: true,
      trialActive: false,
      trialDaysLeft: 0,
    );
  }
  if (trialStartedAt == null) {
    return const PremiumAccess(
      lifetimeOwned: false,
      trialActive: false,
      trialDaysLeft: 0,
    );
  }
  final elapsed = now.difference(trialStartedAt).inDays;
  final daysLeft = (trialDays - elapsed).clamp(0, trialDays);
  return PremiumAccess(
    lifetimeOwned: false,
    trialActive: daysLeft > 0,
    trialDaysLeft: daysLeft,
  );
}
