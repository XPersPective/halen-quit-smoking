import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/harm_load.dart';
import '../../domain/progress_index.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/two_line_area_chart.dart';

/// The twin index card (module report §14.③): Progress Score on the left,
/// Harm Load on the right, arrows pointing in opposite directions, and the
/// scissor chart underneath.
///
/// Rules honoured here: the TREND is printed before the absolute number,
/// each gauge opens its full component breakdown, and both carry the line
/// that stops them being read as medicine — "behaviour, not health" and
/// "not a disease risk estimate".
class IndicesCard extends ConsumerWidget {
  const IndicesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(indicesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: state.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(
            l10n.commonErrorTitle,
            style: theme.textTheme.bodyMedium,
          ),
          data: (indices) {
            final progressBand = switch (indices.progress.band) {
              ProgressBand.starting => l10n.progressBandStarting,
              ProgressBand.onTrack => l10n.progressBandOnTrack,
              ProgressBand.strong => l10n.progressBandStrong,
              ProgressBand.veryStrong => l10n.progressBandVeryStrong,
            };
            final harmBand = switch (indices.harm.band) {
              HarmBand.light => l10n.harmBandLight,
              HarmBand.moderate => l10n.harmBandModerate,
              HarmBand.heavy => l10n.harmBandHeavy,
              HarmBand.veryHeavy => l10n.harmBandVeryHeavy,
            };
            final delta = indices.delta7d;
            final deltaLabel = delta > 0
                ? l10n.progressDeltaUp(delta)
                : delta < 0
                    ? l10n.progressDeltaDown(-delta)
                    : l10n.progressDeltaFlat;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.indicesScissorTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.commonHowCalculated,
                      icon: const Icon(Icons.help_outline_rounded, size: 20),
                      onPressed: () =>
                          Navigator.of(context).pushNamed(Routes.howCalculated),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _Gauge(
                        title: l10n.progressScoreTitle,
                        subtitle: l10n.progressWindowLabel,
                        trend: deltaLabel,
                        score: indices.progress.score,
                        band: progressBand,
                        color: HalenColors.emerald,
                        rising: true,
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
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Gauge(
                        title: l10n.harmLoadTitle,
                        subtitle: l10n.harmPackYears(
                          indices.harm.packYears.toStringAsFixed(1),
                        ),
                        trend: l10n.harmNotRisk,
                        score: indices.harm.score,
                        band: harmBand,
                        color: HalenColors.textSecondaryLight,
                        rising: false,
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
                    ),
                  ],
                ),
                if (indices.progressHistory.length >= 2) ...[
                  const SizedBox(height: 20),
                  Text(
                    l10n.indicesScissorNote,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  TwoLineAreaChart(
                    upper: [
                      for (final v in indices.progressHistory) v.toDouble(),
                    ],
                    lower: [for (final v in indices.harmHistory) v.toDouble()],
                    upperColor: HalenColors.emerald,
                    lowerColor: HalenColors.textSecondaryLight,
                    height: 150,
                    semanticsLabel:
                        '${l10n.progressScoreTitle} ${indices.progress.score}, '
                        '${l10n.harmLoadTitle} ${indices.harm.score}',
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  l10n.progressBehaviourNote,
                  style: theme.textTheme.labelSmall,
                ),
              ],
            );
          },
        ),
      ),
    );
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
          child: Padding(
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
                    padding: const EdgeInsets.only(bottom: 12),
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

class _Gauge extends StatelessWidget {
  const _Gauge({
    required this.title,
    required this.subtitle,
    required this.trend,
    required this.score,
    required this.band,
    required this.color,
    required this.rising,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String trend;
  final int score;
  final String band;
  final Color color;

  /// Which way this index should move — the two arrows point opposite ways
  /// on purpose, and that contrast is the point of the card.
  final bool rising;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: '$title $score, $band',
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.labelLarge),
              Text(subtitle, style: theme.textTheme.labelSmall),
              const SizedBox(height: 10),
              // Trend before the absolute number (chart rule 3).
              Row(
                children: [
                  Icon(
                    rising
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trend,
                      style: theme.textTheme.labelSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '$score',
                style: theme.textTheme.displaySmall?.copyWith(color: color),
              ),
              Text(band, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
