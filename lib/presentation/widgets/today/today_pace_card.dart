import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../charts/halen_line_chart.dart';
import '../design/halen_components.dart';

/// Hours of the day the declared pattern is spread over (07:00–23:00).
const int _wakeHour = 7;
const int _sleepHour = 23;

/// Cigarettes a person who smokes [dailyCount] a day, evenly across the
/// waking hours, would have smoked by [hour] (fractional hours allowed).
double usualCountByHour(double dailyCount, double hour) {
  final progress =
      ((hour - _wakeHour) / (_sleepHour - _wakeHour)).clamp(0.0, 1.0);
  return dailyCount * progress;
}

/// Today so far against the day the person described at the start.
///
/// The grey dashed line is their own declaration; the coloured line is what
/// they logged. Early on the two differ — that is information, not failure —
/// and as real days accumulate the declaration is replaced by the measured
/// baseline (see [measuredBaselineProvider]), so the comparison converges on
/// what is true. Cumulative count also answers "how much have I smoked so
/// far today" at a glance.
class TodayPaceCard extends ConsumerWidget {
  const TodayPaceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(smokingProfileProvider).value;
    final events = ref.watch(eventTimestampsProvider).value;
    final baseline = ref.watch(measuredBaselineProvider).value;
    if (profile == null || events == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final today =
        events.where((e) => !e.isBefore(dayStart) && !e.isAfter(now)).toList();
    final usual = (baseline ?? profile.baselineCpd.toDouble());
    final nowHour = now.hour + now.minute / 60;
    final expectedNow = usualCountByHour(usual, nowHour).round();

    final usualSeries = [
      for (var h = 0; h <= 24; h++) usualCountByHour(usual, h.toDouble()),
    ];
    final actualSeries = [
      for (var h = 0; h <= now.hour; h++)
        today
            .where(
              (e) => h == now.hour
                  ? true
                  : e.isBefore(dayStart.add(Duration(hours: h + 1))),
            )
            .length
            .toDouble(),
    ];

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: l10n.todayPaceTitle),
          const SizedBox(height: HalenSpace.x2),
          HalenLineChart(
            height: 170,
            series: [
              ChartSeries(
                name: l10n.todayPaceUsual,
                color: Theme.of(context).colorScheme.outline,
                values: usualSeries,
                dashed: true,
              ),
              ChartSeries(
                name: l10n.todayPaceToday,
                color: DataRole.nicotine.of(context),
                values: actualSeries.length < 2
                    ? [0, actualSeries.isEmpty ? 0 : actualSeries.first]
                    : actualSeries,
                fill: true,
              ),
            ],
            meaning: l10n.todayPaceMeaning(today.length, expectedNow),
            xLabels: const ['00:00', '12:00', '24:00'],
            axisCaption: l10n.todayPaceAxis,
            minY: 0,
            maxY: math.max(usual, today.length.toDouble()).ceilToDouble() + 1,
            semanticsLabel: l10n.todayPaceMeaning(today.length, expectedNow),
            highlightLastPoint: true,
          ),
        ],
      ),
    );
  }
}
