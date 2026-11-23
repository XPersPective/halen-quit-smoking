import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('App boots, localizes the shell and lands on onboarding', (
    tester,
  ) async {
    await pumpHalenApp(tester, androidTrialConsent: null);
    await tester.pumpAndSettle();

    expect(find.text('24-hour trial and device privacy'), findsOneWidget);
    await tester.ensureVisible(find.text('Enable the 24-hour trial'));
    await tester.tap(find.text('Enable the 24-hour trial'));
    await tester.pumpAndSettle();

    // Fresh install: the welcome screen waits for the person now (it used to
    // route away on its own first frame, so nobody could read it).
    await tester.ensureVisible(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(find.text('How old are you?'), findsOneWidget);

    // The app root now watches the persisted settings (theme + language), so
    // teardown must cancel the drift stream and flush its timers.
    await disposeApp(tester);
  });

  testWidgets('declining the Android trial keeps free access available', (
    tester,
  ) async {
    final db = await pumpHalenApp(tester, androidTrialConsent: null);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Continue without the trial'));
    await tester.tap(find.text('Continue without the trial'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect((await db.settingsDao.getSettings()).androidTrialConsent, isFalse);
    expect(find.text('How old are you?'), findsOneWidget);
    await disposeApp(tester);
  });
}
