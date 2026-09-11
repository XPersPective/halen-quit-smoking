import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('App boots, localizes the shell and lands on onboarding',
      (tester) async {
    await pumpHalenApp(tester);
    await tester.pumpAndSettle();

    // Fresh install: the welcome screen waits for the person now (it used to
    // route away on its own first frame, so nobody could read it).
    await tester.ensureVisible(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(find.text('How old are you?'), findsOneWidget);
  });
}
