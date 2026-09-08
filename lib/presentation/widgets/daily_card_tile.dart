import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/evidence.dart';
import '../../l10n/generated/app_localizations.dart';

/// Today's card from the content engine (module report §11).
///
/// The visible half of the fear-plus-efficacy rule: a "hard part" card is
/// drawn in charcoal, never in red, and its action block is always present —
/// the model that produces these cards refuses to build one without it.
class DailyCardTile extends ConsumerWidget {
  const DailyCardTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final card = ref.watch(dailyCardProvider).value;
    if (card == null) {
      return const SizedBox.shrink();
    }

    final (label, color) = switch (card.family) {
      ContentFamily.knowledge => (l10n.dailyCardKnowledge, HalenColors.skyBlue),
      ContentFamily.reality => (
          l10n.dailyCardReality,
          HalenColors.textSecondaryLight,
        ),
      ContentFamily.gain => (l10n.dailyCardGain, HalenColors.emerald),
      ContentFamily.motivation => (l10n.dailyCardMotivation, HalenColors.purple),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(color: color),
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.dailyCardReadMinutes(card.readMinutes),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(card.title(locale), style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(card.body(locale), style: theme.textTheme.bodyMedium),
            if (card.action != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: HalenColors.emerald.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyCardAction,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: HalenColors.petrol,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.action!(locale),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.sources),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${l10n.moduleSourceLabel}: ${card.sourceLabel}',
                      style: theme.textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
