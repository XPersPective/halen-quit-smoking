import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:halen/application/interval_providers.dart';
import 'package:halen/application/plan_controller.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

class TodayLogCard extends ConsumerWidget {
  const TodayLogCard({super.key});

  IconData _triggerIcon(String? key) {
    if (key == null) return Icons.smoking_rooms_rounded;
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
      _ => Icons.smoking_rooms_rounded,
    };
  }

  String _triggerLabel(String? key, AppLocalizations l10n) {
    if (key == null) return 'Sigara';
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

  Future<void> _deleteRecord(
    BuildContext context,
    WidgetRef ref,
    int id,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCigaretteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: HalenColors.coral),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final db = ref.read(databaseProvider);
      await db.recordDao.deleteEvent(id);
      ref.invalidate(todayStateProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deletedCigaretteSuccess)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reportAsync = ref.watch(todayIntervalsProvider);

    return reportAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (report) {
        final items = report.items.reversed.toList(); // Newest first

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(HalenSpace.x5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(HalenSpace.x2),
                      decoration: BoxDecoration(
                        color: HalenColors.emerald.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.history_edu_rounded,
                        color: HalenColors.emerald,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: HalenSpace.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.todayLogTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            l10n.todayLogSubtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? HalenColors.textSecondaryDark
                                  : HalenColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (items.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${items.length} adet',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: HalenSpace.x4),

                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: HalenSpace.x4),
                    child: Center(
                      child: Text(
                        l10n.todayLogEmpty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? HalenColors.textSecondaryDark
                              : HalenColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 16,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final timeStr =
                          '${item.time.hour.toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')}';
                      final gap = item.gapFromPrevious;
                      final gapStr = gap != null
                          ? (gap.inHours > 0
                              ? '+${gap.inHours} sa ${gap.inMinutes % 60} dk sonra'
                              : '+${gap.inMinutes} dk sonra')
                          : 'Günün ilki';

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(HalenSpace.x2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? HalenColors.surfaceElevatedDark
                                  : HalenColors.surfaceElevatedLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _triggerIcon(item.triggerId),
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: HalenSpace.x3),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timeStr,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                gapStr,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: HalenColors.skyBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (item.triggerId != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: HalenColors.amberCta.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _triggerLabel(item.triggerId, l10n),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.amber[200] : Colors.amber[900],
                                ),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                            color: HalenColors.coral,
                            tooltip: 'Sil',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _deleteRecord(
                              context,
                              ref,
                              item.id,
                              l10n,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
