import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/cessation.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/cessation/medicines_screen.dart';
import 'package:halen/presentation/screens/cessation/quit_day_screen.dart';
import 'package:halen/presentation/screens/cessation/quit_plan_screen.dart';
import 'package:halen/presentation/widgets/cessation/quit_date_strip.dart';
import 'package:halen/presentation/widgets/cessation/slip_coach_card.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() async {
    db = AppDatabase(inMemoryExecutor());
    await db.profileDao.saveUserProfile(locale: 'en', ageBand: AgeBand.y35to44);
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion.insert(
        baselineCpd: 20,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        targetMode: TargetMode.reduce,
        pace: Pace.standard,
        startedAt: DateTime.now().subtract(const Duration(days: 30)),
        hsi: const Value(5),
      ),
    );
  });

  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// These screens are long lists; a default 800x600 surface hides most of
  /// them below the fold and every finder then reports "not found" for
  /// content that is simply not laid out yet.
  void tallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('the quit plan opens empty and readiness starts at zero',
      (tester) async {
    tallSurface(tester);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const QuitPlanScreen(),
      scrollable: false,
    );
    await settle(tester);

    expect(find.text(l10n.quitPlanTitle), findsOneWidget);
    expect(find.text(l10n.quitDateNone), findsOneWidget);
    expect(find.text(l10n.quitPlanReadiness(5, 0)), findsOneWidget);
    // The empty coping plan says what is missing rather than showing nothing.
    expect(find.text(l10n.copingEmpty), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('choosing a reason and taking the rule moves readiness',
      (tester) async {
    tallSurface(tester);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const QuitPlanScreen(),
      scrollable: false,
    );
    await settle(tester);

    await tester.tap(find.text(l10n.reasonChildren));
    await settle(tester);
    expect(find.text(l10n.quitPlanReadiness(5, 1)), findsOneWidget);

    await tester.tap(find.text(l10n.notAPuffAccept));
    await settle(tester);
    expect(find.text(l10n.quitPlanReadiness(5, 2)), findsOneWidget);
    expect(find.text(l10n.notAPuffTaken), findsOneWidget);

    final plan = await db.cessationDao.getPlan();
    expect(plan!.reason, QuitReason.children);
    expect(plan.notAPuffAccepted, isTrue);

    await disposeApp(tester);
  });

  testWidgets('medicines name their comparator, never a dose', (tester) async {
    tallSurface(tester);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const MedicinesScreen(),
      scrollable: false,
    );
    await settle(tester);

    // Both shelves are present, and the prescription ones are framed as
    // something to ask about rather than something to take.
    expect(find.text(l10n.medicinesOtc), findsOneWidget);
    expect(find.text(l10n.medicinesPrescription), findsOneWidget);
    expect(find.text(l10n.medicinesDisclaimer), findsOneWidget);

    // The effect size is always shown with what it is compared against.
    expect(find.text(l10n.medicinesRatioPlacebo('1.55')), findsWidgets);
    expect(find.text(l10n.medicinesRatioSingle('1.25')), findsOneWidget);

    // HSI 5 and 20 a day: the combination suggestion applies.
    expect(find.text(l10n.medicinesCombinationSuggestion), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('a medicine opens to how it works and the usual mistake',
      (tester) async {
    tallSurface(tester);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const MedicinesScreen(),
      scrollable: false,
    );
    await settle(tester);

    expect(find.text(l10n.medicinesCommonMistake), findsNothing);
    await tester.tap(find.text('Nicotine patch'));
    await settle(tester);
    expect(find.text(l10n.medicinesHowItWorks), findsOneWidget);
    expect(find.text(l10n.medicinesCommonMistake), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('the slip coach stays silent until there is a slip',
      (tester) async {
    await pumpModuleWidget(tester, db: db, child: const SlipCoachCard());
    await settle(tester);
    expect(find.text(l10n.slipTitle), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('one cigarette after the quit date is named as a lapse',
      (tester) async {
    await db.cessationDao.setQuitDate(
      DateTime.now().subtract(const Duration(days: 2)),
    );
    await db.recordDao.insertEvent(
      CigaretteEventCompanion.insert(
        ts: DateTime.now().subtract(const Duration(hours: 3)),
        source: RecordSource.app,
      ),
    );

    await pumpModuleWidget(tester, db: db, child: const SlipCoachCard());
    await settle(tester);

    // Named, and followed by something to do — not reassurance alone.
    expect(find.text(l10n.slipTitle), findsOneWidget);
    expect(find.text(l10n.slipAction), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('the home strip invites a date, then counts down to it',
      (tester) async {
    await pumpModuleWidget(tester, db: db, child: const QuitDateStrip());
    await settle(tester);
    expect(find.text(l10n.quitDateWhy), findsOneWidget);

    await db.cessationDao.setQuitDate(
      DateTime.now().add(const Duration(days: 5)),
    );
    await settle(tester);
    expect(find.text(l10n.quitDateIn(5)), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('quit day plays the reason back to the person', (tester) async {
    await db.cessationDao.setReason(QuitReason.children);
    tallSurface(tester);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const QuitDayScreen(),
      scrollable: false,
    );
    await settle(tester);

    expect(find.text(l10n.quitDayMorningBody), findsOneWidget);
    expect(
      find.text(
        l10n.quitDayReasonReminder(l10n.reasonChildren.toLowerCase()),
      ),
      findsOneWidget,
    );

    await disposeApp(tester);
  });

  group('cessation dao', () {
    test('moving a date counts, setting the first one does not', () async {
      await db.cessationDao.setQuitDate(DateTime(2026, 10, 1));
      expect((await db.cessationDao.getPlan())!.quitDateMoves, 0);

      await db.cessationDao.setQuitDate(DateTime(2026, 10, 8));
      expect((await db.cessationDao.getPlan())!.quitDateMoves, 1);

      // Clearing is not a move.
      await db.cessationDao.setQuitDate(null);
      expect((await db.cessationDao.getPlan())!.quitDateMoves, 1);
    });

    test('an emptied coping plan is deleted rather than stored blank',
        () async {
      await db.cessationDao.saveCopingPlan(
        trigger: TriggerLabel.coffee,
        plan: 'Walk round the block',
      );
      expect(await db.cessationDao.copingPlans(), hasLength(1));

      await db.cessationDao.saveCopingPlan(
        trigger: TriggerLabel.coffee,
        plan: '   ',
      );
      expect(await db.cessationDao.copingPlans(), isEmpty);
    });

    test('a support person is trimmed, and blank means nobody', () async {
      await db.cessationDao.setSupportPerson('  Ayşe  ');
      expect((await db.cessationDao.getPlan())!.supportPerson, 'Ayşe');

      await db.cessationDao.setSupportPerson('   ');
      expect((await db.cessationDao.getPlan())!.supportPerson, isNull);
    });

    test('a mood screen stores its own total', () async {
      await db.cessationDao.recordMoodScreen(lowInterest: 2, lowMood: 3);
      final row = await db.cessationDao.latestMoodScreen();
      expect(row!.total, 5);
      expect(Phq2.isPositive(row.total), isTrue);
    });
  });
}
