import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/data/purchase_service.dart';
import 'package:halen/domain/entitlement.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

/// Paywall (report §12/§28): shown only after value proof (day-7 gate or
/// the adherence screen), never mid-onboarding. Copy is "one-time ·
/// lifetime · no subscription"; the price comes from the store console —
/// never hard-coded in the app.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _buying = false;
  String? _priceLine;

  @override
  void initState() {
    super.initState();
    _loadPrice();
  }

  Future<void> _loadPrice() async {
    // Resolves the localized store price; nothing is hard-coded (report §12).
    final service = ref.read(purchaseServiceProvider);
    try {
      final query = await service.productDetails();
      final product = query.where((p) => p.id == PurchaseService.productId).firstOrNull;
      if (product != null && mounted) {
        setState(() => _priceLine = product.price);
      }
    } catch (_) {
      // Store unreachable — the buy button simply stays disabled.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final access = ref.watch(entitlementProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paywallTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (access != null && access.source == PremiumSource.trial)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(l10n.trialDaysLeft(access.trialDaysLeft)),
              ),
            if (access != null && !access.trialActive && !access.lifetimeOwned)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(l10n.trialExpiredFree),
              ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final feature in [
                      l10n.paywallFeaturePlan,
                      l10n.paywallFeatureCharts,
                      l10n.paywallFeatureTriggers,
                      l10n.paywallFeatureTimeline,
                      l10n.paywallFeatureSos,
                      l10n.paywallFeatureWidget,
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.check, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(feature)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Store price line (dynamic) + the one-time promise.
            Text(
              _priceLine ?? '…',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.purchaseCopy,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (access?.lifetimeOwned ?? false)
              Center(child: Text(l10n.purchaseOwned))
            else ...[
              FilledButton(
                onPressed: _buying || _priceLine == null
                    ? null
                    : () async {
                        setState(() => _buying = true);
                        try {
                          await ref.read(purchaseServiceProvider).buy();
                        } finally {
                          if (mounted) {
                            setState(() => _buying = false);
                          }
                        }
                      },
                child: Text(l10n.purchaseCta),
              ),
              const SizedBox(height: 8),
              // Restore is mandatory-practical on both stores (report §29).
              OutlinedButton(
                onPressed: () =>
                    ref.read(purchaseServiceProvider).restore(),
                child: Text(l10n.purchaseRestore),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.paywallTrialNote,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
