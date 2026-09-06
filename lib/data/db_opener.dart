import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'db/app_database.dart';
import 'db/connection.dart';
import 'backup_exclusion.dart';
import 'secure_key_store.dart';

/// Opens the on-device encrypted database.
///
/// The database lives in the application-support directory under `halen/`,
/// a folder excluded from every OS backup surface:
///  - Android: `dataExtractionRules` excludes cloud backup and device
///    transfer for this folder (android/app/src/main/res/xml/).
///  - iOS: the folder is flagged `isExcludedFromBackup` right after creation
///    (Runner/AppDelegate.swift platform channel).
Future<AppDatabase> openHalenDatabase() async {
  await prepareSqlCipher();
  final support = await getApplicationSupportDirectory();
  final dir = Directory('${support.path}/halen');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }
  final dbFile = File('${dir.path}/halen.db');
  await BackupExclusion.excludeFromBackup(dir.path);

  final key = await SecureKeyStore().getOrCreateKey();
  final executor = openEncryptedDatabase(dbFile, key);
  return AppDatabase(executor);
}
