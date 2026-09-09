import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/harm_load.dart';
import '../../domain/progress_index.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/halen_line_chart.dart';
import 'charts/score_gauge.dart';

/// The two indices (module report §14.③), rebuilt around how they are
/// actually read.
///
/// The first version put both numbers into small twin tiles above a bare
/// two-line chart, which asked the reader to decode a picture before they
/// could answer "am I doing well?". This version answers that first:
///
///  1. a gauge — a score out of a hundred is a fraction, and an arc is how
///     people read fractions at a glance;
///  2. a banded scale for the load, because a load only means something
///     against its bands;
///  3. only then the 30-day history, with a named legend, a real date axis,
///     a touch tooltip and a sentence saying which direction is the good one.
///
/// Both halves keep the lines that stop them being read as medicine.
class IndicesCard extends ConsumerWidget {
  const IndicesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(indicesProvider);

    return state.when(
      // A quiet placeholder rather than a spinner: the card appears at the
      // size it will settle at, and nothing animates forever while a local
      // query runs.
      loading: () => ChartCard(
        title: l10n.indicesScissorTitle,
        child: SizedBox(
          height: 140,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(l10n.commonLoading, style: theme.textTheme.bodyMedium),
          ),
        ),
      ),
      error: (_, _) => ChartCard(
        title: l10n.indicesScissorTitle,
        child: Text(l10n.commonErrorTitle, style: theme.textTheme.bodyMedium),
      ),
      data: (indices) {
        final progressBand = switch (indices.progress.band) {
          ProgressBand.starting => l10n.progressBandStarting,
          ProgressBand.onTrack => l10n.progressBandOnTrack,
          ProgressBand.strong => l10n.progressBandStrong,
          ProgressBand.veryStrong => l10n.progressBandVeryStrong,
        };
        final harmBands = [
          l10n.harmBandLight,
          l10n.harmBandModerate,
          l10n.harmBandHeavy,
          l10n.harmBandVeryHeavy,
        ];
        final harmIndex = HarmBand.values.indexOf(indices.harm.band);
        final delta = indices.delta7d;
        final deltaLabel = delta > 0
            ? l10n.progressDeltaUp(delta)
            : delta < 0
            ? l10n.progressDeltaDown(-delta)
            : l10n.progressDeltaFlat;

        return Column(
          children: [
            // ——— 1. Am I doing well? ———
            ChartCard(
              title: l10n.progressScoreTitle,
              subtitle: l10n.progressWindowLabel,
              onHelp: () =>
                  Navigator.of(context).pushNamed(Routes.glossary),
              footnote: l10n.progressBehaviourNote,
              child: Column(
                children: [
                  Center(
                    child: ScoreGauge(
                      score: indices.progress.score,
                      band: progressBand,
                      delta: delta,
                      deltaLabel: deltaLabel,
                      color: HalenColors.emerald,
                      semanticsLabel:
                          '${l10n.progressScoreTitle} ${indices.progress.score}, '
                          '$progressBand, $deltaLabel',
                    ),
                  ),
                  const SizedBox(height: 4),
                  _BreakdownButton(
                    label: l10n.indicesBreakdownTitle,
                    onTap: () => _showBreakdown(
                      context,
                      title: l10n.progressScoreTitle,
                      note: l10n.progressBehaviourNote,
                      rows: [
                        for (final b in indices.progress.breakdown)
                          (
                            label: _progressLabel(b.component, l10n),
                            points: b.points,
                            weight: b.component.weight,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ——— 2. How much am I carrying? ———
            ChartCard(
              title: l10n.harmLoadTitle,
              subtitle: l10n.harmPackYears(
                indices.harm.packYears.toStringAsFixed(1),
              ),
              onHelp: () =>
                  Navigator.of(context).pushNamed(Routes.glossary),
              footnote: '${l10n.harmNotRisk} ${l10n.harmMovingPartNote}',
              child: Column(
                children: [
                  HarmScale(
                    score: indices.harm.score,
                    bandLabels: harmBands,
                    activeBand: harmIndex,
                    semanticsLabel:
                        '${l10n.harmLoadTitle} '
                        '${indices.harm.score}, ${harmBands[harmIndex]}',
                  ),
                  const SizedBox(height: 8),
                  _BreakdownButton(
                    label: l10n.indicesBreakdownTitle,
                    onTap: () => _showBreakdown(
                      context,
                      title: l10n.harmLoadTitle,
                      note: l10n.harmMovingPartNote,
                      rows: [
                        for (final b in indices.harm.breakdown)
                          (
                            label: _harmLabel(b.component, l10n),
                            points: b.points,
                            weight: b.component.weight,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ——— 3. Which way is it going? ———
            ChartCard(
              title: l10n.indicesScissorTitle,
              subtitle: l10n.chartLast30Days,
              child: indices.progressHistory.length < 2
                  ? Text(
                      l10n.chartNotEnoughYet,
                      style: theme.textTheme.bodyMedium,
                    )
                  : HalenLineChart(
                      meaning: l10n.indicesMeaning,
                      minY: 0,
                      maxY: 100,
                      series: [
                        ChartSeries(
                          name: l10n.indicesProgressLegend,
                          color: HalenColors.emerald,
                          values: [
                            for (final v in indices.progressHistory)
                              v.toDouble(),
                          ],
                          fill: true,
                        ),
                        ChartSeries(
                          name: l10n.indicesHarmLegend,
                          color: HalenColors.textSecondaryLight,
                          values: [
                            for (final v in indices.harmHistory) v.toDouble(),
                          ],
                        ),
                      ],
                      xLabels: _dayLabels(indices.progressHistory.length, l10n),
                      semanticsLabel:
                          '${l10n.progressScoreTitle} ${indices.progress.score}, '
                          '${l10n.harmLoadTitle} ${indices.harm.score}',
                    ),
            ),
          ],
        );
      },
    );
  }

  /// Three x-axis labels: the oldest day, the middle one, and "today".
  List<String> _dayLabels(int length, AppLocalizations l10n) {
    if (length < 2) {
      return const [];
    }
    return [
      l10n.chartDaysAgo(length - 1),
      l10n.chartDaysAgo((length - 1) ~/ 2),
      l10n.chartToday,
    ];
  }

  String _progressLabel(ProgressComponent c, AppLocalizations l10n) =>
      switch (c) {
        ProgressComponent.adherence => l10n.componentAdherence,
        ProgressComponent.consumptionTrend => l10n.componentConsumptionTrend,
        ProgressComponent.cravingCoping => l10n.componentCravingCoping,
        ProgressComponent.loggingConsistency =>
          l10n.componentLoggingConsistency,
        ProgressComponent.nicotineBaselineFall =>
          l10n.componentNicotineBaselineFall,
      };

  String _harmLabel(HarmComponent c, AppLocalizations l10n) => switch (c) {
    HarmComponent.cumulativeExposure => l10n.componentCumulativeExposure,
    HarmComponent.currentIntensity => l10n.componentCurrentIntensity,
    HarmComponent.dependenceDepth => l10n.componentDependenceDepth,
    HarmComponent.ageAndDuration => l10n.componentAgeAndDuration,
    HarmComponent.bodySize => l10n.componentBodySize,
  };

  void _showBreakdown(
    BuildContext context, {
    required String title,
    required String note,
    required List<({String label, double points, int weight})> rows,
  }) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  l10n.indicesBreakdownTitle,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                for (final row in rows)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(row.label)),
                            Text(
                              l10n.componentWeightLabel(
                                row.points.toStringAsFixed(0),
                                row.weight,
                              ),
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: row.weight == 0
                                ? 0
                                : (row.points / row.weight).clamp(0.0, 1.0),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Text(note, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BreakdownButton extends StatelessWidget {
  const _BreakdownButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.pie_chart_outline_rounded, size: 16),
        label: Text(label),
      ),
    );
  }
}
