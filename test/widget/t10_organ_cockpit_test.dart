import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/today/mini_organ_cockpit.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  Widget host({required void Function(RouteSettings) onRoute}) {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          onRoute(settings);
          return MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              body: SizedBox(
                height: 700,
                child: SingleChildScrollView(child: const MiniOrganCockpit()),
              ),
            ),
            settings: settings,
          );
        },
        home: Scaffold(
          body: SizedBox(
            height: 700,
            child: SingleChildScrollView(child: const MiniOrganCockpit()),
          ),
        ),
      ),
    );
  }

  testWidgets('cockpit shows the 4 spotlight organs with accessible names', (
    tester,
  ) async {
    await tester.pumpWidget(host(onRoute: (_) {}));
    await tester.pumpAndSettle();
    for (final name in const ['Lungs', 'Heart', 'Brain', 'Blood vessels']) {
      final card = find.ancestor(
        of: find.text(name),
        matching: find.byType(InkWell),
      );
      expect(
        card,
        findsWidgets,
        reason: 'each organ card is one tappable, named unit',
      );
    }
    await disposeApp(tester);
  });

  for (final (w, h, name) in [
    (320.0, 900.0, 'narrow'),
    (420.0, 900.0, 'wide'),
    (900.0, 420.0, 'landscape'),
  ]) {
    testWidgets('cockpit fits $name (${w.round()}×${h.round()})', (
      tester,
    ) async {
      tester.view.physicalSize = Size(w, h);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(onRoute: (_) {}));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await disposeApp(tester);
    });
  }

  testWidgets('tapping an organ opens the body map on that organ', (
    tester,
  ) async {
    RouteSettings? pushed;
    final args = <String>{};
    await tester.pumpWidget(
      host(
        onRoute: (settings) {
          pushed = settings;
          final arg = settings.arguments;
          if (arg is String) args.add(arg);
        },
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Heart'));
    await tester.pumpAndSettle();
    expect(pushed?.name, Routes.body);
    expect(args, contains('heart'));
    await disposeApp(tester);
  });
}
