import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/environment_providers.dart';
import '../../core/design/data_palette.dart';
import '../../core/design/tokens.dart';
import '../../domain/environment_impact.dart';
import '../../l10n/generated/app_localizations.dart';
import 'design/halen_components.dart';

/// What stopping gives back to the planet (device feedback, item 10).
///
/// The successful models here — Forest, Ecosia, the "plant a tree when you
/// hit a goal" apps — work because the reward is outside the person: a real
/// tree, not points. Halen has no server and takes no money, so it cannot
/// plant on anyone's behalf. What it can do honestly:
///
///  * turn every cigarette not smoked into its sourced environmental
///    equivalent — trees not cut down, filters not littered;
///  * show what the person's own savings would plant;
///  * open verified planting organisations directly, with no cut and no
///    tracking.
///
/// A real partnership (the app funding a tree per milestone) is a business
/// decision with contracts and payments, and is deliberately not faked here.
class EnvironmentCard extends ConsumerWidget {
  const EnvironmentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final view = ref.watch(environmentProvider).value;
    if (view == null || view.impact.cigarettesAvoided <= 0) {
      return const SizedBox.shrink();
    }
    final impact = view.impact;
    final trees = impact.trees;
    final saplings = EnvironmentImpact.saplingsFor(view.saved);

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: l10n.envTitle),
          const SizedBox(height: HalenSpace.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HalenStat(
                  label: l10n.envTreesLabel,
                  value: l10n.envTrees(
                    trees >= 10
                        ? trees.toStringAsFixed(0)
                        : trees.toStringAsFixed(1),
                  ),
                  color: DataRole.progress.of(context),
                ),
              ),
              const SizedBox(width: HalenSpace.x3),
              Expanded(
                child: HalenStat(
                  label: l10n.envFiltersLabel,
                  value: l10n.envButts(impact.filters),
                  color: DataRole.progress.of(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(l10n.envBasis, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x5),
          Text(l10n.envPlantTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: HalenSpace.x1),
          Text(l10n.envPlantBody, style: theme.textTheme.bodySmall),
          if (saplings > 0) ...[
            const SizedBox(height: HalenSpace.x2),
            Text(
              l10n.envSavedCovers(saplings),
              style: theme.textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: HalenSpace.x3),
          Wrap(
            spacing: HalenSpace.x2,
            runSpacing: HalenSpace.x2,
            children: [
              for (final partner in plantingPartners)
                OutlinedButton.icon(
                  icon: const Icon(Icons.park_outlined, size: 18),
                  label: Text(partner.name),
                  onPressed: () async {
                    final ok = await launchUrl(
                      Uri.parse(partner.url),
                      mode: LaunchMode.externalApplication,
                    );
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.envOpenFailed)),
                      );
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
