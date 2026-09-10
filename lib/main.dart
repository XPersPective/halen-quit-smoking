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
  Object? startupError;
  try {
    database = await openHalenDatabase();
  } catch (error, stack) {
    // Kept, not swallowed. The old version discarded the reason, so a device
    // that could not open the store gave the user a blank close and gave a
    // developer nothing at all. Surfaced by StartupFailureScreen; nothing is
    // sent anywhere.
    startupError = error;
    debugPrintStack(stackTrace: stack, label: '$error');
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
      child: HalenApp(startupError: database == null ? startupError : null),
    ),
  );
}
