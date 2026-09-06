import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Manages the SQLCipher database key.
///
/// A random 256-bit key is generated on first launch and stored in the
/// platform secure store (Android Keystore-backed / iOS Keychain,
/// ThisDeviceOnly semantics). It never leaves the device.
class SecureKeyStore {
  SecureKeyStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _keyName = 'halen.db.key.v1';

  final FlutterSecureStorage _storage;

  Future<String> getOrCreateKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final random = Random.secure();
    final key = List.generate(32, (_) => random.nextInt(256))
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    await _storage.write(key: _keyName, value: key);
    return key;
  }
}
