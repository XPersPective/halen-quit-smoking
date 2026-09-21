import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../application/entitlement_providers.dart';
import '../../../data/ads_service.dart';
import '../../../domain/ad_policy.dart';
import '../../../domain/entitlement.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Labelled medium-rectangle banner for free users past the trial
/// (brain T21). Every decision comes from [AdPolicy]; policy refusal, no
/// fill and a failed load all collapse the slot — an empty content hole is
/// never left behind. In preview mode (tests / dev builds) the ad slot is
/// drawn as a labelled placeholder instead of hitting the SDK.
class HalenAdBanner extends ConsumerStatefulWidget {
  const HalenAdBanner({
    super.key,
    required this.surface,
    this.previewMode = false,
  });

  final AdSurface surface;

  /// Renders a labelled placeholder instead of a real SDK banner. Used by
  /// tests and desktop/preview builds.
  final bool previewMode;

  @override
  ConsumerState<HalenAdBanner> createState() => _HalenAdBannerState();
}

class _HalenAdBannerState extends ConsumerState<HalenAdBanner> {
  BannerAd? _banner;
  bool _loaded = false;

  bool _allowed(WidgetRef ref) {
    final access = ref.watch(entitlementProvider).value;
    return AdPolicy.bannerAllowed(
      surface: widget.surface,
      trialActive: access?.source == PremiumSource.trial,
      premiumOwned: access?.source == PremiumSource.store,
    );
  }

  @override
  void initState() {
    super.initState();
    if (!widget.previewMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  Future<void> _load() async {
    // UMP consent first: an unconsented load must never happen.
    if (!await HalenAds.instance.consentGranted()) {
      return;
    }
    final access = ref.read(entitlementProvider).value;
    final banner = HalenAds.instance.createBanner(
      surface: widget.surface,
      trialActive: access?.source == PremiumSource.trial,
      premiumOwned: access?.source == PremiumSource.store,
      onLoaded: () {
        if (mounted) {
          setState(() => _loaded = true);
        }
      },
    );
    if (mounted && banner != null) {
      setState(() => _banner = banner);
    }
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (!_allowed(ref)) {
      return const SizedBox.shrink();
    }
    if (!widget.previewMode && (_banner == null || !_loaded)) {
      // No fill / still loading: collapse the slot instead of leaving a
      // blank hole (brain T21).
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.adLabel, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Container(
          height: widget.previewMode ? 120 : 250,
          width: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: widget.previewMode
              ? Center(child: Text(l10n.adLabel))
              : AdWidget(ad: _banner!),
        ),
      ],
    );
  }
}
