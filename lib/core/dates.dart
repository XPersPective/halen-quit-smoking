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

/// Stable ISO key ("yyyy-MM-dd") for a local day, used in DB date columns.
String dayKey(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}

/// Parses an ISO "yyyy-MM-dd" key back to a local day start.
DateTime parseDayKey(String key) {
  final parts = key.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

/// Short, locale-aware duration label ("6h 20m" / "6 sa 20 dk").
/// Used wherever the app says how long it has been since something.
String formatShortDuration(Duration d, String localeCode) {
  final tr = localeCode.toLowerCase().startsWith('tr');
  final de = localeCode.toLowerCase().startsWith('de');
  final hourUnit = tr ? 'sa' : (de ? 'Std' : 'h');
  final minuteUnit = tr ? 'dk' : (de ? 'Min' : 'm');
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  if (hours <= 0) {
    return '$minutes $minuteUnit';
  }
  return '$hours $hourUnit $minutes $minuteUnit';
}
