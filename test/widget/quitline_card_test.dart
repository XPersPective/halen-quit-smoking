import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/country_providers.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/countries.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/quitline_card.dart';

import '../helpers/design_font.dart';
import '../helpers/pump_app.dart';

void main() {
  setUpAll(loadDesignFonts);

  Future<AppDatabase> showCard(
    WidgetTester tester,
    Locale device,
    String language, {
    String? country,
    double textScale = 1,
    Brightness brightness = Brightness.light,
  }) async {
    tester.platformDispatcher.localeTestValue = device;
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    final db = await seedOnboardedProfile();
    await db.settingsDao.updateSettings(
      SettingsCompanion(countryCode: Value(country)),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          countryDirectoryProvider.overrideWith(
            (ref) => CountryDirectory.fromJson(
              File('assets/data/countries.json').readAsStringSync(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(brightness: brightness, fontFamily: 'Inter'),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: const Scaffold(
            body: SingleChildScrollView(child: QuitlineCard()),
          ),
        ),
      ),
    );
    await tester.pump();
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return db;
  }

  Future<void> finish(WidgetTester tester, AppDatabase db) async {
    await disposeApp(tester);
    await db.close();
  }

  for (final language in ['tr', 'en', 'de']) {
    testWidgets('$language UI: a chosen Türkiye keeps its lines and green '
        'support buttons', (tester) async {
      final db = await showCard(
        tester,
        const Locale('en', 'US'), // device region differs: the choice wins
        language,
        country: 'TR',
      );
      expect(find.text('ALO 171 · 171'), findsOneWidget);
      expect(find.text('YEDAM · 115'), findsOneWidget);
      expect(find.textContaining('1-800-QUIT-NOW'), findsNothing);
      final button = tester.widget<FilledButton>(
        find.byType(FilledButton).first,
      );
      expect(
        button.style!.backgroundColor!.resolve({}),
        const Color(0xFF166534),
      );
      expect(tester.takeException(), isNull);
      await finish(tester, db);
    });
  }

  testWidgets('nothing chosen: no line is shown, none assumed', (tester) async {
    final db = await showCard(tester, const Locale('en', 'TR'), 'en');
    expect(find.byType(FilledButton), findsNothing);
    expect(find.text('Choose your country'), findsOneWidget);
    // The phone's region is only a suggestion the user can accept.
    expect(find.textContaining('Use Türkiye'), findsOneWidget);
    expect(find.textContaining('ALO 171'), findsNothing);
    await finish(tester, db);
  });

  testWidgets('a phone with no region offers no suggestion', (tester) async {
    final db = await showCard(tester, const Locale('en'), 'en');
    expect(find.byType(FilledButton), findsNothing);
    expect(find.textContaining('from your phone'), findsNothing);
    await finish(tester, db);
  });

  testWidgets('the UK shows all three national services', (tester) async {
    final db = await showCard(
      tester,
      const Locale('en', 'GB'),
      'en',
      country: 'GB',
    );
    expect(find.textContaining('NHS Smokefree (England)'), findsOneWidget);
    expect(find.textContaining('Quit Your Way (Scotland)'), findsOneWidget);
    expect(find.textContaining('Help Me Quit (Wales)'), findsOneWidget);
    await finish(tester, db);
  });

  testWidgets('an invalid stored country never shows an unrelated number',
      (tester) async {
    final db = await showCard(
      tester,
      const Locale('en', 'CA'),
      'en',
      country: 'ZZ',
    );
    expect(find.byType(FilledButton), findsNothing);
    expect(tester.takeException(), isNull);
    await finish(tester, db);
  });

  for (final language in ['en', 'tr', 'de']) {
    for (final brightness in Brightness.values) {
      testWidgets('$language ${brightness.name} narrow large-text layout', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final db = await showCard(
          tester,
          const Locale('en', 'TR'),
          language,
          country: 'GB',
          textScale: 1.5,
          brightness: brightness,
        );
        expect(tester.takeException(), isNull);
        await finish(tester, db);
      });
    }
  }
}
