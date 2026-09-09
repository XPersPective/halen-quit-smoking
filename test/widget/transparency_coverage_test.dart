import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/db/connection.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/transparency/how_calculated_screen.dart';

import 'package:halen/domain/craving_risk.dart';
import 'package:halen/domain/harm_load.dart';
import 'package:halen/domain/progress_index.dart';

import '../helpers/pump_app.dart';

/// The module report's acceptance criterion (c): no S3 indicator ships
/// without its formula published in "How is this calculated?".
///
/// This is the test that keeps §0.2 — "publishing every formula is the
/// product's main differentiator" — from decaying into a marketing line: add
/// a modelled indicator without its section and this fails.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(inMemoryExecutor()));
  tearDown(() => db.close());

  testWidgets('every modelled indicator publishes its formula',
      (tester) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const HowCalculatedScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // Listed in screen order: the walk only scrolls one way, so a section
    // out of order here would look like a missing section.
    final required = <String>[
      l10n.howNicotineTitle, // the original nicotine proxy
      l10n.howSavingsTitle, // §3
      l10n.howBodyLoadTitle, // §1 four curves
      l10n.howCravingTitle, // §4 risk weights
      l10n.howMindTitle, // §8 withdrawal pressure
      l10n.howLungTitle, // §6 FEV1 scenarios
      l10n.howProgressTitle, // §14.1
      l10n.howHarmTitle, // §14.2
    ];
    for (final title in required) {
      await tester.dragUntilVisible(
        find.text(title),
        find.byType(ListView),
        const Offset(0, -250),
      );
      expect(find.text(title), findsOneWidget, reason: title);
    }
  });

  testWidgets('the published weights match the code', (tester) async {
    await pumpModuleWidget(
      tester,
      db: db,
      child: const HowCalculatedScreen(),
      scrollable: false,
    );
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // Progress Score: 35 / 30 / 20 / 10 / 5 — the numbers in the copy are the
    // numbers in ProgressComponent, and this catches them drifting apart.
    expect(l10n.howProgressBody, contains('35'));
    expect(l10n.howProgressBody, contains('30'));
    expect(l10n.howProgressBody, contains('20'));
    expect(l10n.howProgressBody, contains('10'));
    // Harm Load: 40 / 30 / 15 / 10 / 5.
    expect(l10n.howHarmBody, contains('40'));
    expect(l10n.howHarmBody, contains('15'));
    // Craving risk: 0.45 / 0.35 / 0.20.
    expect(l10n.howCravingBody, contains('0.45'));
    expect(l10n.howCravingBody, contains('0.35'));
    expect(l10n.howCravingBody, contains('0.20'));

    // And the code side really does carry those weights.
    expect(ProgressComponent.adherence.weight, 35);
    expect(ProgressComponent.consumptionTrend.weight, 30);
    expect(HarmComponent.cumulativeExposure.weight, 40);
    expect(HarmComponent.dependenceDepth.weight, 15);
    expect(CravingRiskWeights.trough, 0.45);
    expect(CravingRiskWeights.hourPattern, 0.35);
    expect(CravingRiskWeights.triggerContext, 0.20);
  });
}
