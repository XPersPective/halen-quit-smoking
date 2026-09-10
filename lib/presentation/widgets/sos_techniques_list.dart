import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/record_providers.dart';
import '../../data/db/app_database.dart';
import '../../core/theme.dart';
import '../../data/repositories/library_repository.dart';
import '../../domain/entities.dart';
import '../../domain/evidence.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/design/tokens.dart';

/// The SOS toolkit (module report §5.③).
///
/// Two things make this different from every "tips" list in the category:
///  1. every technique wears its EVIDENCE GRADE, including the honest
///     "traditional, evidence mixed" badge on ear acupressure — telling the
///     truth about the weak options is what makes the strong ones credible;
///  2. the order is learned locally from what has actually worked for THIS
///     user, falling back to evidence strength (the five-minute walk first,
///     because it is the best-supported acute intervention there is).
class SosTechniquesList extends ConsumerWidget {
  const SosTechniquesList({super.key, this.onSelected});

  /// Called with the technique key when the user starts one, so the caller
  /// can record which technique was used with the craving outcome.
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final techniques = ref.watch(libraryRepositoryProvider).sosTechniques();
    final cravings = ref.watch(cravingEventsProvider).value ?? const [];

    final ordered = _orderByWhatWorked(techniques, cravings);
    final personalized = ordered.$2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              personalized ? l10n.sosWhatWorked : l10n.sosTechniquesTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: HalenSpace.x3),
            for (final technique in ordered.$1)
              _TechniqueTile(
                technique: technique,
                locale: locale,
                onTap: onSelected == null
                    ? null
                    : () => onSelected!(technique.key),
              ),
          ],
        ),
      ),
    );
  }

  /// Orders techniques by this user's own success rate, keeping the
  /// evidence-based order until there is enough local data to beat it.
  (List<SosTechnique>, bool) _orderByWhatWorked(
    List<SosTechnique> techniques,
    List<CravingEventRow> cravings,
  ) {
    final attempts = <String, int>{};
    final wins = <String, int>{};
    for (final craving in cravings) {
      final key = craving.techniqueKey;
      if (key == null) {
        continue;
      }
      attempts[key] = (attempts[key] ?? 0) + 1;
      if (craving.outcome == CravingOutcome.resisted) {
        wins[key] = (wins[key] ?? 0) + 1;
      }
    }
    // Below three observations a "success rate" is noise, not a signal.
    final usable = attempts.entries.where((e) => e.value >= 3).toList();
    if (usable.isEmpty) {
      return (techniques, false);
    }
    double score(SosTechnique t) {
      final tries = attempts[t.key] ?? 0;
      if (tries < 3) {
        return -1;
      }
      return (wins[t.key] ?? 0) / tries;
    }

    final sorted = [...techniques]
      ..sort((a, b) => score(b).compareTo(score(a)));
    return (sorted, true);
  }
}

class _TechniqueTile extends StatelessWidget {
  const _TechniqueTile({
    required this.technique,
    required this.locale,
    this.onTap,
  });

  final SosTechnique technique;
  final String locale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final (badge, color) = switch (technique.evidence) {
      EvidenceLevel.strong => (l10n.evidenceStrong, HalenColors.emerald),
      EvidenceLevel.promising => (l10n.evidencePromising, HalenColors.skyBlue),
      EvidenceLevel.traditional => (
          l10n.evidenceTraditional,
          HalenColors.textSecondaryLight,
        ),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(HalenSpace.x4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      technique.name(locale),
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: theme.textTheme.labelSmall?.copyWith(color: color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: HalenSpace.x2),
              Text(
                technique.instruction(locale),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: HalenSpace.x2),
              Text(
                '${l10n.evidenceLabel}: ${technique.evidenceNote(locale)}',
                style: theme.textTheme.labelSmall,
              ),
              if (technique.key == 'earAcupressure') ...[
                const SizedBox(height: HalenSpace.x2),
                Text(
                  '${l10n.sosEarPointsTitle} — '
                  '${[
                    l10n.sosEarPointShenMen,
                    l10n.sosEarPointAutonomic,
                    l10n.sosEarPointKidney,
                    l10n.sosEarPointLiver,
                    l10n.sosEarPointLung,
                  ].join(' · ')}',
                  style: theme.textTheme.labelSmall,
                ),
                Text(
                  l10n.sosNoNeedles,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
