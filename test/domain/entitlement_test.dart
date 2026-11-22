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
      expect(access.storeOwned, isTrue);
      expect(access.source, PremiumSource.store);
    });

    test('trial is active on first launch', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: trialStart,
        now: trialStart,
      );
      expect(access.source, PremiumSource.trial);
    });

    test('a future start cannot grant trial access', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: trialStart,
        now: trialStart.subtract(const Duration(seconds: 1)),
      );
      expect(access.source, PremiumSource.free);
    });

    test('trial is active one second before the 24-hour deadline', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: trialStart,
        now: trialStart.add(
          const Duration(hours: 23, minutes: 59, seconds: 59),
        ),
      );
      expect(access.premium, isTrue);
      expect(access.source, PremiumSource.trial);
    });

    test('trial expires at exactly 24 hours', () {
      final access = evaluateAccess(
        storeVerifiedOwned: false,
        trialStartedAt: trialStart,
        now: trialStart.add(const Duration(hours: 24)),
      );
      expect(access.premium, isFalse);
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
