import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../domain/cessation.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../design/halen_components.dart';

/// Lapse versus relapse, taught at the moment it matters (premium brief §C.3).
///
/// The app already handled a cigarette without blame, which is right and is
/// not enough. Marlatt's finding is that what decides the next week is how
/// the person *reads* the slip: as one event, or as proof the attempt is
/// over. People who read it the second way abandon the attempt.
///
/// A silence after a slip does not stay neutral — it gets filled by the
/// user's own worst reading. So the app names what happened, in three
/// escalating states, and each one ends with a concrete next move rather
/// than reassurance.
class SlipCoachCard extends ConsumerWidget {
  const SlipCoachCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final verdict = ref.watch(slipVerdictProvider);

    if (verdict == SlipVerdict.none) {
      return const SizedBox.shrink();
    }

    final (title, body, action) = switch (verdict) {
      SlipVerdict.lapse => (l10n.slipTitle, l10n.slipBody, l10n.slipAction),
      SlipVerdict.clustering => (
          l10n.slipClusteringTitle,
          l10n.slipClusteringBody,
          l10n.slipAction,
        ),
      SlipVerdict.relapse => (
          l10n.slipRelapseTitle,
          l10n.slipRelapseBody,
          null,
        ),
      SlipVerdict.none => ('', '', null),
    };

    return HalenCard(
      emphasis: CardEmphasis.raised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: title),
          const SizedBox(height: HalenSpace.x2),
          Text(body, style: theme.textTheme.bodyMedium),
          if (action != null) ...[
            const SizedBox(height: HalenSpace.x3),
            Container(
              padding: const EdgeInsets.all(HalenSpace.x3),
              decoration: BoxDecoration(
                color: DataRole.progress.containerOf(context),
                borderRadius: HalenRadius.smallAll,
              ),
              child: Text(action, style: theme.textTheme.bodyMedium),
            ),
          ],
          const SizedBox(height: HalenSpace.x4),
          Wrap(
            spacing: HalenSpace.x2,
            runSpacing: HalenSpace.x2,
            children: [
              // Clustering and relapse are exactly where medicine helps most,
              // so that is the offer — not another motivational line.
              if (verdict != SlipVerdict.lapse)
                FilledButton.tonal(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.medicines),
                  child: Text(l10n.slipSeeMedicines),
                ),
              if (verdict == SlipVerdict.relapse)
                OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.quitPlan),
                  child: Text(l10n.slipSetNewDate),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
