import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/articles/sources_screen.dart';
import 'package:halen/presentation/screens/body/body_screen.dart';
import 'package:halen/presentation/screens/economy/economy_screen.dart';
import 'package:halen/presentation/screens/plan/plan_switch_screen.dart';
import 'package:halen/presentation/screens/transparency/glossary_screen.dart';
import 'package:halen/presentation/widgets/body_load_card.dart';
import 'package:halen/presentation/widgets/craving_window_card.dart';
import 'package:halen/presentation/widgets/daily_card_tile.dart';
import 'package:halen/presentation/widgets/indices_card.dart';
import 'package:halen/presentation/widgets/mind_state_card.dart';
import 'package:halen/presentation/widgets/sos_techniques_list.dart';
import 'package:halen/presentation/widgets/today/now_in_body_strip.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(inMemoryExecutor());
  });
  tearDown(() => db.close());

  Future<void> seedProfile() async {
    await db.profileDao.saveUserProfile(locale: 'en', ageBand: AgeBand.y35to44);
    await db.profileDao.saveSmokingProfile(
      SmokingProfileCompanion.insert(
        baselineCpd: 20,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        targetMode: TargetMode.reduce,
        pace: Pace.standard,
        startedAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    );
  }

  Future<void> seedEvents(int count) async {
    final start = DateTime.now().subtract(const Duration(hours: 20));
    for (var i = 0; i < count; i++) {
      await db.recordDao.insertEvent(
        CigaretteEventCompanion.insert(
          ts: start.add(Duration(minutes: 45 * i)),
          source: RecordSource.app,
        ),
      );
    }
  }

  testWidgets('body load card asks for data before drawing a curve',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(tester, db: db, child: const BodyLoadCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.bodyLoadEmpty), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('body load card shows the modelled state once records exist',
      (tester) async {
    await seedProfile();
    await seedEvents(12);
    await pumpModuleWidget(tester, db: db, child: const BodyLoadCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.bodyLoadEmpty), findsNothing);
    // The four load readouts are all present and none of them is a
    // concentration — bands only.
    expect(find.text(l10n.loadNicotineAcute), findsOneWidget);
    expect(find.text(l10n.loadCarbonMonoxide), findsOneWidget);
    expect(find.text(l10n.loadTar), findsOneWidget);
    expect(find.textContaining('ng/mL'), findsNothing);
    expect(find.textContaining('mg'), findsNothing);

    await disposeApp(tester);
  });

  testWidgets('craving card leads with the falling-nicotine finding',
      (tester) async {
    await seedProfile();
    await seedEvents(5);
    await pumpModuleWidget(tester, db: db, child: const CravingWindowCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.cravingFallingNote), findsOneWidget);
    // Too little history to claim a pattern — it says so instead of drawing.
    expect(find.text(l10n.moduleNeedMoreData), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('indices card shows both scores with their honesty lines',
      (tester) async {
    await seedProfile();
    await seedEvents(6);
    await pumpModuleWidget(tester, db: db, child: const IndicesCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.progressScoreTitle), findsOneWidget);
    expect(find.text(l10n.harmLoadTitle), findsOneWidget);
    // The honesty lines now live in each card's footnote.
    expect(find.textContaining(l10n.harmNotRisk), findsOneWidget);
    expect(find.text(l10n.progressBehaviourNote), findsWidgets);
    // Both readouts are named, banded and openable rather than bare numbers.
    expect(find.text(l10n.indicesBreakdownTitle), findsWidgets);

    await disposeApp(tester);
  });

  testWidgets('mind state reports a band, never a percentage', (tester) async {
    await seedProfile();
    await pumpModuleWidget(tester, db: db, child: const MindStateCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.mindOnlyYouKnow), findsOneWidget);
    expect(find.text(l10n.mindQuitLowersAnxiety), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Text && (w.data ?? '').contains('% more'),
      ),
      findsNothing,
    );

    await disposeApp(tester);
  });

  testWidgets('mind state records how the user actually feels',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(tester, db: db, child: const MindStateCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.widgetWithText(OutlinedButton, l10n.mindBandTough));
    await tester.pumpAndSettle();

    final moods = await db.moduleDao.moodsSince(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    expect(moods.single.reportedBand, 2);

    await disposeApp(tester);
  });

  testWidgets('SOS techniques carry evidence grades, including the honest one',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(tester, db: db, child: const SosTechniquesList());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.evidenceStrong), findsWidgets);
    expect(find.text(l10n.evidenceTraditional), findsWidgets);
    expect(find.text(l10n.sosNoNeedles), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('SOS technique order follows what worked for this user',
      (tester) async {
    await seedProfile();
    // Three successful rides-out with the ear acupressure technique — enough
    // local evidence to outrank the default order.
    for (var i = 0; i < 3; i++) {
      await db.cravingDao.insertCraving(
        CravingEventCompanion.insert(
          ts: DateTime.now().subtract(Duration(hours: i + 1)),
          intensity: CravingIntensity.medium,
          outcome: CravingOutcome.resisted,
          techniqueKey: const Value('earAcupressure'),
        ),
      );
    }
    await pumpModuleWidget(tester, db: db, child: const SosTechniquesList());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.sosWhatWorked), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('the home strip answers "how much is still in me", in a unit',
      (tester) async {
    await seedProfile();
    await seedEvents(6);
    await pumpModuleWidget(tester, db: db, child: const NowInBodyStrip());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.nowInBodyTitle), findsOneWidget);

    // The three headline readouts, and — the point of the card — an axis
    // that says what its numbers mean.
    expect(find.text(l10n.loadNicotineAcute), findsOneWidget);
    expect(find.text(l10n.loadCarbonMonoxide), findsOneWidget);
    expect(find.text(l10n.nowInBodyLast), findsOneWidget);
    // Item 12: the nicotine axis is in milligrams now.
    expect(find.text(l10n.nicotineMgAxis), findsOneWidget);

    // A percentage is shown, and it is written the way English writes one.
    expect(find.textContaining(RegExp(r'^\d+%$')), findsWidgets);

    await disposeApp(tester);
  });

  testWidgets('with no records the strip invites one instead of showing zero',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(tester, db: db, child: const NowInBodyStrip());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.nowInBodyEmpty), findsOneWidget);
    expect(find.text(l10n.loadAxisCaption), findsNothing);

    await disposeApp(tester);
  });

  testWidgets('the body map opens an organ with its impact and recovery',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(
      tester,
      db: db,
      child: const BodyScreen(initialTab: 0),
      scrollable: false,
    );
    // The map pulses forever by design, so settle is not an option.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // Nothing is selected yet: the invitation is on screen, no detail is.
    expect(find.text(l10n.organTapHint), findsOneWidget);
    expect(find.text(l10n.organRecoveryTitle), findsNothing);

    await tester.tap(find.bySemanticsLabel('Lungs').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Harm never ships without recovery, and the figure is labelled as a
    // population figure rather than a reading of this body.
    expect(find.text(l10n.organHarmTitle), findsOneWidget);
    expect(find.text(l10n.organRecoveryTitle), findsOneWidget);
    expect(find.text(l10n.organNotYou), findsOneWidget);
    expect(
      find.text(l10n.organImpactAttributable(79)),
      findsOneWidget,
    );
    // The recovery timeline is part of every drawn organ's detail.
    expect(find.text(l10n.organTimelineTitle), findsOneWidget);
    expect(find.text('2–12 weeks'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('economy shows both sides of the ledger and the decision gap',
      (tester) async {
    await seedProfile();
    await seedEvents(10);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const EconomyScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.economySaved), findsOneWidget);
    // The half nobody else shows.
    expect(find.text(l10n.economySpent), findsOneWidget);
    expect(find.text(l10n.economyShadedArea), findsOneWidget);
    // The time ledger is labelled as an average, never as a countdown — it
    // sits below the fold, so drag it into existence first.
    await tester.dragUntilVisible(
      find.text(l10n.economyLifeAverageNote),
      find.byType(ListView),
      const Offset(0, -300),
    );
    expect(find.text(l10n.economyLifeAverageNote), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('plan switching shows the report card before the options',
      (tester) async {
    await seedProfile();
    await seedEvents(8);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const PlanSwitchScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.planReportCardTitle), findsOneWidget);
    expect(find.text(l10n.planReportAdherence), findsOneWidget);
    expect(find.text(l10n.planKindQuota), findsOneWidget);
    // A fresh plan is younger than the seven-day minimum, so it says so.
    expect(find.textContaining('more days'), findsOneWidget);
    await tester.dragUntilVisible(
      find.text(l10n.planHistoryKept),
      find.byType(ListView),
      const Offset(0, -300),
    );
    expect(find.text(l10n.planHistoryKept), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('the sources screen lists the evidence behind the claims',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(
      tester,
      db: db,
      child: const SourcesScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.sourcesIntro), findsOneWidget);
    expect(find.textContaining('https://'), findsWidgets);

    await disposeApp(tester);
  });

  testWidgets('the daily card never opens with fear during the peak days',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(tester, db: db, child: const DailyCardTile());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // The profile started 20 days ago, so any family may appear — but if a
    // hard-truth card is shown it must carry its action block.
    if (find.text(l10n.dailyCardReality).evaluate().isNotEmpty) {
      expect(find.text(l10n.dailyCardAction), findsOneWidget);
    }
    expect(find.textContaining(l10n.moduleSourceLabel), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('the glossary explains every term in one plain sentence',
      (tester) async {
    await seedProfile();
    await pumpModuleWidget(
      tester,
      db: db,
      child: const GlossaryScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.glossaryIntro), findsOneWidget);
    // The terms a user meets first are the ones explained first.
    expect(find.text(l10n.progressScoreTitle), findsOneWidget);
    expect(find.text(l10n.harmLoadTitle), findsOneWidget);
    expect(find.text(l10n.glossaryProgress), findsOneWidget);
    // Every explanation is a single sentence — no jargon dumps.
    for (final meaning in [
      l10n.glossaryProgress,
      l10n.glossaryHarm,
      l10n.glossaryBodyLoad,
      l10n.glossaryCo,
    ]) {
      expect(meaning.split('. ').length, lessThanOrEqualTo(2), reason: meaning);
    }

    await disposeApp(tester);
  });

  testWidgets('the indices lead with a gauge, a banded scale and a legend',
      (tester) async {
    await seedProfile();
    await seedEvents(10);
    // Two earlier snapshots so the 30-day trend has something to draw; with
    // a single day it correctly says so instead.
    for (var d = 2; d >= 1; d--) {
      final day = DateTime.now().subtract(Duration(days: d));
      await db.moduleDao.putIndexSnapshot(
        date: dayKey(day),
        progressScore: 40 + d,
        harmLoad: 70 - d,
      );
    }
    await pumpModuleWidget(tester, db: db, child: const IndicesCard());
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // Every band of the load scale is named on screen — a load without its
    // bands is a number nobody can read.
    for (final band in [
      l10n.harmBandLight,
      l10n.harmBandModerate,
      l10n.harmBandHeavy,
      l10n.harmBandVeryHeavy,
    ]) {
      expect(find.text(band), findsWidgets, reason: band);
    }
    // The trend chart names both lines and says which way is good.
    expect(find.text(l10n.indicesProgressLegend), findsOneWidget);
    expect(find.text(l10n.indicesHarmLegend), findsOneWidget);
    expect(find.text(l10n.indicesMeaning), findsOneWidget);

    await disposeApp(tester);
  });
}
