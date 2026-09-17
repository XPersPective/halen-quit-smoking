import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/secure_key_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<MethodCall> calls;
  String? stored;
  bool failRead = false;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    calls = [];
    stored = null;
    failRead = false;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      expect(call.arguments['options']['resetOnError'], 'false');
      switch (call.method) {
        case 'read':
          if (failRead) throw PlatformException(code: 'key_unavailable');
          return stored;
        case 'write':
          stored = call.arguments['value'] as String;
          return null;
        default:
          fail('Unexpected secure-storage mutation: ${call.method}');
      }
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'fresh install generates once and reuses the persisted 256-bit key',
    () async {
      final store = SecureKeyStore();
      final key = await store.getOrCreateKey(databaseExists: false);
      expect(key, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(await store.getOrCreateKey(databaseExists: true), key);
      expect(calls.map((c) => c.method), ['read', 'write', 'read']);
    },
  );

  for (final missing in <String?>[null, '']) {
    test(
      'existing database with key $missing never writes a replacement',
      () async {
        stored = missing;
        await expectLater(
          SecureKeyStore().getOrCreateKey(databaseExists: true),
          throwsStateError,
        );
        expect(calls.map((c) => c.method), ['read']);
        expect(stored, missing);
      },
    );
  }

  for (final exists in [false, true]) {
    test(
      'read error propagates without mutation (database exists: $exists)',
      () async {
        failRead = true;
        await expectLater(
          SecureKeyStore().getOrCreateKey(databaseExists: exists),
          throwsA(isA<PlatformException>()),
        );
        expect(calls.map((c) => c.method), ['read']);
      },
    );
  }
}
