import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../body_map_view.dart';
import '../design/halen_components.dart';

/// Mini Organ Cockpit for the Today home screen (Faz A.4).
///
/// Brings organ recovery out of the hidden sub-screens directly onto the
/// main dashboard, giving positive scientific reinforcement for each
/// smoke-free hour.
class MiniOrganCockpit extends ConsumerWidget {
  const MiniOrganCockpit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final organs = ref.watch(libraryRepositoryProvider).organs();

    final spotlightKeys = ['lungs', 'heart', 'brain', 'bloodVessels'];
    final spotlightOrgans = [
      for (final key in spotlightKeys)
        for (final o in organs.where((entry) => entry.key == key)) o,
    ];

    return HalenCard(
      emphasis: CardEmphasis.raised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.organMapTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: HalenSpace.x1),
                    Text(
                      l10n.organRecoveryTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: HalenColors.emerald,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: TextButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed(Routes.body),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  iconAlignment: IconAlignment.end,
                  label: Text(
                    l10n.statusOpen,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          Wrap(
            spacing: HalenSpace.x3,
            runSpacing: HalenSpace.x3,
            children: [
              for (final organ in spotlightOrgans)
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(
                      Routes.body,
                      arguments: organ.key,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: LayoutBuilder(
                    builder: (context, card) => Container(
                    width: (card.maxWidth - HalenSpace.x3) / 2,
                    padding: const EdgeInsets.all(HalenSpace.x3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    child: Row(
                      children: [
                        OrganGlyph(
                          organKey: organ.key,
                          color: HalenColors.emerald,
                          size: const Size(36, 36),
                          animate: false,
                        ),
                        const SizedBox(width: HalenSpace.x2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                organ.name(locale),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.organRecoveryTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: HalenColors.emerald,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
