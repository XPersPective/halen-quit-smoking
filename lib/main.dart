import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/db/app_database.dart';
import 'data/db_opener.dart';
import 'application/entitlement_providers.dart';
import 'application/providers.dart';
import 'application/quick_log_controller.dart';

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
    // Register the iOS interactive-widget callback (no-op elsewhere).
    unawaited(
      container.read(widgetServiceProvider).init().catchError((Object _) {}),
    );
    // Drain quick logs queued by widget/tile/notification while closed.
    unawaited(
      QuickLogController(database)
          .drain()
          .then<void>((_) {}, onError: (Object _) {}),
    );
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: HalenApp(databaseFailed: database == null),
    ),
  );
}
