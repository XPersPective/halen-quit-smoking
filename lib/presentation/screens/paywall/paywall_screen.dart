import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../application/entitlement_providers.dart';
import '../../../core/design/tokens.dart';
import '../../../data/purchase_service.dart';
import '../../../domain/entitlement.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';

/// Paywall (report §12/§28): shown only after value proof (day-7 gate or
/// adherence/plan switch), never mid-onboarding.
///
/// Features:
///  - 3 Tiers: Annual (7-day trial, best value), Monthly, Lifetime (one-time).
///  - Zero-risk 3-step trial timeline visualizer for subscriptions.
///  - Full App Store & Google Play compliance: auto-renewal disclaimers,
///    EULA / terms, privacy policy modal, and restore purchases button.
///  - 100% on-device local database architecture; no account registration wall.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  String _selectedTier = PurchaseService.productIdAnnual;
  bool _buying = false;
  bool _restoring = false;
  List<ProductDetails> _products = const [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final service = ref.read(purchaseServiceProvider);
    try {
      final list = await service.productDetails();
      if (mounted) {
        setState(() {
          _products =
              list.isNotEmpty ? list : PurchaseService.fallbackProducts();
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _products = PurchaseService.fallbackProducts();
        });
      }
    }
  }

  ProductDetails? _findProduct(String id) {
    return _products.where((p) => p.id == id).firstOrNull;
  }

  Future<void> _handleBuy() async {
    setState(() => _buying = true);
    try {
      await ref.read(purchaseServiceProvider).buy(_selectedTier);
      ref.invalidate(entitlementProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _buying = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _restoring = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(purchaseServiceProvider).restore();
      ref.invalidate(entitlementProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.paywallRestoreSuccess),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.paywallRestoreNone),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _restoring = false);
      }
    }
  }

  void _showLegalDialog({required String title, required String content}) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).closeButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final access = ref.watch(entitlementProvider).value;
    final isOwned = access?.lifetimeOwned ?? false;

    final annualProduct = _findProduct(PurchaseService.productIdAnnual);
    final monthlyProduct = _findProduct(PurchaseService.productIdMonthly);
    final lifetimeProduct = _findProduct(PurchaseService.productIdLifetime);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.paywallTitle),
        actions: [
          IconButton(
            tooltip: l10n.purchaseRestore,
            icon: _restoring
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.restore_rounded),
            onPressed: _restoring ? null : _restorePurchases,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: HalenSpace.x5,
            vertical: HalenSpace.x4,
          ),
          children: [
            // Hero Header
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  size: 36,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x3),
            Text(
              l10n.paywallTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: HalenSpace.x1),
            Text(
              l10n.paywallSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x3),

            // Active trial or expired banner
            if (access != null && access.source == PremiumSource.trial)
              Container(
                margin: const EdgeInsets.only(bottom: HalenSpace.x3),
                padding: const EdgeInsets.symmetric(
                  horizontal: HalenSpace.x3,
                  vertical: HalenSpace.x2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: HalenRadius.smallAll,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: HalenSpace.x2),
                    Flexible(
                      child: Text(
                        l10n.trialDaysLeft(access.trialDaysLeft),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (access != null && !access.trialActive && !isOwned)
              Container(
                margin: const EdgeInsets.only(bottom: HalenSpace.x3),
                padding: const EdgeInsets.symmetric(
                  horizontal: HalenSpace.x3,
                  vertical: HalenSpace.x2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: HalenRadius.smallAll,
                ),
                child: Center(
                  child: Text(
                    l10n.trialExpiredFree,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Feature Checklist Card
            HalenCard(
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
                    l10n.paywallFeaturePrivacy,
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: HalenSpace.x2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: HalenSpace.x2),
                          Expanded(
                            child: Text(
                              feature,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: HalenSpace.x4),

            // Plan Tier Selector Cards
            Text(
              'Abonelik Seçenekleri',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x2),

            // 1. Annual Tier (Best value, 7-day trial)
            _buildTierCard(
              context: context,
              productId: PurchaseService.productIdAnnual,
              badgeText: l10n.planTierAnnualBadge,
              title: l10n.planTierAnnual,
              subtitle: annualProduct != null
                  ? l10n.planTierAnnualSub(annualProduct.price)
                  : '7 gün ücretsiz dene, ardından ₺399,99/yıl',
              priceText: annualProduct?.price ?? '₺399,99/yıl',
              perMonthText: annualProduct != null && annualProduct.rawPrice > 0
                  ? '${annualProduct.currencySymbol}${(annualProduct.rawPrice / 12).toStringAsFixed(2)} / ay'
                  : '~₺33,33 / ay',
              isSelected: _selectedTier == PurchaseService.productIdAnnual,
            ),
            const SizedBox(height: HalenSpace.x2),

            // 2. Monthly Tier (Flexible)
            _buildTierCard(
              context: context,
              productId: PurchaseService.productIdMonthly,
              title: l10n.planTierMonthly,
              subtitle: l10n.planTierMonthlySub,
              priceText: monthlyProduct?.price ?? '₺59,99/ay',
              isSelected: _selectedTier == PurchaseService.productIdMonthly,
            ),
            const SizedBox(height: HalenSpace.x2),

            // 3. Lifetime Tier (One-time purchase)
            _buildTierCard(
              context: context,
              productId: PurchaseService.productIdLifetime,
              badgeText: l10n.planTierLifetimeBadge,
              title: l10n.planTierLifetime,
              subtitle: l10n.planTierLifetimeSub,
              priceText: lifetimeProduct?.price ?? '₺799,99',
              isSelected: _selectedTier == PurchaseService.productIdLifetime,
            ),
            const SizedBox(height: HalenSpace.x4),

            // 3-Step Trial Timeline (shown for Annual Tier)
            if (_selectedTier == PurchaseService.productIdAnnual) ...[
              _buildTrialTimeline(context),
              const SizedBox(height: HalenSpace.x4),
            ],

            // Primary Buy CTA
            if (isOwned)
              Container(
                padding: const EdgeInsets.all(HalenSpace.x4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: HalenRadius.mediumAll,
                ),
                child: Center(
                  child: Text(
                    l10n.purchaseOwned,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else ...[
              FilledButton(
                onPressed: _buying ? null : _handleBuy,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: const RoundedRectangleBorder(
                    borderRadius: HalenRadius.mediumAll,
                  ),
                ),
                child: _buying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _selectedTier == PurchaseService.productIdAnnual
                            ? l10n.paywallCtaTrial
                            : (_selectedTier == PurchaseService.productIdMonthly
                                ? l10n.paywallCtaSubscribe
                                : l10n.paywallCtaLifetime),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              const SizedBox(height: HalenSpace.x2),
              OutlinedButton.icon(
                icon: const Icon(Icons.restore_rounded, size: 18),
                label: Text(l10n.purchaseRestore),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: _restoring ? null : _restorePurchases,
              ),
            ],
            const SizedBox(height: HalenSpace.x4),

            // Store Compliance Legal Disclaimer & Links
            Text(
              l10n.paywallLegalDisclaimer,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
                height: 1.4,
              ),
            ),
            const SizedBox(height: HalenSpace.x2),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: HalenSpace.x1,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => _showLegalDialog(
                    title: l10n.paywallTerms,
                    content:
                        'Apple Standard End User License Agreement (EULA):\n\n'
                        'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/\n\n'
                        'Halen uygulaması kullanıcı gizliliğine ve şeffaf faturalandırmaya tam uyumludur. '
                        'Abonelikleriniz dönem bitiminden en az 24 saat önce iptal edilmediği müddetçe otomatik yenilenir.',
                  ),
                  child: Text(
                    l10n.paywallTerms,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text('·', style: TextStyle(color: Colors.grey)),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => _showLegalDialog(
                    title: l10n.paywallPrivacy,
                    content:
                        '${l10n.settingsPrivacy}\n\n'
                        'Halen, hiçbir kişisel veriyi, sigara içim kayıtlarını veya kriz verilerini harici sunuculara göndermez. '
                        'Tüm veritabanı cihazınızda SQLCipher ile şifreli olarak saklanır.',
                  ),
                  child: Text(
                    l10n.paywallPrivacy,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x4),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required BuildContext context,
    required String productId,
    required String title,
    required String subtitle,
    required String priceText,
    String? badgeText,
    String? perMonthText,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final borderColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.outlineVariant;
    final backgroundColor = isSelected
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
        : theme.colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedTier = productId),
        borderRadius: HalenRadius.mediumAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(HalenSpace.x4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: HalenRadius.mediumAll,
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: HalenSpace.x2,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.only(bottom: HalenSpace.x2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: HalenRadius.smallAll,
                  ),
                  child: Text(
                    badgeText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: HalenSpace.x3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        priceText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (perMonthText != null)
                        Text(
                          perMonthText,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrialTimeline(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: HalenSpace.x2),
              Text(
                'Nasıl Çalışır? (Sıfır Risk)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          _buildTimelineStep(
            context: context,
            icon: Icons.lock_open_rounded,
            title: l10n.paywallTimelineToday,
            description: l10n.paywallTimelineTodayDesc,
            isLast: false,
          ),
          _buildTimelineStep(
            context: context,
            icon: Icons.notifications_none_rounded,
            title: l10n.paywallTimelineReminder,
            description: l10n.paywallTimelineReminderDesc,
            isLast: false,
          ),
          _buildTimelineStep(
            context: context,
            icon: Icons.credit_card_outlined,
            title: l10n.paywallTimelineBilling,
            description: l10n.paywallTimelineBillingDesc,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool isLast,
  }) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: theme.colorScheme.outlineVariant,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: HalenSpace.x3),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : HalenSpace.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
