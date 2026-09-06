import 'dart:io';

import 'package:flutter/services.dart';

/// Flags the given directory as excluded from iOS iCloud backups.
///
/// Android needs no runtime call — `dataExtractionRules` handles cloud
/// backup and device-transfer exclusion declaratively.
class BackupExclusion {
  static const _channel = MethodChannel('halen/platform');

  static Future<void> excludeFromBackup(String path) async {
    if (!Platform.isIOS) {
      return;
    }
    try {
      await _channel.invokeMethod<void>('excludeFromBackup', {'path': path});
    } on PlatformException {
      // Never fail the app because a backup flag could not be set; the
      // on-device story is unaffected.
    }
  }
}
