import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';

import 'package:halen/presentation/screens/today/today_screen.dart';

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
      // The tabs are a horizontal PageView now, so Scrollable.first is the
      // pager — dragging it swipes to the next tab. Scroll Today's own list.
      scrollable: find
          .descendant(
            of: find.byType(TodayScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    // scrollUntilVisible stops as soon as the target is technically on
    // screen, which can leave it half under the edge — and a tap there
    // silently misses. ensureVisible centres it first.
    await tester.ensureVisible(find.byIcon(Icons.favorite_border_rounded));
    await tester.pumpAndSettle();
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
      // Today's own list, not the tab PageView that is now Scrollable.first.
      scrollable: find
          .descendant(
            of: find.byType(TodayScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    // scrollUntilVisible stops the moment the tile is on screen at all, which
    // can leave its header under the edge; a tap there silently misses and
    // the section never opens. Centre it first.
    await tester.ensureVisible(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('How is this estimate calculated?'));
    await tester.tap(find.text('How is this estimate calculated?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('1.2 mg'), findsOneWidget);
    // Every module now publishes its own formula here, so the honesty line
    // appears in several sections (module report §0.2).
    expect(find.textContaining('not a measurement'), findsWidgets);
    expect(find.textContaining('Benowitz'), findsOneWidget);

    await disposeApp(tester);
  });
}
