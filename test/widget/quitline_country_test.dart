import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/country_providers.dart';
import 'package:halen/domain/countries.dart';
import 'package:halen/presentation/widgets/quitline_card.dart';

import '../helpers/pump_app.dart';

/// Owner, 2026-10-02: the support card kept showing Türkiye after changing
/// the language. Nothing may be pre-selected; the choice is searchable and
/// is remembered.
/// The app shell keeps a body clock animating, so pumpAndSettle never settles.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('no country is assumed; picking one shows its line and persists',
      (tester) async {
    tester.view.physicalSize = const Size(900, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = await seedOnboardedProfile();

    await pumpModuleWidget(
      tester,
      db: db,
      child: const SingleChildScrollView(child: QuitlineCard()),
      scrollable: false,
      // rootBundle cannot finish under the fake clock; same file, read directly.
      extraOverrides: [
        countryDirectoryProvider.overrideWith(
          (ref) => CountryDirectory.fromJson(
            File('assets/data/countries.json').readAsStringSync(),
          ),
        ),
      ],
    );
    await settle(tester);

    expect(find.text('Choose your country'), findsOneWidget);
    expect(find.textContaining('171'), findsNothing);
    expect(find.textContaining('0800 8 31 31 31'), findsNothing);

    await tester.tap(find.text('Choose your country'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'germ');
    await settle(tester);
    await tester.tap(find.text('Germany'));
    await settle(tester);

    expect(find.textContaining('0800 8 31 31 31'), findsOneWidget);
    expect((await db.settingsDao.getSettings()).countryCode, 'DE');

    // A country with no verified line says so instead of inventing one.
    await tester.tap(find.text('Germany'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'vatican');
    await settle(tester);
    await tester.tap(find.text('Vatican City'));
    await settle(tester);
    expect(find.textContaining('No verified quit line is on file'),
        findsOneWidget);
    expect(find.text('WHO quit line directory'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
