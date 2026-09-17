import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db_opener.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const paths = MethodChannel('plugins.flutter.io/path_provider');
  const keys = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late Directory temp;
  String? key;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('halen-open-test-');
    key = null;
    messenger.setMockMethodCallHandler(paths, (_) async => temp.path);
    messenger.setMockMethodCallHandler(keys, (call) async {
      if (call.method == 'read') return key;
      if (call.method == 'write') {
        key = call.arguments['value'] as String;
        return null;
      }
      fail('Unexpected storage operation ${call.method}');
    });
  });

  tearDown(() async {
    messenger.setMockMethodCallHandler(paths, null);
    messenger.setMockMethodCallHandler(keys, null);
    await temp.delete(recursive: true);
  });

  Future<void> expectOpenFailure() async {
    Object? error;
    try {
      final db = await openHalenDatabase();
      await db.close();
    } catch (e) {
      error = e;
    }
    expect(
      error,
      isNotNull,
      reason: 'Opening must fail before returning a database',
    );
  }

  test(
    'fresh SQLCipher database is initialized before return and reopens',
    () async {
      final db = await openHalenDatabase();
      try {
        expect(await db.settingsDao.getSettings(), isNotNull);
      } finally {
        await db.close();
      }
      final originalKey = key;
      final reopened = await openHalenDatabase();
      await reopened.close();
      expect(key, originalKey);
    },
  );

  test(
    'wrong key fails at opening and preserves encrypted file bytes',
    () async {
      final db = await openHalenDatabase();
      await db.customSelect('SELECT count(*) FROM sqlite_master').get();
      await db.close();
      final file = File('${temp.path}/halen/halen.db');
      final before = await file.readAsBytes();
      final correctKey = key;
      key = List.filled(64, '0').join();
      await expectOpenFailure();
      expect(await file.readAsBytes(), before);
      key = correctKey;
      final recovered = await openHalenDatabase();
      await recovered.close();
    },
  );

  test(
    'corrupt database fails at opening without replacing its contents',
    () async {
      final dir = await Directory('${temp.path}/halen').create();
      final file = File('${dir.path}/halen.db');
      final before = List<int>.filled(4096, 42);
      await file.writeAsBytes(before);
      key = List.filled(64, '1').join();
      await expectOpenFailure();
      expect(await file.readAsBytes(), before);
    },
  );
}
