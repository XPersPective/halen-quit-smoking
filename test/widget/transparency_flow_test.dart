import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('timeline shows locked preview without a quit date and '
      'unlocks with one', (tester) async {
    useLargeTestSurface(tester);
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();

    // From Today's health strip into the timeline.
    await tester.scrollUntilVisible(
      find.byIcon(Icons.favorite_border_rounded),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();

    // Locked: preview notice visible, WHO-source cards visible.
    expect(find.textContaining('preview'), findsOneWidget);
    expect(find.textContaining('WHO'), findsWidgets);

    // Set a quit date in the past → unlock (preview notice disappears).
    await db.timelineDao.setQuitTs(
      DateTime.now().subtract(const Duration(days: 30)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('preview'), findsNothing);

    await disposeApp(tester);
  });

  testWidgets('transparency screen explains model, limits and sources', (
    tester,
  ) async {
    useLargeTestSurface(tester);
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byType(ExpansionTile),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('How is this estimate calculated?'));
    await tester.tap(find.text('How is this estimate calculated?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('1.2 mg'), findsOneWidget);
    expect(find.textContaining('not a measurement'), findsOneWidget);
    expect(find.textContaining('Benowitz'), findsOneWidget);

    await disposeApp(tester);
  });
}
