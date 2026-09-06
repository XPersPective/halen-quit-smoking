/// Date/time helpers used across layers. All "day" concepts are local days
/// (smoking patterns are local-time); plan arithmetic passes `now` explicitly
/// so the domain stays deterministic and testable.
library;

extension DayX on DateTime {
  /// Local midnight of this day.
  DateTime get dayStart => DateTime(year, month, day);

  /// Local midnight of the next day.
  DateTime get nextDayStart => dayStart.add(const Duration(days: 1));

  bool isSameLocalDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  int get localDayNumber => DateTime(year, month, day).difference(
        DateTime(1970),
      ).inDays;
}

/// Returns the local day start for [n] days before [now]'s day start.
DateTime dayStartMinusDays(DateTime now, int n) =>
    now.dayStart.subtract(Duration(days: n));
