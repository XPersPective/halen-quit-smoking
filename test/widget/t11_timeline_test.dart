import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/timeline/health_timeline_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pump(WidgetTester tester) async {
    // Tall surface so the milestone ListView builds every card.
    tester.view.physicalSize = const Size(420, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HealthTimelineScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('no quit date: preview is locked but visible, date can be set', (
    tester,
  ) async {
    await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(HealthTimelineScreen)),
    )!;
    // General preview is still shown while locked (T11: no fake certainty).
    expect(find.text(l10n.timelinePreviewLocked), findsOneWidget);
    expect(find.text(l10n.timelineMilestone20min), findsOneWidget);
    expect(find.text(l10n.timelineSetQuitDate), findsOneWidget);
    expect(find.text(l10n.timelineAutoNote), findsOneWidget);
    expect(find.text(l10n.timelineNotPersonal), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('a set quit date unlocks reached/current milestones', (
    tester,
  ) async {
    final now = DateTime.now();
    await db.timelineDao.getState();
    await db.timelineDao.setQuitTs(
      DateTime(now.year, now.month, now.day - 1, 12),
    );
    await pump(tester);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(HealthTimelineScreen)),
    )!;
    expect(find.text(l10n.timelineSetQuitDate), findsNothing);
    expect(find.text(l10n.timelinePreviewLocked), findsNothing);
    // Day 1: the 20-minute milestone is behind us; the list still names
    // every time point, reached or not (accessible labels).
    expect(find.text(l10n.timelineMilestone20min), findsOneWidget);
    expect(find.text(l10n.timelineMilestone1y), findsOneWidget);
    await disposeApp(tester);
  });

  test('quit-date dao round-trips through the lazy state row', () async {
    final now = DateTime.now();
    await db.timelineDao.getState();
    final yesterday = DateTime(now.year, now.month, now.day - 1, 12);
    await db.timelineDao.setQuitTs(yesterday);
    final state = await db.timelineDao.getState();
    expect(state.quitTs, yesterday);
  });
}
