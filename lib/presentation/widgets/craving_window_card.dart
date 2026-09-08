import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/craving_risk.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/week_heatmap.dart';

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
        padding: const EdgeInsets.all(20),
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
                      Navigator.of(context).pushNamed(Routes.howCalculated),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // The sentence first — the chart only supports it.
            Text(l10n.cravingFallingNote, style: theme.textTheme.bodyMedium),
            if (lowestThird != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.cravingLowestThird((lowestThird * 100).round()),
                style: theme.textTheme.titleSmall,
              ),
            ],
            const SizedBox(height: 16),

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
                const SizedBox(width: 12),
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
            const SizedBox(height: 16),

            Text(l10n.cravingHeatmapTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            if (!hasEnough)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
            const SizedBox(height: 12),
            Text(l10n.moduleModelTag, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
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
