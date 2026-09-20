import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/entitlement_providers.dart';
import '../../core/routes.dart';
import '../../domain/entitlement.dart';
import '../../l10n/generated/app_localizations.dart';

/// Premium/trial pill next to the settings action on Today (brain T7).
///
/// Tap targets the paywall; the label says what state the user is actually
/// in. Free users are not nagged with fake countdowns: with no active trial
/// and no purchase, the badge summarises the offer instead of counting.
class PremiumBadge extends ConsumerWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final access = ref.watch(entitlementProvider).value;
    final colors = Theme.of(context).colorScheme;

    final (icon, text) = switch (access?.source) {
      PremiumSource.store => (
          Icons.workspace_premium,
          l10n.premiumBadgeOwned,
        ),
      PremiumSource.trial => (
          Icons.schedule_outlined,
          l10n.trialDaysLeft(access!.trialDaysLeft),
        ),
      _ => (
          Icons.workspace_premium_outlined,
          l10n.premiumBadgeFree,
        ),
    };

    return Semantics(
      button: true,
      label: l10n.premiumBadgeTooltip,
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.pushNamed(context, Routes.paywall),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
