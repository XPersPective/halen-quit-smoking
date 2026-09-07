import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/entitlement.dart';

void main() {
  final trialStart = DateTime(2026, 9, 1);

  group('evaluateAccess', () {
    test('store-verified lifetime wins regardless of trial', () {
      final access = evaluateAccess(
        storeVerifiedOwned: true,
        trialStartedAt: trialStart,
        now: trialStart.add(const Duration(days: 30)),
      );
      expect(access.premium, isTrue);
      expect(access.lifetimeOwned, isTrue);
      expect(access.source, PremiumSource.lifetime);
    });

    test('trial is active within 7 days of first launch', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: trialStart,
        now: trialStart.add(const Duration(days: 5)),
      );
      expect(access.premium, isTrue);
      expect(access.trialDaysLeft, 2);
      expect(access.source, PremiumSource.trial);
    });

    test('trial expires after 7 days — free tier stays functional', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: trialStart,
        now: trialStart.add(const Duration(days: 7)),
      );
      expect(access.premium, isFalse);
      expect(access.trialDaysLeft, 0);
      expect(access.source, PremiumSource.free);
    });

    test('no trial start recorded means free', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: null,
        now: trialStart,
      );
      expect(access.premium, isFalse);
    });
  });
}
