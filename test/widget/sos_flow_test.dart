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

  Future<void> openSos(WidgetTester tester) async {
    useLargeTestSurface(tester);
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Craving SOS'));
    await tester.pumpAndSettle();
  }

  testWidgets('SOS shows 2-minute timer, 4D cards and NRT line',
      (tester) async {
    await openSos(tester);

    expect(find.text('2-minute timer'), findsWidgets);
    expect(find.text('Delay'), findsOneWidget);
    expect(find.text('Deep breathing'), findsOneWidget);
    expect(find.text('Drink water'), findsOneWidget);
    expect(find.text('Do something else'), findsOneWidget);
    expect(find.text('Watch and wait'), findsOneWidget);
    // Fixed NRT line (report §15).
    expect(find.textContaining('NRT'), findsOneWidget);
    // No acupressure anywhere.
    expect(find.textContaining('pressure'), findsNothing);

    await disposeApp(tester);
  });

  testWidgets('resisting a craving increments the positive counter',
      (tester) async {
    await openSos(tester);

    await tester.tap(find.text('Mild'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'I resisted'));
    await tester.pumpAndSettle();

    final cravings = await db.select(db.cravingEvent).get();
    expect(cravings, hasLength(1));
    expect(cravings.single.outcome, CravingOutcome.resisted);
    expect(cravings.single.intensity, CravingIntensity.mild);
    expect(find.textContaining('resisted 1 craving'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('smoked outcome logs a cigarette and recalculates without '
      'shame', (tester) async {
    await openSos(tester);

    await tester.tap(find.widgetWithText(OutlinedButton, 'I smoked'));
    await tester.pumpAndSettle();

    final events = await db.select(db.cigaretteEvent).get();
    expect(events, hasLength(1));
    // Plan recalculation created an adjustment record for today.
    final adjustments = await db.select(db.planAdjustment).get();
    expect(adjustments, isNotEmpty);
    // Positive language only: the snack is the no-shame recalculated line.
    expect(find.textContaining('recalculated'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('breathing screen guides 60 seconds with phases',
      (tester) async {
    await openSos(tester);

    // The breathing screen animates forever (repeat) — pump fixed frames
    // instead of pumpAndSettle, which would wait for the animation to end.
    await tester.tap(find.text('Deep breathing'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('60 s'), findsOneWidget);
    expect(find.textContaining('Breathe'), findsOneWidget);

    // Pump 60 seconds of ticks.
    await tester.pump(const Duration(seconds: 61));
    expect(find.textContaining('One minute done'), findsOneWidget);

    await disposeApp(tester);
  });
}
