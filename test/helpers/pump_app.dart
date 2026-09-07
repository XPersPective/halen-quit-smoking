import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/app.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/application/providers.dart';

/// Boots the real app with an in-memory database override and returns the
/// database handle so tests can assert on persisted rows.
Future<AppDatabase> pumpHalenApp(WidgetTester tester, {AppDatabase? database}) async {
  final db = database ?? AppDatabase(inMemoryExecutor());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const HalenApp(),
    ),
  );
  return db;
}

/// Seeds a finished-onboarding adult profile so the splash routes straight to
/// the Today shell.
Future<AppDatabase> seedOnboardedProfile() async {
  final db = AppDatabase(inMemoryExecutor());
  await db.profileDao.saveUserProfile(locale: 'en', ageBand: AgeBand.y25to34);
  await db.profileDao.saveSmokingProfile(SmokingProfileCompanion.insert(
    baselineCpd: 15,
    ttfcBand: TtfcBand.five30,
    pricePerPack: 100,
    targetMode: TargetMode.reduce,
    pace: Pace.standard,
    startedAt: DateTime.now(),
  ));
  return db;
}

/// Unmounts the widget tree BEFORE the database is closed.
///
/// Drift watch subscriptions (Riverpod StreamProviders) must be cancelled and
/// their pending refresh timers flushed before `db.close()` — in the fake
/// async test zone an active subscription deadlocks the close, so every
/// widget test ends with [disposeApp] instead of closing directly.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}
