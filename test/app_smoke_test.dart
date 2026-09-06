import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:halen/app.dart';

void main() {
  testWidgets('App boots and localizes the shell for English', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HalenApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Plan'), findsWidgets);
    expect(find.text('Statistics'), findsWidgets);
    // The SOS tab label is "Craving SOS" in English.
    expect(find.text('Craving SOS'), findsWidgets);
  });
}
