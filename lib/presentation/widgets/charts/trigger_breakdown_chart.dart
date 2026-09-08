import 'package:flutter/material.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

class TriggerBreakdownCard extends StatelessWidget {
  const TriggerBreakdownCard({
    super.key,
    required this.triggers,
  });

  final List<TriggerStatItem> triggers;

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

  Color _triggerColor(int index) {
    const palette = [
      HalenColors.amberCta,
      HalenColors.emerald,
      HalenColors.skyBlue,
      HalenColors.purple,
      HalenColors.coral,
      Color(0xFFF97316),
      Color(0xFF06B6D4),
    ];
    return palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HalenColors.amberCta.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.psychology_alt_rounded,
                    color: HalenColors.amberCta,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.triggerTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.triggerSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? HalenColors.textSecondaryDark
                              : HalenColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (triggers.isEmpty) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Henüz tetikleyici verisi kaydedilmedi. Kayıt sırasında etiket ekleyerek tetikleyici desenlerini görebilirsin.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? HalenColors.textSecondaryDark
                          : HalenColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ] else ...[
              for (var i = 0; i < triggers.length; i++) ...[
                () {
                  final t = triggers[i];
                  final color = _triggerColor(i);
                  final pctInt = (t.percentage * 100).round();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(_triggerIcon(t.triggerKey), size: 16, color: color),
                            const SizedBox(width: 8),
                            Text(
                              _triggerTitle(t.triggerKey, l10n),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              l10n.triggerOccurrences(t.count, pctInt),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? HalenColors.textSecondaryDark
                                    : HalenColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: t.percentage,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? HalenColors.surfaceElevatedDark
                                : HalenColors.surfaceElevatedLight,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
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
