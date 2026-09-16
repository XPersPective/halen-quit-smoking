import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/quitline_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/design_font.dart';

void main() {
  setUpAll(loadDesignFonts);
  Future<void> showCard(
    WidgetTester tester,
    Locale device,
    String language, {
    String? saved,
  }) async {
    SharedPreferences.setMockInitialValues({'quitlineRegion': ?saved});
    tester.platformDispatcher.localeTestValue = device;
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(
          body: SingleChildScrollView(child: QuitlineCard()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final language in ['tr', 'en', 'de']) {
    testWidgets('$language UI keeps Türkiye region and green support buttons', (
      tester,
    ) async {
      await showCard(tester, const Locale('en', 'TR'), language);
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
    });
  }

  testWidgets('language without region does not assume US or Türkiye', (
    tester,
  ) async {
    await showCard(tester, const Locale('en'), 'en');
    expect(find.byType(FilledButton), findsNothing);
    expect(find.text('Country/region for support'), findsOneWidget);
  });

  testWidgets('US and DE device regions use their own services', (
    tester,
  ) async {
    await showCard(tester, const Locale('en', 'US'), 'en');
    expect(find.text('1-800-QUIT-NOW · 18007848669'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await showCard(tester, const Locale('de', 'DE'), 'de');
    expect(find.text('BIÖG rauchfrei · 08008313131'), findsOneWidget);
  });

  testWidgets('UK needs region choice; choice survives reopening', (
    tester,
  ) async {
    await showCard(tester, const Locale('en', 'GB'), 'en');
    expect(find.byType(FilledButton), findsNothing);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('United Kingdom — England').last);
    await tester.pumpAndSettle();
    expect(find.text('NHS Smokefree · 03001231044'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString('quitlineRegion'),
      'GB-ENG',
    );
    await tester.pumpWidget(const SizedBox());
    await showCard(tester, const Locale('en', 'US'), 'en', saved: 'GB-ENG');
    expect(find.text('NHS Smokefree · 03001231044'), findsOneWidget);
    expect(find.textContaining('1-800-QUIT-NOW'), findsNothing);
  });

  testWidgets('unknown region never shows an unrelated number', (tester) async {
    await showCard(tester, const Locale('en', 'CA'), 'en', saved: 'invalid');
    expect(find.byType(FilledButton), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final language in ['en', 'tr', 'de']) {
    for (final brightness in Brightness.values) {
      testWidgets('$language ${brightness.name} narrow large-text layout', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        SharedPreferences.setMockInitialValues({'quitlineRegion': 'TR'});
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale(language),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: ThemeData(brightness: brightness, fontFamily: 'Inter'),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.5)),
              child: child!,
            ),
            home: const Scaffold(
              body: SingleChildScrollView(child: QuitlineCard()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        if (const bool.fromEnvironment('CAPTURE_DESIGN')) {
          await pumpFrames(tester);
          await expectLater(
            find.byType(MaterialApp),
            matchesGoldenFile(
              '../../screenshots/quitline-$language-${brightness.name}.png',
            ),
          );
        }
      });
    }
  }
}
