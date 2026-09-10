import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/providers.dart';
import '../../core/theme.dart';
import '../../domain/body_load_model.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/halen_line_chart.dart';
import '../../core/design/tokens.dart';

/// The quit-day card (module report §1.③).
///
/// The deliberate inversion: on the day someone stops, the hero is NOT the
/// nicotine curve — that one only tells them how much craving is coming.
/// Carbon monoxide is the fastest measurable thing to improve, so the first
/// days lead with the curve that is already going the right way.
///
/// It appears only in the first three days after a quit date and is labelled
/// "typical": this is the published decay shape, not a reading from a body.
class QuitDayCoCard extends ConsumerWidget {
  const QuitDayCoCard({super.key});

  /// Days after the quit date during which the card is shown.
  static const visibleDays = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final quitTs = ref.watch(timelineStateProvider).value;
    if (quitTs == null) {
      return const SizedBox.shrink();
    }
    final elapsed = DateTime.now().difference(quitTs);
    if (elapsed.isNegative || elapsed.inDays >= visibleDays) {
      return const SizedBox.shrink();
    }

    final model = ref.watch(bodyLoadModelProvider);
    final curve = model.quitDecayCurve(LoadKind.carbonMonoxide);
    final now = elapsed.inHours.clamp(0, curve.length - 1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.quitDayCoTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: HalenSpace.x1),
            Text(
              '${l10n.loadCarbonMonoxide} · ${100 - curve[now]}%',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: HalenColors.skyBlue,
              ),
            ),
            const SizedBox(height: HalenSpace.x3),
            HalenLineChart(
              meaning: l10n.quitDayCoBody,
              minY: 0,
              maxY: 100,
              height: 150,
              yFormatter: (v) => '${v.round()}%',
              series: [
                ChartSeries(
                  name: l10n.loadCarbonMonoxide,
                  color: HalenColors.skyBlue,
                  fill: true,
                  values: [for (final v in curve) v.toDouble()],
                ),
              ],
              xLabels: [
                l10n.quitDayHoursAxis(0),
                l10n.quitDayHoursAxis((curve.length - 1) ~/ 2),
                l10n.quitDayHoursAxis(curve.length - 1),
              ],
              semanticsLabel: '${l10n.quitDayCoTitle}: ${100 - curve[now]}%',
            ),
            const SizedBox(height: HalenSpace.x3),
            Text(l10n.moduleModelTag, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
