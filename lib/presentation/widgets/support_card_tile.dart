import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/providers.dart';
import '../../core/dates.dart';
import '../../core/theme.dart';
import '../../domain/evidence.dart';
import '../../l10n/generated/app_localizations.dart';

/// Today's support card (module report §10.③): one card a day, one channel,
/// fifteen seconds to read, one tap to tick off — and skipping costs nothing,
/// which the card says out loud.
///
/// The herbal card is deliberately included AND deliberately graded
/// "traditional": users go looking for it, and the honest label is what keeps
/// the rest of the app's claims believable.
class SupportCardTile extends ConsumerWidget {
  const SupportCardTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final entry = ref.watch(supportCardProvider).value;

    if (entry == null) {
      return const SizedBox.shrink();
    }
    final card = entry.card;
    final channelLabel = switch (card.channel) {
      SupportChannel.movement => l10n.supportChannelMovement,
      SupportChannel.nutrition => l10n.supportChannelNutrition,
      SupportChannel.ritual => l10n.supportChannelRitual,
    };
    final (badge, color) = switch (card.evidence) {
      EvidenceLevel.strong => (l10n.evidenceStrong, HalenColors.emerald),
      EvidenceLevel.promising => (l10n.evidencePromising, HalenColors.skyBlue),
      EvidenceLevel.traditional => (
          l10n.evidenceTraditional,
          HalenColors.textSecondaryLight,
        ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.supportTitle,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                Text(
                  '$channelLabel · ${l10n.supportMinutes(card.durationMinutes)}',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(card.title(locale), style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(card.body(locale), style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
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
                    badge,
                    style: theme.textTheme.labelSmall?.copyWith(color: color),
                  ),
                ),
                const Spacer(),
                if (entry.done)
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: HalenColors.emerald,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.commonDone,
                        style: theme.textTheme.labelMedium,
                      ),
                    ],
                  )
                else
                  FilledButton.tonal(
                    onPressed: () async {
                      await ref.read(databaseProvider).moduleDao.setSupportDone(
                            dayKey(DateTime.now()),
                            card.key,
                          );
                      ref.invalidate(supportCardProvider);
                    },
                    child: Text(l10n.supportMarkDone),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(l10n.supportNotATest, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
