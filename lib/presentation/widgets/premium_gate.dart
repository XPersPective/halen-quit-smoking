import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/entitlement_providers.dart';
import '../../core/design/tokens.dart';
import '../../core/routes.dart';
import '../../l10n/generated/app_localizations.dart';
import 'design/halen_components.dart';

/// Whether premium-only content may show.
///
/// While the entitlement is still being read this is `true`: a paying user
/// must never see a lock flash on a cold start. Content is not secret, only
/// a paid convenience; the store is the source of truth for ads and billing.
final premiumUnlockedProvider = Provider<bool>((ref) {
  return ref.watch(entitlementProvider).value?.premium ?? true;
});

/// The Premium promises, one place. The paywall list, the store listing and
/// the gating matrix test all read this, so a promise cannot exist without a
/// gate behind it (owner audit 2026-10-02: only the Plan screen was locked
/// while the paywall promised five more things).
enum PremiumFeature {
  adaptivePlan,
  fullCharts,
  triggerPatterns,
  fullTimeline,
  fullSosToolkit,
  widgetCustomisation,
  noAds,
}

/// Shows [child] when Premium (or the 7-day trial) is active, otherwise a
/// calm locked card that links to the paywall. Never used for crisis support.
class PremiumGate extends ConsumerWidget {
  const PremiumGate({
    super.key,
    required this.feature,
    required this.child,
    this.compact = false,
    this.screen = false,
  });

  final PremiumFeature feature;
  final Widget child;

  /// A single-line lock for inline use (tabs, settings rows).
  final bool compact;

  /// The gate fills a whole screen body: the lock is padded and centred.
  final bool screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(premiumUnlockedProvider)) {
      return child;
    }
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final card = HalenCard(
      onTap: () => Navigator.of(context).pushNamed(Routes.paywall),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: HalenSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  compact
                      ? l10n.commonUnlockPremium
                      : l10n.commonPremiumLocked,
                  style: theme.textTheme.bodyMedium,
                ),
                if (!compact) ...[
                  const SizedBox(height: HalenSpace.x2),
                  Text(
                    l10n.commonUnlockPremium,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
    if (!screen) {
      return card;
    }
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(HalenSpace.x5),
          child: card,
        ),
      ),
    );
  }
}
