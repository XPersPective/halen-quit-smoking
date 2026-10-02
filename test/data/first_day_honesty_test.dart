import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/module_providers.dart';
import 'package:halen/data/repositories/record_repository.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/presentation/widgets/today/progress_score_tile.dart';
import 'package:halen/presentation/widgets/today/spend_card.dart';

import '../helpers/pump_app.dart';

/// The owner's first real session (2026-10-02): four cigarettes in a row on
/// day one produced "tasarruf 78 TL", a "78, strong" score and an
/// environment card claiming hundreds of butts spared. None of that may come
/// back.
void main() {
  testWidgets('day one: no score is shown, calibration is, and spend is real',
      (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final db = await seedOnboardedProfile();
    final repo = RecordRepository(db);
    final base = DateTime.now().subtract(const Duration(minutes: 20));
    for (var i = 0; i < 4; i++) {
      await repo.logCigarette(
        source: RecordSource.app,
        at: base.add(Duration(minutes: i * 4)),
      );
    }

    await pumpModuleWidget(
      tester,
      db: db,
      child: const Column(children: [ProgressScoreTile(), SpendCard()]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Calibrating'), findsOneWidget);
    expect(find.text('0 of 3 days'), findsOneWidget);
    // Today: 4 cigarettes at 5 per cigarette.
    expect(find.textContaining('Today: 4 cigarettes'), findsOneWidget);

    // Same providers the UI settled on: nothing is saved on a day in progress.
    final container =
        ProviderScope.containerOf(tester.element(find.byType(SpendCard)));
    expect((await container.read(savingsLedgerProvider.future)).avoided, 0);
    expect(await container.read(totalSavingsProvider.future), 0);

    await disposeApp(tester);
    await db.close();
  });
}
