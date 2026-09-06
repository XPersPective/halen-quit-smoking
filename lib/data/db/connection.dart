import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

/// Opens the SQLCipher-encrypted database (drift ≥2.32 encryption path).
///
/// The key is a random 256-bit value from [SecureKeyStore]; the database is
/// unusable without it. Wrong/missing key surfaces as a SQLite error on the
/// first statement, which the app maps to the database-error screen.
QueryExecutor openEncryptedDatabase(File file, String key) {
  return NativeDatabase.createInBackground(
    file,
    setup: (rawDb) {
      rawDb.execute("PRAGMA key = '$key'");
      // Harden memory handling for secrets at rest.
      rawDb.execute('PRAGMA cipher_memory_security = ON');
    },
  );
}

/// Platform warm-up required by SQLCipher on older Android versions before
/// the native library can be loaded. Must be awaited before opening.
Future<void> prepareSqlCipher() async {
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
  }
}

/// Plaintext in-memory executor for tests only.
QueryExecutor inMemoryExecutor() => NativeDatabase.memory();
