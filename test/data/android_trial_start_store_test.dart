import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/android_trial_start_store.dart';

void main() {
  test('server remaining time survives a local clock rollback', () {
    final localNow = DateTime.utc(2026, 11, 23, 8);
    final localStart = localStartForServerClaim(
      startedAtUtc: DateTime.utc(2026, 11, 23, 9),
      serverNowUtc: DateTime.utc(2026, 11, 23, 10),
      serverSaysActive: true,
      localNow: localNow,
    );

    // The phone clock is an hour behind the real start. The server still
    // grants the correct remaining 23 hours, without trusting local time.
    expect(localStart, localNow.subtract(const Duration(hours: 1)));
  });

  test('server expiry denies a trial even when the phone clock is behind', () {
    final localStart = localStartForServerClaim(
      startedAtUtc: DateTime.utc(2026, 11, 22, 9),
      serverNowUtc: DateTime.utc(2026, 11, 23, 10),
      serverSaysActive: false,
      localNow: DateTime.utc(2026, 11, 22, 10),
    );

    expect(localStart, isNull);
  });

  test('rejects inconsistent active claims outside the 24-hour window', () {
    final localStart = localStartForServerClaim(
      startedAtUtc: DateTime.utc(2026, 11, 22, 9),
      serverNowUtc: DateTime.utc(2026, 11, 23, 10),
      serverSaysActive: true,
      localNow: DateTime.utc(2026, 11, 23, 10),
    );

    expect(localStart, isNull);
  });
}
