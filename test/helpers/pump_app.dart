import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/app.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:riverpod/misc.dart' show Override;

/// Boots the real app with an in-memory database override and returns the
/// database handle so tests can assert on persisted rows. [extraOverrides]
/// land in the SAME scope as the database override — required when the
/// overridden provider is a dependency of another provider (riverpod 3
/// instantiates such providers in the scope where their dependencies live).
Future<AppDatabase> pumpHalenApp(
  WidgetTester tester, {
  AppDatabase? database,
  List<Override> extraOverrides = const [],
}) async {
  final db = database ?? AppDatabase(inMemoryExecutor());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        ...extraOverrides,
      ],
      child: const HalenApp(),
    ),
  );
  return db;
}

/// Gives tests a tall logical surface so the whole BUGÜN column (ring, CTA,
/// strips) is visible without scrolling.
void useLargeTestSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
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

/// Pumps a single widget (not the whole app) inside the app's theme,
/// localizations and a Riverpod scope bound to [db] — used by the module
/// widget tests, which assert on one card at a time.
Future<void> pumpModuleWidget(
  WidgetTester tester, {
  required AppDatabase db,
  required Widget child,
  List<Override> extraOverrides = const [],
  bool scrollable = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        ...extraOverrides,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: HalenTheme.light(),
        home: scrollable
            ? Scaffold(body: SingleChildScrollView(child: child))
            : child,
      ),
    ),
  );
}
