import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/module_providers.dart';
import '../../application/record_providers.dart';
import '../../application/stats_providers.dart';
import '../../core/dates.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/entities.dart';
import '../../domain/evidence.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/design/tokens.dart';

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
        padding: const EdgeInsets.all(HalenSpace.x5),
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
            const SizedBox(height: HalenSpace.x3),
            Text(card.title(locale), style: theme.textTheme.titleMedium),
            const SizedBox(height: HalenSpace.x2),
            Text(card.body(locale), style: theme.textTheme.bodyMedium),
            if (card.action != null) ...[
              const SizedBox(height: HalenSpace.x4),
              Container(
                padding: const EdgeInsets.all(HalenSpace.x3),
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
                    const SizedBox(height: HalenSpace.x1),
                    Text(
                      card.action!(locale),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: HalenSpace.x3),
            const _MotivationLine(),
            const SizedBox(height: HalenSpace.x3),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.sources),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, size: 14),
                  const SizedBox(width: HalenSpace.x2),
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


/// The daily motivation line (module report §11.③).
///
/// The rule that keeps it out of fortune-cookie territory: it is ALWAYS
/// built from the user's own numbers. There is no generic "you can do it"
/// string in the catalogue, and when there is no data yet there is no line.
class _MotivationLine extends ConsumerWidget {
  const _MotivationLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final economy = ref.watch(economyProvider).value;
    final baseline = ref.watch(measuredBaselineProvider).value ?? 0;
    final stats = ref.watch(dailyStatsProvider(30)).value ?? const [];
    final cravings = ref.watch(cravingEventsProvider).value ?? const [];
    if (economy == null || stats.isEmpty) {
      return const SizedBox.shrink();
    }

    final monthStart = DateTime(DateTime.now().year, DateTime.now().month);
    final rides = cravings
        .where((c) =>
            c.outcome == CravingOutcome.resisted && c.ts.isAfter(monthStart))
        .length;
    final avoided = stats.fold<int>(
      0,
      (sum, d) => sum + math.max(0, (baseline - d.count).round()),
    );

    // Rotate between the lines the user actually has data for.
    final options = <String>[
      if (avoided > 0)
        l10n.motivationSaved(
          NumberFormat.currency(locale: locale, decimalDigits: 0)
              .format(economy.saved(avoided)),
        ),
      if (rides > 0) l10n.motivationRides(rides),
      if (avoided > 0)
        l10n.motivationTime(
          formatShortDuration(economy.timeRegained(avoided), locale),
        ),
    ];
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    final line = options[DateTime.now().day % options.length];

    return Row(
      children: [
        const Icon(Icons.auto_awesome_rounded, size: 14),
        const SizedBox(width: HalenSpace.x2),
        Expanded(child: Text(line, style: theme.textTheme.labelLarge)),
      ],
    );
  }
}
