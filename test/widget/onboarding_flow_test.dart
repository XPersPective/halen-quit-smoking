import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/cessation.dart';
import 'package:halen/domain/entities.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(inMemoryExecutor());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('onboarding walks 8 steps and creates the smoking profile',
      (tester) async {
    await pumpHalenApp(tester, database: db);

    // First launch now waits on the welcome screen until the person taps
    // Start; it used to route away on its own first frame.
    await tester.pumpAndSettle();
    // The Start button sits below the fold on the test surface.
    await tester.ensureVisible(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    expect(find.text('How old are you?'), findsOneWidget);

    // Step 1: age (default 25–34 preselected) → Next.
    await _next(tester);

    // Step 2: daily count slider → Next.
    expect(find.text('On average, how many cigarettes do you smoke per day?'),
        findsOneWidget);
    await _next(tester);

    // Step 3: TTFC — pick "5–30 minutes".
    await tester.tap(find.text('5–30 minutes'));
    await tester.pumpAndSettle();
    await _next(tester);

    // Step 4: price pre-filled → Next.
    expect(find.text('How much does a pack cost?'), findsWidgets);
    await _next(tester);

    // Step 5: triggers — pick coffee.
    await tester.tap(find.text('Coffee'));
    await tester.pumpAndSettle();
    await _next(tester);

    // Step 6: goal — keep the recommended "Reduce, then quit".
    expect(find.text('What is your goal?'), findsOneWidget);
    await _next(tester);

    // Step 7: why — the reason in their own words, stored on the quit plan.
    expect(find.text('Why do you want to stop?'), findsOneWidget);
    await tester.tap(find.text('For my children'));
    await tester.pumpAndSettle();
    await _next(tester);

    // Step 8: brand optional + disclaimer → finish. (Text appears twice:
    // as the step title and as the TextField label.)
    expect(find.text('Your brand (optional)'), findsWidgets);
    expect(find.textContaining('not medical advice'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Set up my plan'));
    await tester.pumpAndSettle();

    await tester.pumpAndSettle();
    // Onboarding now lands on the result screen rather than an empty Today:
    // eight questions have to buy something visible (premium brief §A.1).
    expect(find.text('This is where you are starting'), findsOneWidget);
    expect(find.text('Packs a year'), findsOneWidget);

    final plan = await db.cessationDao.getPlan();
    expect(plan!.reason, QuitReason.children);

    // The result screen is a lazy ListView: the button below the fold is
    // not built until it is scrolled into range.
    await tester.scrollUntilVisible(
      find.widgetWithText(FilledButton, 'Start'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Start'));
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);

    final profile = await db.profileDao.getSmokingProfile();
    expect(profile, isNotNull);
    expect(profile!.baselineCpd, 15);
    expect(profile.ttfcBand, TtfcBand.five30);
    expect(profile.targetMode, TargetMode.reduce);

    final triggers = await db.select(db.trigger).get();
    expect(triggers.map((t) => t.labelKey), contains(TriggerLabel.coffee));

    await disposeApp(tester);
  });

  testWidgets('under-18 path creates no smoking profile', (tester) async {
    await pumpHalenApp(tester, database: db);
    await tester.pumpAndSettle();
    // The Start button sits below the fold on the test surface.
    await tester.ensureVisible(find.byType(FilledButton).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Under 18'));
    await tester.pumpAndSettle();
    await _next(tester);

    await tester.pumpAndSettle();
    expect(find.text('Support for young people'), findsOneWidget);

    final profile = await db.profileDao.getSmokingProfile();
    expect(profile, isNull);
    final user = await db.profileDao.getUserProfile();
    expect(user!.ageBand, AgeBand.under18);

    await disposeApp(tester);
  });
}

Future<void> _next(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(FilledButton, 'Next'));
  await tester.pumpAndSettle();
}
