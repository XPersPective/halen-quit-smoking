import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/application/entitlement_providers.dart';
import 'package:halen/domain/entitlement.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/today/today_screen.dart';

import '../helpers/pump_app.dart';

// Optional visual QA: --update-goldens --dart-define=CAPTURE_DESIGN=true
// --dart-define=DESIGN_FONT=<Flutter SDK>/bin/cache/artifacts/material_fonts/roboto-regular.ttf
void main() {
  const capture = bool.fromEnvironment('CAPTURE_DESIGN');
  setUpAll(() async {
    const font = String.fromEnvironment('DESIGN_FONT');
    if (font.isNotEmpty) {
      final loader = FontLoader('Roboto');
      loader.addFont(Future.value(ByteData.sublistView(await File(font).readAsBytes())));
      await loader.load();
      final icons = FontLoader('MaterialIcons');
      icons.addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await icons.load();
    }
  });

  for (final variant in [
    (width: 390.0, scale: 1.0, dark: false, locale: 'tr'),
    (width: 390.0, scale: 1.0, dark: true, locale: 'tr'),
    (width: 320.0, scale: 1.6, dark: false, locale: 'de'),
  ]) {
    testWidgets('core screens fit ${variant.width} ${variant.scale} ${variant.dark}', (tester) async {
      tester.view.physicalSize = Size(variant.width, 844);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.localesTestValue = [Locale(variant.locale)];
      tester.platformDispatcher.textScaleFactorTestValue = variant.scale;
      tester.platformDispatcher.platformBrightnessTestValue = variant.dark ? Brightness.dark : Brightness.light;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearAllTestValues);
      final db = await seedOnboardedProfile();
      final now = DateTime.now();
      for (var i = 0; i < 7; i++) {
        await db.statsDao.upsertSummary(DailySummaryCompanion.insert(
          date: dayKey(now.subtract(Duration(days: 6 - i))),
          count: [15, 13, 14, 11, 10, 8, 6][i],
          planTarget: const Value(12),
          savings: Value(10.0 + i * 5),
        ));
      }
      for (var i = 0; i < 6; i++) {
        await db.recordDao.insertEvent(CigaretteEventCompanion.insert(
          ts: now.dayStart.add(Duration(minutes: i * 22)),
          source: RecordSource.app,
          triggerLabel: Value(i.isEven ? TriggerLabel.coffee : TriggerLabel.stress),
        ));
      }
      await pumpHalenApp(tester, database: db, extraOverrides: [
        entitlementProvider.overrideWith((ref) async => evaluateAccess(storeVerifiedOwned: true, trialStartedAt: null, now: now)),
      ]);
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(TodayScreen)))!;
      expect(tester.takeException(), isNull);
      Future<void> screenshot(String name) async {
        if (capture && variant.scale == 1) {
          await expectLater(find.byType(MaterialApp), matchesGoldenFile('../../build/design/$name-${variant.dark ? 'dark' : 'light'}.png'));
        }
      }
      await screenshot('today');
      await tester.tap(find.text(l10n.navStats));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await screenshot('stats');
      for (final tab in [l10n.statsTabHourly, l10n.statsTabIntervals, l10n.statsTabTriggers]) {
        final chip = find.widgetWithText(ChoiceChip, tab);
        // The savings hero + trend chart push the chips below the fold on
        // small screens — scroll the lazy ListView items into existence.
        await tester.scrollUntilVisible(
          chip,
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(chip);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.text(l10n.navSos));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await screenshot('sos');
      await disposeApp(tester);
      await db.close();
    });
  }
}
