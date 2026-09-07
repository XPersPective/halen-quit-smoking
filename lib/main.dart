import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/db_opener.dart';
import 'application/entitlement_providers.dart';
import 'application/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppDatabase? database;
  try {
    database = await openHalenDatabase();
  } catch (_) {
    //surfaced by the app as the database-error screen; nothing is sent anywhere.
  }

  final overrides = [
    if (database != null) databaseProvider.overrideWithValue(database),
  ];

  // One shared container so the cold-start entitlement refresh (report §29:
  // store verification + trial clock) and the UI read the same state.
  final container = ProviderContainer(overrides: overrides);

  if (database != null) {
    unawaited(
      container.read(entitlementProvider.future).then<void>(
            (_) {},
            onError: (Object _) {},
          ),
    );
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: HalenApp(databaseFailed: database == null),
    ),
  );
}
