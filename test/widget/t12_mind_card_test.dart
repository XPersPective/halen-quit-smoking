import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/mind_state_card.dart';

import '../helpers/pump_app.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('zero records: no definite mood is claimed, record confirms', (
    tester,
  ) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: SingleChildScrollView(child: MindStateCard()),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(MindStateCard)),
    )!;
    // The headline is the honest "no data" line, never a measured band.
    expect(find.text(l10n.mindNoDataYet), findsOneWidget);

    // Recording a feeling confirms it and persists it.
    await tester.tap(find.text(l10n.mindBandTough));
    await tester.pumpAndSettle();
    expect(find.text(l10n.moodSaved), findsOneWidget);
    // Let the snackbar's auto-dismiss timer finish before teardown.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    final moods = await db.moduleDao.moodsSince(
      DateTime.now().subtract(const Duration(days: 1)),
    );
    expect(moods, hasLength(1));
    expect(moods.single.reportedBand, 2);
    // Drift schedules zero-duration cleanup timers when stream providers
    // unmount; drain them before the pending-timer invariant check.
    await tester.pump(const Duration(milliseconds: 1));
    await disposeApp(tester);
  });

  testWidgets('a persisted record makes the headline personal on reopen', (
    tester,
  ) async {
    await db.moduleDao.insertMood(
      MoodLogCompanion.insert(ts: DateTime.now(), reportedBand: 2, estimated: 0.4),
    );
    await pumpModuleWidget(
      tester,
      db: db,
      child: SingleChildScrollView(child: MindStateCard()),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(MindStateCard)),
    )!;
    expect(find.text(l10n.mindNoDataYet), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await disposeApp(tester);
  });
}
