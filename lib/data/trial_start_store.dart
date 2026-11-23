import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Reconciles the trial date with the app's device-only iOS Keychain item.
class TrialStartStore {
  static const _key = 'halen.trial.started_at.v1';
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),
  );

  Future<DateTime?> keepEarliest({
    required DateTime? recorded,
    required DateTime now,
  }) async {
    final candidate = recorded ?? now;
    try {
      final stored = await _storage.read(key: _key);
      if (stored != null) {
        final retained = DateTime.tryParse(stored);
        if (retained == null) return recorded;
        if (!candidate.isBefore(retained)) return retained;
      }
      await _storage.write(
        key: _key,
        value: candidate.toUtc().toIso8601String(),
      );
      return candidate;
    } on PlatformException {
      // An unavailable Keychain may contain a prior trial. Use existing
      // database evidence, or defer opening a new trial until the next launch.
      return recorded;
    }
  }
}
