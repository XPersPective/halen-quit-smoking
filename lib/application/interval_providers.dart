import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import 'providers.dart';

@immutable
class CigaretteIntervalItem {
  const CigaretteIntervalItem({
    required this.id,
    required this.time,
    required this.gapFromPrevious,
    this.triggerId,
    this.mood,
    this.source = 'app',
  });

  final int id;
  final DateTime time;
  final Duration? gapFromPrevious;
  final String? triggerId;
  final String? mood;
  final String source;
}

@immutable
class DailyIntervalsReport {
  const DailyIntervalsReport({
    required this.items,
    required this.averageGapMinutes,
    required this.longestGapMinutes,
    required this.shortestGapMinutes,
    required this.currentSmokeFreeMinutes,
    required this.totalToday,
  });

  final List<CigaretteIntervalItem> items;
  final int averageGapMinutes;
  final int longestGapMinutes;
  final int shortestGapMinutes;
  final int currentSmokeFreeMinutes;
  final int totalToday;
}

@immutable
class HourBucket {
  const HourBucket({
    required this.hour,
    required this.count,
    required this.isPeak,
    required this.percentage,
  });

  final int hour;
  final int count;
  final bool isPeak;
  final double percentage;
}

@immutable
class TimeBlockSummary {
  const TimeBlockSummary({
    required this.nameKey,
    required this.startHour,
    required this.endHour,
    required this.count,
    required this.percentage,
  });

  final String nameKey;
  final int startHour;
  final int endHour;
  final int count;
  final double percentage;
}

@immutable
class HourlyAnalyticsReport {
  const HourlyAnalyticsReport({
    required this.buckets,
    required this.peakHour,
    required this.peakCount,
    required this.blocks,
    required this.totalEvents,
  });

  final List<HourBucket> buckets;
  final int? peakHour;
  final int peakCount;
  final List<TimeBlockSummary> blocks;
  final int totalEvents;
}

@immutable
class TriggerStatItem {
  const TriggerStatItem({
    required this.triggerKey,
    required this.count,
    required this.percentage,
  });

  final String triggerKey;
  final int count;
  final double percentage;
}

/// Computes today's inter-cigarette interval breakdown (report §12, user request).
final todayIntervalsProvider = StreamProvider<DailyIntervalsReport>((ref) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final dayStart = now.dayStart;
  final dayEnd = dayStart.add(const Duration(days: 1));

  return db.recordDao.watchEventsBetween(dayStart, dayEnd).map((events) {
    if (events.isEmpty) {
      return const DailyIntervalsReport(
        items: [],
        averageGapMinutes: 0,
        longestGapMinutes: 0,
        shortestGapMinutes: 0,
        currentSmokeFreeMinutes: 0,
        totalToday: 0,
      );
    }

    final items = <CigaretteIntervalItem>[];
    var sumGaps = 0;
    var longest = 0;
    var shortest = 999999;
    var gapCount = 0;

    for (var i = 0; i < events.length; i++) {
      final e = events[i];
      Duration? gap;
      if (i > 0) {
        gap = e.ts.difference(events[i - 1].ts);
        final gapMins = gap.inMinutes;
        sumGaps += gapMins;
        gapCount++;
        if (gapMins > longest) longest = gapMins;
        if (gapMins < shortest) shortest = gapMins;
      }
      items.add(
        CigaretteIntervalItem(
          id: e.id,
          time: e.ts,
          gapFromPrevious: gap,
          triggerId: e.triggerLabel?.name,
          mood: e.mood,
          source: e.source.name,
        ),
      );
    }

    final nowDiff = DateTime.now().difference(events.last.ts).inMinutes;

    return DailyIntervalsReport(
      items: items,
      averageGapMinutes: gapCount > 0 ? (sumGaps / gapCount).round() : 0,
      longestGapMinutes: gapCount > 0 ? longest : 0,
      shortestGapMinutes: gapCount > 0 ? shortest : 0,
      currentSmokeFreeMinutes: nowDiff.clamp(0, 999999),
      totalToday: events.length,
    );
  });
});

/// 24-hour detailed distribution analytics over the last 14 days (report §12/§14).
final hourlyAnalyticsProvider = FutureProvider<HourlyAnalyticsReport>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final start = dayStartMinusDays(now, 13);
  final end = now.dayStart.add(const Duration(days: 1));

  final histogram = await db.statsDao.hourlyHistogram(start, end);
  final total = histogram.fold(0, (a, b) => a + b);
  final maxCount = histogram.fold(0, (a, b) => a > b ? a : b);
  int? peakH;
  if (maxCount > 0) {
    peakH = histogram.indexOf(maxCount);
  }

  final buckets = <HourBucket>[];
  for (var h = 0; h < 24; h++) {
    final count = histogram[h];
    buckets.add(
      HourBucket(
        hour: h,
        count: count,
        isPeak: count > 0 && count == maxCount,
        percentage: total > 0 ? count / total : 0.0,
      ),
    );
  }

  // Time blocks: Morning (06-12), Afternoon (12-18), Evening (18-24), Night (00-06)
  int countBlock(int startH, int endH) {
    var c = 0;
    for (var h = startH; h < endH; h++) {
      c += histogram[h];
    }
    return c;
  }

  final mCount = countBlock(6, 12);
  final aCount = countBlock(12, 18);
  final eCount = countBlock(18, 24);
  final nCount = countBlock(0, 6);

  final blocks = [
    TimeBlockSummary(
      nameKey: 'timeMorning',
      startHour: 6,
      endHour: 12,
      count: mCount,
      percentage: total > 0 ? mCount / total : 0.0,
    ),
    TimeBlockSummary(
      nameKey: 'timeAfternoon',
      startHour: 12,
      endHour: 18,
      count: aCount,
      percentage: total > 0 ? aCount / total : 0.0,
    ),
    TimeBlockSummary(
      nameKey: 'timeEvening',
      startHour: 18,
      endHour: 24,
      count: eCount,
      percentage: total > 0 ? eCount / total : 0.0,
    ),
    TimeBlockSummary(
      nameKey: 'timeNight',
      startHour: 0,
      endHour: 6,
      count: nCount,
      percentage: total > 0 ? nCount / total : 0.0,
    ),
  ];

  return HourlyAnalyticsReport(
    buckets: buckets,
    peakHour: peakH,
    peakCount: maxCount,
    blocks: blocks,
    totalEvents: total,
  );
});

/// Trigger frequency analytics (report §19).
final triggerAnalyticsProvider = FutureProvider<List<TriggerStatItem>>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final start = dayStartMinusDays(now, 30);
  final end = now.dayStart.add(const Duration(days: 1));

  final events = await db.recordDao.getEventsBetween(start, end);
  final counts = <String, int>{};
  var totalWithTrigger = 0;

  for (final e in events) {
    final t = e.triggerLabel?.name;
    if (t != null && t.isNotEmpty) {
      counts[t] = (counts[t] ?? 0) + 1;
      totalWithTrigger++;
    }
  }

  if (totalWithTrigger == 0) {
    return const [];
  }

  final sortedKeys = counts.keys.toList()
    ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

  return [
    for (final k in sortedKeys)
      TriggerStatItem(
        triggerKey: k,
        count: counts[k]!,
        percentage: counts[k]! / totalWithTrigger,
      ),
  ];
});
