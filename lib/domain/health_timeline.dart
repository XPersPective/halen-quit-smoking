/// WHO health-benefits timeline (report §17) — S4 data: population-level
/// general information, never presented as personal measurement.
///
/// Milestone bodies live in ARB (l10n); this module owns ordering, unlock
/// arithmetic and the reduction-mode preview rule.
library;

enum HealthMilestone {
  twentyMinutes(minQuitDays: 0),
  twelveHours(minQuitDays: 0),
  twoToTwelveWeeks(minQuitDays: 14),
  oneToNineMonths(minQuitDays: 30),
  oneYear(minQuitDays: 365),
  strokeFiveTo15Years(minQuitDays: 5 * 365),
  tenYears(minQuitDays: 10 * 365),
  fifteenYears(minQuitDays: 15 * 365);

  const HealthMilestone({required this.minQuitDays});

  /// Days after the QUIT day before this milestone is reached.
  final int minQuitDays;
}

/// The first milestone not yet reached at [daysSinceQuit], or the last one
/// when everything is reached.
HealthMilestone nextMilestone(int daysSinceQuit) {
  for (final m in HealthMilestone.values) {
    if (daysSinceQuit < m.minQuitDays) {
      return m;
    }
  }
  return HealthMilestone.fifteenYears;
}

/// The milestone currently in progress (the latest one whose window began).
HealthMilestone currentMilestone(int daysSinceQuit) {
  HealthMilestone current = HealthMilestone.twentyMinutes;
  for (final m in HealthMilestone.values) {
    if (daysSinceQuit >= m.minQuitDays) {
      current = m;
    }
  }
  return current;
}

/// Reduction mode keeps the timeline as a locked "preview" until the quit
/// day is set (report §17: "önizleme" until the quit day).
bool timelinePreviewLocked({required DateTime? quitDate}) => quitDate == null;

int daysSinceQuit(DateTime quitDate, DateTime now) =>
    now.difference(quitDate).inDays.clamp(0, 1 << 30);
