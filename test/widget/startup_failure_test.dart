import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/app.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/presentation/screens/startup_failure_screen.dart';

void main() {
  testWidgets('startup failure never accesses the unavailable database', (
    tester,
  ) async {
    var reads = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) {
            reads++;
            throw StateError('Database unavailable');
          }),
        ],
        child: HalenApp(startupError: StateError('Unable to open database')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(StartupFailureScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(reads, 0);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
