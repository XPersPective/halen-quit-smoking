import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/record_providers.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/craving_risk.dart';
import '../../domain/entities.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/week_heatmap.dart';
import '../../core/design/tokens.dart';

/// Craving window card (module report §4.③).
///
/// It leads with the finding that makes the whole module land — craving
/// arrives while nicotine is FALLING — and then proves it from the user's
/// own records. Below a data threshold it says so instead of inventing a
/// pattern.
class CravingWindowCard extends ConsumerWidget {
  const CravingWindowCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final model = ref.watch(cravingRiskModelProvider).value;
    final windows = ref.watch(riskWindowsProvider).value ?? const [];
    final lowestThird = ref.watch(cravingsInLowestThirdProvider).value;
    final events = ref.watch(eventTimestampsProvider).value ?? const [];

    final risk = model?.riskAt(DateTime.now()) ?? 0;
    final band = riskBandFor(risk);
    final bandLabel = switch (band) {
      RiskBand.calm => l10n.cravingRiskCalm,
      RiskBand.watch => l10n.cravingRiskWatch,
      RiskBand.high => l10n.cravingRiskHigh,
    };
    final bandColor = switch (band) {
      RiskBand.calm => HalenColors.emerald,
      RiskBand.watch => HalenColors.amberCta,
      RiskBand.high => HalenColors.coral,
    };

    final counts = [
      for (var day = 0; day < 7; day++) List<int>.filled(24, 0),
    ];
    for (final event in events) {
      counts[event.weekday - 1][event.hour]++;
    }
    final hasEnough = model?.hasEnoughData ?? false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.cravingWindowTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l10n.commonHowCalculated,
                  icon: const Icon(Icons.help_outline_rounded, size: 20),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.glossary),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x1),

            // The sentence first — the chart only supports it.
            Text(l10n.cravingFallingNote, style: theme.textTheme.bodyMedium),
            if (lowestThird != null) ...[
              const SizedBox(height: HalenSpace.x2),
              Text(
                l10n.cravingLowestThird((lowestThird * 100).round()),
                style: theme.textTheme.titleSmall,
              ),
            ],
            const SizedBox(height: HalenSpace.x4),

            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bandColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bandLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: bandColor,
                    ),
                  ),
                ),
                const SizedBox(width: HalenSpace.x3),
                if (windows.isNotEmpty)
                  Expanded(
                    child: Text(
                      '${l10n.cravingRiskyHours}: '
                      '${windows.map((w) => l10n.cravingWindowRange(w.startHour, w.endHour)).join(', ')}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: HalenSpace.x4),

            // A risk number on its own is a warning; the report's rule is
            // that it must open a door instead. The suggestion is the
            // technique that has actually worked for this user, falling back
            // to the best-supported one.
            if (windows.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(HalenSpace.x4),
                decoration: BoxDecoration(
                  color: HalenColors.emerald.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cravingWhatToDo,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: HalenColors.petrol,
                      ),
                    ),
                    const SizedBox(height: HalenSpace.x1),
                    Text(
                      l10n.cravingSuggestionAt(
                        '${windows.first.startHour}:00',
                        _suggestedTechnique(ref, context),
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: HalenSpace.x2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.tonal(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(Routes.cravingSos),
                        child: Text(l10n.cravingOpenToolkit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: HalenSpace.x4),
            ],

            Text(l10n.cravingHeatmapTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: HalenSpace.x2),
            if (!hasEnough)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: HalenSpace.x4),
                child: Text(
                  l10n.moduleNeedMoreData,
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              WeekHeatmap(
                counts: counts,
                color: HalenColors.petrol,
                dayLabels: _dayLabels(context),
                semanticsLabel: windows.isEmpty
                    ? l10n.cravingHeatmapTitle
                    : '${l10n.cravingRiskyHours}: '
                        '${windows.map((w) => l10n.cravingWindowRange(w.startHour, w.endHour)).join(', ')}',
              ),
            const SizedBox(height: HalenSpace.x3),
            Text(l10n.moduleModelTag, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  /// The technique to offer for the next risky window: whatever has worked
  /// for this user at least three times, else the best-supported one.
  String _suggestedTechnique(WidgetRef ref, BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final techniques = ref.watch(libraryRepositoryProvider).sosTechniques();
    final cravings = ref.watch(cravingEventsProvider).value ?? const [];
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
    final proven = attempts.entries
        .where((e) => e.value >= 3)
        .toList()
      ..sort((a, b) => ((wins[b.key] ?? 0) / b.value)
          .compareTo((wins[a.key] ?? 0) / a.value));
    final key = proven.isEmpty ? techniques.first.key : proven.first.key;
    return techniques
        .firstWhere((t) => t.key == key, orElse: () => techniques.first)
        .name(locale);
  }

  /// Localized narrow weekday names, Monday first (matching DateTime.weekday).
  List<String> _dayLabels(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode.toLowerCase();
    if (locale.startsWith('tr')) {
      return const ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    }
    if (locale.startsWith('de')) {
      return const ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    }
    return const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }
}
