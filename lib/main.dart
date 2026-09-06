import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/db_opener.dart';
import 'application/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase? database;
  try {
    database = await openHalenDatabase();
  } catch (_) {
    //surfaced by the app as the database-error screen; nothing is sent anywhere.
  }

  runApp(
    ProviderScope(
      overrides: [
        if (database != null) databaseProvider.overrideWithValue(database),
      ],
      child: HalenApp(databaseFailed: database == null),
    ),
  );
}
