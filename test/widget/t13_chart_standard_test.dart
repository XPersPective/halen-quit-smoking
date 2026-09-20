import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/charts/halen_line_chart.dart';

import '../helpers/pump_app.dart';

void main() {
  Future<AppLocalizations> pumpL10n(WidgetTester tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return l10n;
  }

  Widget host(Widget child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      );

  testWidgets('line chart: meaning sentence + semantics + empty state', (
    tester,
  ) async {
    final l10n = await pumpL10n(tester);
    await tester.pumpWidget(host(
      HalenLineChart(
        meaning: l10n.mindMeaning,
        semanticsLabel: l10n.mindAccuracyChartTitle,
        minY: 0,
        maxY: 100,
        series: const [],
        xLabels: const [],
      ),
    ));
    await tester.pumpAndSettle();
    // The meaning sentence stands above the picture — a number without it
    // is a decoration (chart standard, brain T13).
    expect(find.text(l10n.mindMeaning), findsOneWidget);
    // No data: an explicit empty state, never a fake flat line.
    expect(find.text(l10n.chartNoData), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('populated chart exposes a semantics label', (tester) async {
    final l10n = await pumpL10n(tester);
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(host(
      Semantics(
        label: l10n.mindAccuracyChartTitle,
        child: HalenLineChart(
          meaning: l10n.mindMeaning,
          semanticsLabel: l10n.mindAccuracyChartTitle,
          minY: 0,
          maxY: 100,
          series: const [
            ChartSeries(name: 'guess', color: Color(0xFF4477AA), values: [1, 2]),
            ChartSeries(name: 'felt', color: Color(0xFF228833), values: [2, 1]),
          ],
          xLabels: const ['d1', 'd2'],
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            (w.properties.label?.contains(l10n.mindAccuracyChartTitle) ??
                false),
      ),
      findsWidgets,
    );
    semantics.dispose();
    await disposeApp(tester);
  });
}
