import 'package:flutter_test/flutter_test.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('App boots, localizes the shell and lands on onboarding',
      (tester) async {
    await pumpHalenApp(tester);
    await tester.pumpAndSettle();

    // Fresh install: the splash auto-routes into onboarding step 1.
    expect(find.text('How old are you?'), findsOneWidget);
  });
}
