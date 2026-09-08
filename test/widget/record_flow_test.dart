import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entities.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('one-tap log opens detail, saves optional trigger tag',
      (tester) async {
    useLargeTestSurface(tester);
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();

    // Splash auto-routes to Today for an onboarded profile.
    expect(find.text('I SMOKED'), findsOneWidget);

    // One tap logs the cigarette. The feedback sheet (module report §12)
    // comes first — a quietening, never a gate: the record is already saved
    // behind it and it is dismissed with a single tap.
    await tester.tap(find.text('I SMOKED'));
    await tester.pumpAndSettle();
    expect(find.text('Not a failure. A data point.'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await tester.pumpAndSettle();

    expect(find.text('Log details'), findsOneWidget);

    final eventsBefore = await db.select(db.cigaretteEvent).get();
    expect(eventsBefore, hasLength(1));
    expect(eventsBefore.single.source, RecordSource.app);
    expect(eventsBefore.single.triggerLabel, isNull);

    // Optional tag: one chip, then Done.
    await tester.tap(find.text('Coffee'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await tester.pumpAndSettle();

    final events = await db.select(db.cigaretteEvent).get();
    expect(events.single.triggerLabel, TriggerLabel.coffee);

    // Back on Today: the daily ring reflects the record (1 smoked of 12).
    expect(find.text('1/12'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('resisted craving is recorded without navigating',
      (tester) async {
    useLargeTestSurface(tester);
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('I resisted a craving'));
    await tester.pumpAndSettle();

    // The ride-out feedback opens; dismissing it returns to Today.
    expect(find.text('A peak that never happened'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Done'));
    await tester.pumpAndSettle();

    final cravings = await db.select(db.cravingEvent).get();
    expect(cravings, hasLength(1));
    expect(cravings.single.outcome, CravingOutcome.resisted);
    // Stays on Today; no detail screen.
    expect(find.text('Log details'), findsNothing);

    await disposeApp(tester);
  });
}
