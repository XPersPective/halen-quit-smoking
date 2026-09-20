import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/ad_policy.dart';

void main() {
  final now = DateTime(2026, 9, 18, 12);

  group('banner policy', () {
    test('day 0–6 of the trial: never', () {
      expect(
        AdPolicy.bannerAllowed(
          surface: AdSurface.todayBottom,
          trialActive: true,
          premiumOwned: false,
        ),
        isFalse,
      );
    });

    test('premium: never, even past the trial', () {
      expect(
        AdPolicy.bannerAllowed(
          surface: AdSurface.statsBottom,
          trialActive: false,
          premiumOwned: true,
        ),
        isFalse,
      );
    });

    test('free past trial on eligible surfaces: allowed', () {
      for (final surface in AdSurface.values) {
        expect(
          AdPolicy.bannerAllowed(
            surface: surface,
            trialActive: false,
            premiumOwned: false,
          ),
          isTrue,
          reason: '$surface',
        );
      }
    });
  });

  group('app-open policy', () {
    test('trial and premium: never', () {
      expect(
        AdPolicy.appOpenAllowed(
          trialActive: true,
          premiumOwned: false,
          lastShown: null,
          now: now,
        ),
        isFalse,
      );
      expect(
        AdPolicy.appOpenAllowed(
          trialActive: false,
          premiumOwned: true,
          lastShown: null,
          now: now,
        ),
        isFalse,
      );
    });

    test('free: first eligible moment allowed, then blocked for 24 hours', () {
      final first = now;
      expect(
        AdPolicy.appOpenAllowed(
          trialActive: false,
          premiumOwned: false,
          lastShown: null,
          now: first,
        ),
        isTrue,
      );
      expect(
        AdPolicy.appOpenAllowed(
          trialActive: false,
          premiumOwned: false,
          lastShown: first,
          now: first.add(const Duration(hours: 23, minutes: 59)),
        ),
        isFalse,
      );
      expect(
        AdPolicy.appOpenAllowed(
          trialActive: false,
          premiumOwned: false,
          lastShown: first,
          now: first.add(const Duration(hours: 24)),
        ),
        isTrue,
      );
    });
  });
}
