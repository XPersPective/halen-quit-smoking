import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import 'providers.dart';

/// One day of stats for the charts (S2 counts + S3 derived savings).
class DayStats {
  const DayStats({
    required this.dateKey,
    required this.count,
    this.planTarget,
    this.savings,
    this.adherence,
    this.resisted = 0,
  });

  final String dateKey;
  final int count;
  final int? planTarget;
  final double? savings;
  final double? adherence;
  final int resisted;
}

/// Last [days] days of daily stats, oldest first, missing days as zeros.
final dailyStatsProvider = FutureProvider.family<List<DayStats>, int>(
  (ref, days) async {
    final db = ref.watch(databaseProvider);
    final now = DateTime.now();
    final start = dayStartMinusDays(now, days - 1);
    final summaries = await db.statsDao.getSummariesBetween(
      dayKey(start),
      dayKey(now),
    );
    final byKey = {for (final s in summaries) s.date: s};
    return [
      for (var i = 0; i < days; i++)
        () {
          final key = dayKey(start.add(Duration(days: i)));
          final s = byKey[key];
          return DayStats(
            dateKey: key,
            count: s?.count ?? 0,
            planTarget: s?.planTarget,
            savings: s?.savings,
            adherence: s?.adherence,
            resisted: s?.resistedCount ?? 0,
          );
        }(),
    ];
  },
);

/// Hour-of-day histogram over the last 14 days (0..23).
final hourlyHistogramProvider = FutureProvider<List<int>>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  return db.statsDao.hourlyHistogram(
    dayStartMinusDays(now, 13),
    now.dayStart.add(const Duration(days: 1)),
  );
});

