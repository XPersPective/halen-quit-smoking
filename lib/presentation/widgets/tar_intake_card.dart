import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/pack_providers.dart';
import '../../core/design/data_palette.dart';
import '../../core/design/tokens.dart';
import '../../domain/tar_intake.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/halen_bar_chart.dart';
import 'design/halen_components.dart';

/// Tar taken in, weekly, in something a person can picture (item 4).
///
/// "Tar build-up, 71%" means nothing to anybody. "About half a tea spoon of
/// tar this week" is something you can see in your hand. The figure comes
/// from the user's own count times their pack label's tar yield, and the card
/// says plainly that it is a floor and how the spoon was worked out.
class TarIntakeCard extends ConsumerWidget {
  const TarIntakeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final intake = ref.watch(tarIntakeProvider);
    final weekly = ref.watch(weeklyTarProvider);
    final events = ref.watch(eventTimestampsProvider).value ?? const [];
    final now = DateTime.now();
    final month = intake.tarGrams(
      events.where((e) => e.isAfter(now.subtract(const Duration(days: 30)))).length,
    );

    if (weekly.every((g) => g == 0)) {
      return HalenCard(
        child: HalenEmptyState(
          icon: Icons.opacity_rounded,
          message: l10n.bodyLoadEmpty,
        ),
      );
    }

    final thisWeek = weekly.last;
    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: l10n.tarTitle),
          const SizedBox(height: HalenSpace.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HalenStat(
                  label: l10n.tarThisWeek,
                  value: l10n.tarGrams(_grams(thisWeek)),
                  caption: _picture(l10n, thisWeek),
                  color: DataRole.particle.of(context),
                  large: true,
                ),
              ),
              const SizedBox(width: HalenSpace.x3),
              Expanded(
                child: HalenStat(
                  label: l10n.tarThisMonth,
                  value: l10n.tarGrams(_grams(month)),
                  caption: _picture(l10n, month),
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x5),
          HalenBarChart(
            values: weekly,
            labels: [
              for (var i = weekly.length - 1; i >= 1; i--) l10n.tarWeekShort(i),
              l10n.tarThisWeekShort,
            ],
            meaning: l10n.tarChartMeaning,
            axisCaption: l10n.tarChartAxis,
            color: DataRole.particle.of(context),
            // Enough decimals for the step: a light week's axis runs in
            // hundredths, and one decimal printed 0.1, 0.1, 0.0.
            yFormatter: (v) => weekly.reduce((a, b) => a > b ? a : b) < 1
                ? v.toStringAsFixed(2)
                : _grams(v),
            yLabelWidth: 44,
            semanticsLabel:
                '${l10n.tarTitle}: ${l10n.tarGrams(_grams(thisWeek))}',
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(
            l10n.tarBasis(_mg(intake.tarMgPerCigarette)),
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: HalenSpace.x1),
          Text(l10n.tarSpoonNote, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  static String _grams(double g) =>
      g >= 10 ? g.toStringAsFixed(0) : g.toStringAsFixed(1);

  static String _mg(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  static String _picture(AppLocalizations l10n, double grams) {
    final picture = TarIntake.picture(grams);
    final measure = switch (picture.measure) {
      Measure.teaSpoon => l10n.measureTeaSpoon,
      Measure.dessertSpoon => l10n.measureDessertSpoon,
      Measure.tableSpoon => l10n.measureTableSpoon,
      Measure.waterGlass => l10n.measureWaterGlass,
      Measure.drop => l10n.measureDrop,
    };
    final count = picture.count;
    // Drops are counted whole; spoons and glasses read best in halves. Never
    // round down to zero: something was taken in, and "0" says it was not.
    final String shown;
    if (picture.measure == Measure.drop) {
      shown = count.round().clamp(1, 1 << 30).toString();
    } else {
      final halves = ((count * 2).roundToDouble() / 2).clamp(0.5, 1e9);
      shown = halves == halves.roundToDouble()
          ? halves.toStringAsFixed(0)
          : halves.toStringAsFixed(1);
    }
    return l10n.tarPicture(shown, measure);
  }
}
