import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../domain/progress_index.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../charts/score_gauge.dart';
import '../design/halen_components.dart';

/// The Progress Score, on the home screen (item 14).
///
/// The score is the one number that answers "am I getting better?", and it
/// lived on the Grafikler tab, below the fold. A critical indicator two taps
/// away is an indicator nobody watches. This is the compact form — the gauge,
/// its band and which way it moved this week — with the full breakdown one
/// tap further, in the status flow.
class ProgressScoreTile extends ConsumerWidget {
  const ProgressScoreTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final indices = ref.watch(indicesProvider).value;
    if (indices == null) {
      return const SizedBox.shrink();
    }

    final band = switch (indices.progress.band) {
      ProgressBand.starting => l10n.progressBandStarting,
      ProgressBand.onTrack => l10n.progressBandOnTrack,
      ProgressBand.strong => l10n.progressBandStrong,
      ProgressBand.veryStrong => l10n.progressBandVeryStrong,
    };
    final delta = indices.delta7d;
    final deltaLabel = delta > 0
        ? l10n.progressDeltaUp(delta)
        : delta < 0
            ? l10n.progressDeltaDown(-delta)
            : l10n.progressDeltaFlat;

    return HalenCard(
      emphasis: CardEmphasis.raised,
      onTap: () => Navigator.of(context).pushNamed(Routes.status),
      child: Row(
        children: [
          ScoreGauge(
            score: indices.progress.score,
            band: band,
            delta: delta,
            deltaLabel: deltaLabel,
            color: DataRole.progress.of(context),
            size: 152,
            semanticsLabel: '${l10n.progressScoreTitle} '
                '${indices.progress.score}, $band, $deltaLabel',
          ),
          const SizedBox(width: HalenSpace.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.progressScoreTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: HalenSpace.x1),
                Text(l10n.progressWindowLabel, style: theme.textTheme.bodySmall),
                const SizedBox(height: HalenSpace.x3),
                Text(
                  l10n.progressBehaviourNote,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
