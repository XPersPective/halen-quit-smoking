import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/trial_start_store.dart';
import 'package:halen/domain/entitlement.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final startedAt = DateTime.utc(2026, 10, 1);
  final reinstallAt = DateTime.utc(2026, 10, 10);
  String? encoded;
  String? failingMethod;
  var writes = 0;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    encoded = null;
    failingMethod = null;
    writes = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.arguments['key'], 'halen.trial.started_at.v1');
      final options = call.arguments['options'] as Map;
      expect(options['accessibility'], 'first_unlock_this_device');
      expect(options['synchronizable'], 'false');
      if (call.method == failingMethod) {
        throw PlatformException(code: 'keychain_unavailable');
      }
      switch (call.method) {
        case 'read':
          return encoded;
        case 'write':
          writes++;
          encoded = call.arguments['value'] as String;
          return null;
        default:
          fail('Unexpected Keychain operation: ${call.method}');
      }
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'first install and reinstall on the same Keychain share a trial',
    () async {
      expect(
        await TrialStartStore().keepEarliest(recorded: null, now: startedAt),
        startedAt,
      );
      final recovered = await TrialStartStore().keepEarliest(
        recorded: null,
        now: reinstallAt,
      );
      expect(recovered, startedAt);
      expect(writes, 1);
      expect(
        evaluateAccess(
          storeVerifiedOwned: false,
          trialStartedAt: recovered,
          now: reinstallAt,
        ).trialActive,
        isFalse,
      );
    },
  );

  test('migration keeps an earlier date from the existing database', () async {
    encoded = reinstallAt.toIso8601String();
    expect(
      await TrialStartStore().keepEarliest(
        recorded: startedAt,
        now: reinstallAt,
      ),
      startedAt,
    );
    expect(encoded, startedAt.toIso8601String());
    expect(writes, 1);
  });

  test('Keychain read failure falls back without overwriting', () async {
    encoded = startedAt.toIso8601String();
    failingMethod = 'read';
    expect(
      await TrialStartStore().keepEarliest(recorded: null, now: reinstallAt),
      isNull,
    );
    expect(
      await TrialStartStore().keepEarliest(
        recorded: startedAt,
        now: reinstallAt,
      ),
      startedAt,
    );
    expect(encoded, startedAt.toIso8601String());
    expect(writes, 0);
  });

  test(
    'Keychain write failure only honors an existing database date',
    () async {
      failingMethod = 'write';
      expect(
        await TrialStartStore().keepEarliest(recorded: null, now: startedAt),
        isNull,
      );
      expect(
        await TrialStartStore().keepEarliest(
          recorded: startedAt,
          now: reinstallAt,
        ),
        startedAt,
      );
      expect(encoded, isNull);
    },
  );
}
