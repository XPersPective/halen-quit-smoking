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

  /// The SOS page is a lazy list; the toolkit made it taller than the test
  /// viewport, so tests drag the list until the target is built.
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.dragUntilVisible(
      finder,
      find.byType(ListView),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SOS shows 2-minute timer, 4D cards and NRT line',
      (tester) async {
    await openSos(tester);

    expect(find.text('2-minute timer'), findsWidgets);

    // Module report §5: one toolkit, every entry graded. The five-minute
    // walk leads because it is the best-supported acute intervention.
    expect(find.text('Walk it off (5 min)'), findsOneWidget);
    expect(find.text('Breathe with me'), findsOneWidget);
    expect(find.text('Delay 3 minutes'), findsOneWidget);
    expect(find.text('A glass of water'), findsOneWidget);
    expect(find.text('Strong evidence'), findsWidgets);

    // Ear acupressure ships, but honestly labelled and needle-free — the
    // grade is the point, and it is never presented as proven.
    expect(find.text('Ear acupressure (60 s)'), findsOneWidget);
    expect(find.text('Traditional'), findsWidgets);
    expect(find.text('Fingers only — never needles.'), findsOneWidget);

    // Fixed NRT line (report §15) — still last, still unchanged.
    await scrollTo(tester, find.textContaining('NRT'));
    expect(find.textContaining('NRT'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('resisting a craving increments the positive counter',
      (tester) async {
    await openSos(tester);

    // The outcome card sits below the toolkit now — bring it into view.
    await scrollTo(tester, find.widgetWithText(FilledButton, 'I resisted'));
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

    await scrollTo(tester, find.widgetWithText(OutlinedButton, 'I smoked'));
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
    await tester.tap(find.text('Breathe with me'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('60 s'), findsOneWidget);
    expect(find.textContaining('Breathe in'), findsWidgets);

    // Pump 60 seconds of ticks.
    await tester.pump(const Duration(seconds: 61));
    expect(find.textContaining('One minute done'), findsOneWidget);

    await disposeApp(tester);
  });
}
