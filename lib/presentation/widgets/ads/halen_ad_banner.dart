import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../application/entitlement_providers.dart';
import '../../../data/ads_service.dart';
import '../../../domain/ad_policy.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Small labelled banner for free users past the trial
/// (brain T21). Every decision comes from [AdPolicy]; policy refusal, no
/// fill and a failed load all collapse the slot — an empty content hole is
/// never left behind. In preview mode (tests / dev builds) the ad slot is
/// drawn as a labelled placeholder instead of hitting the SDK.
class HalenAdBanner extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(entitlementProvider).value;
    // Unknown entitlement is not "free": no ad until the trial / purchase
    // state is known.
    if (access == null ||
        !AdPolicy.bannerAllowed(
          surface: surface,
          trialActive: access.trialActive,
          premiumOwned: access.storeOwned,
        )) {
      return const SizedBox.shrink();
    }
    return _EligibleBanner(
      key: ValueKey(surface),
      surface: surface,
      previewMode: previewMode,
    );
  }
}

class _EligibleBanner extends StatefulWidget {
  const _EligibleBanner({
    super.key,
    required this.surface,
    required this.previewMode,
  });

  final AdSurface surface;
  final bool previewMode;

  @override
  State<_EligibleBanner> createState() => _EligibleBannerState();
}

class _EligibleBannerState extends State<_EligibleBanner> {
  BannerAd? _banner;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (!widget.previewMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  Future<void> _load() async {
    // UMP consent first: an unconsented load must never happen.
    if (!mounted) return;
    final consentGranted = await HalenAds.instance.consentGranted();
    if (!mounted || !consentGranted) return;
    final banner = HalenAds.instance.createBanner(
      surface: widget.surface,
      trialActive: false,
      premiumOwned: false,
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
    if (!widget.previewMode && (_banner == null || !_loaded)) {
      // No fill / still loading: collapse the slot instead of leaving a
      // blank hole (brain T21).
      return const SizedBox.shrink();
    }
    // One small banner (320x50) pinned above the navigation bar, labelled so
    // it is never mistaken for content.
    final theme = Theme.of(context);
    return Semantics(
      label: l10n.adLabel,
      child: Container(
        width: double.infinity,
        color: theme.colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(l10n.adLabel, style: theme.textTheme.labelSmall),
            ),
            SizedBox(
              height: 50,
              width: 320,
              child: widget.previewMode
                  ? Center(child: Text(l10n.adLabel))
                  : AdWidget(ad: _banner!),
            ),
          ],
        ),
      ),
    );
  }
}
