import 'package:flutter/material.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

class TriggerBreakdownCard extends StatelessWidget {
  const TriggerBreakdownCard({super.key, required this.triggers});

  final List<TriggerStatItem> triggers;

  // One calm color family — rank shades, never alarm colors (report §12.1).
  static const _familyColors = [
    HalenColors.petrol,
    HalenColors.emerald,
    HalenColors.skyBlue,
    HalenColors.purple,
    HalenColors.emerald,
    HalenColors.petrol,
  ];

  IconData _triggerIcon(String key) {
    return switch (key.toLowerCase()) {
      'coffee' => Icons.coffee_rounded,
      'aftermeal' => Icons.restaurant_rounded,
      'stress' => Icons.bolt_rounded,
      'alcohol' => Icons.local_bar_rounded,
      'car' => Icons.directions_car_rounded,
      'social' => Icons.people_alt_rounded,
      'workbreak' => Icons.work_history_rounded,
      'beforesleep' => Icons.bedtime_rounded,
      'wakeup' => Icons.wb_sunny_rounded,
      _ => Icons.label_outline_rounded,
    };
  }

  String _triggerTitle(String key, AppLocalizations l10n) {
    return switch (key.toLowerCase()) {
      'coffee' => l10n.triggerCoffee,
      'triggerAfterMeal' => l10n.triggerAfterMeal,
      'aftermeal' => l10n.triggerAfterMeal,
      'stress' => l10n.triggerStress,
      'alcohol' => l10n.triggerAlcohol,
      'car' => l10n.triggerCar,
      'social' => l10n.triggerSocial,
      'workbreak' => l10n.triggerWorkBreak,
      'beforesleep' => l10n.triggerBeforeSleep,
      'wakeup' => l10n.triggerWakeUp,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(HalenSpace.x3),
                  decoration: BoxDecoration(
                    color: HalenColors.amberCta.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    color: HalenColors.amberCta,
                    size: 20,
                  ),
                ),
                const SizedBox(width: HalenSpace.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.triggerTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: HalenSpace.x1),
                      Text(
                        l10n.triggerSubtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x5),

            if (triggers.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: HalenSpace.x6),
                  child: Text(
                    l10n.chartTriggerEmpty,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ] else ...[
              for (var i = 0; i < triggers.length; i++) ...[
                () {
                  final t = triggers[i];
                  final color =
                      _familyColors[i % _familyColors.length];
                  final pctInt = (t.percentage * 100).round();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(HalenSpace.x2),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _triggerIcon(t.triggerKey),
                                size: 15,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: HalenSpace.x3),
                            Expanded(
                              child: Text(
                                _triggerTitle(t.triggerKey, l10n),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: HalenSpace.x2),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  l10n.triggerOccurrences(t.count, pctInt),
                                  style: theme.textTheme.labelSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: HalenSpace.x2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: LinearProgressIndicator(
                            value: t.percentage,
                            minHeight: 8,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
