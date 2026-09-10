import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Opens the SQLCipher-encrypted database.
///
/// **Which SQLite is underneath matters, and it is decided in pubspec.yaml.**
/// `package:sqlite3` 3.x bundles its native library through a Dart build hook
/// selected by a user define; the default is plain SQLite. This project sets
/// `source: sqlcipher`.
///
/// That default is the dangerous part. SQLite silently ignores pragmas it does
/// not recognise, so a plain build accepts `PRAGMA key`, does nothing with it,
/// and hands back a working database — written in **plaintext**, while the app
/// tells the user their data is encrypted. There is no error to notice.
///
/// So [openEncryptedDatabase] asks the database what it is, and refuses to
/// open if the answer is not SQLCipher. A wrong build now fails loudly at
/// launch instead of quietly shipping unencrypted health data.
///
/// The previous setup also carried `sqlcipher_flutter_libs` and
/// `sqlite3_flutter_libs` alongside sqlite3 3.x, which put two separate SQLite
/// implementations in one process — the packages' own changelog says to drop
/// them when upgrading. Both are gone.
QueryExecutor openEncryptedDatabase(File file, String key) {
  return NativeDatabase.createInBackground(
    file,
    setup: (rawDb) {
      // Proof of what is underneath, before anything is written. `PRAGMA
      // cipher_version` returns a row only on a SQLCipher build.
      final version = rawDb.select('PRAGMA cipher_version;');
      final reported =
          version.isEmpty ? '' : '${version.first.values.first ?? ''}';
      if (reported.isEmpty) {
        throw StateError(
          'This build does not include SQLCipher, so the database would be '
          'written in plaintext. Check the sqlite3 build-hook define in '
          'pubspec.yaml (hooks > user_defines > sqlite3 > source: sqlcipher).',
        );
      }

      rawDb.execute("PRAGMA key = '$key'");
      // Harden memory handling for secrets at rest.
      rawDb.execute('PRAGMA cipher_memory_security = ON');
    },
  );
}

/// Kept as a no-op so callers do not have to change.
///
/// This used to run a workaround from `sqlcipher_flutter_libs` for loading the
/// native library on old Android versions. With the build hook there is no
/// separate library to dlopen, so there is nothing to work around.
Future<void> prepareSqlCipher() async {}

/// Plaintext in-memory executor for tests only.
QueryExecutor inMemoryExecutor() => NativeDatabase.memory();
