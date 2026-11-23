import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

DateTime? localStartForServerClaim({
  required DateTime startedAtUtc,
  required DateTime serverNowUtc,
  required bool serverSaysActive,
  required DateTime localNow,
}) {
  if (!serverSaysActive) return null;
  final remaining = startedAtUtc
      .toUtc()
      .add(const Duration(hours: 24))
      .difference(serverNowUtc.toUtc());
  if (remaining <= Duration.zero || remaining > const Duration(hours: 24)) {
    return null;
  }
  return localNow.subtract(const Duration(hours: 24) - remaining);
}

/// Resolves Android's one-time trial start against Halen's first-party server.
/// Only a one-way, app-scoped hash of Android SSAID leaves the device.
class AndroidTrialStartStore {
  static const _channel = MethodChannel('com.crazypenguin.halen/trial');
  static const _endpoint =
      'https://halen-trial-api.devx8585.workers.dev/v1/trial';
  static const _timeout = Duration(seconds: 5);

  /// User-invoked support code for deletion/access requests. The raw Android
  /// ID is never shown or sent by this helper.
  Future<String?> privacyRequestCode() async {
    try {
      final androidId = await _channel
          .invokeMethod<String>('androidId')
          .timeout(_timeout);
      if (androidId == null || androidId.isEmpty) return null;
      return sha256
          .convert(utf8.encode('halen:android-trial:v1:$androidId'))
          .toString();
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> resolve({
    required DateTime? recorded,
    required bool consented,
  }) async {
    if (!consented) return null;
    final client = HttpClient()..connectionTimeout = _timeout;
    try {
      final androidId = await _channel
          .invokeMethod<String>('androidId')
          .timeout(_timeout);
      if (androidId == null || androidId.isEmpty) return null;

      final deviceHash = sha256
          .convert(utf8.encode('halen:android-trial:v1:$androidId'))
          .toString();
      final request = await client
          .postUrl(Uri.parse(_endpoint))
          .timeout(_timeout);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, ContentType.json.mimeType);
      request.write(
        jsonEncode({
          'deviceHash': deviceHash,
          if (recorded != null)
            'candidateStartedAt': recorded.toUtc().toIso8601String(),
        }),
      );

      final response = await request.close().timeout(_timeout);
      final body = await response
          .transform(utf8.decoder)
          .join()
          .timeout(_timeout);
      if (response.statusCode != HttpStatus.ok) return null;

      final data = jsonDecode(body);
      if (data is! Map<String, dynamic> ||
          data['startedAt'] is! String ||
          data['serverNow'] is! String ||
          data['trialActive'] != true) {
        return null;
      }
      final startedAt = DateTime.tryParse(data['startedAt'] as String)?.toUtc();
      final serverNow = DateTime.tryParse(data['serverNow'] as String)?.toUtc();
      if (startedAt == null || serverNow == null) return null;

      // Use the server's remaining window, not the device wall clock. This
      // also makes an active server-confirmed trial work after a clock rollback.
      return localStartForServerClaim(
        startedAtUtc: startedAt,
        serverNowUtc: serverNow,
        serverSaysActive: true,
        localNow: DateTime.now(),
      );
    } catch (_) {
      // Fail closed for Premium access while offline. Existing records remain
      // available locally; a later launch can recheck the server claim.
      return null;
    } finally {
      client.close(force: true);
    }
  }
}
