/// One honest answer to "how many cigarettes did I NOT smoke?".
///
/// Three rules, each of which the old code broke (owner test 2026-10-02:
/// 4 cigarettes in a row on a 17-a-day plan showed "78 TL saved", and the
/// environment card claimed 1795 butts spared on day one):
///
///  1. Only COMPLETED days count. Today is still being lived, so
///     "baseline − count so far" would credit the user for the hours they
///     have not smoked *yet*.
///  2. A day with no record at all is UNKNOWN, not "zero cigarettes". Treating
///     every empty day as a full baseline of avoided cigarettes is how 90
///     days x 20 became 1795.
///  3. The yardstick is the BASELINE (what the user smoked before Halen), not
///     the plan target: staying under a reduction target is not itself a
///     saving, being under the old habit is.
library;

import 'dart:math' as math;

/// The few fields of a stored day the ledger needs.
class LedgerRow {
  const LedgerRow({
    required this.dateKey,
    required this.count,
    this.resisted = 0,
  });

  /// Local day key, `yyyy-MM-dd` (sortable as text).
  final String dateKey;

  /// Cigarettes recorded that day.
  final int count;

  /// Cravings the user logged as resisted that day.
  final int resisted;
}

/// Result of [SavingsLedger.from].
class SavingsLedger {
  const SavingsLedger({
    required this.trackedDays,
    required this.smoked,
    required this.avoided,
  });

  static const empty = SavingsLedger(trackedDays: 0, smoked: 0, avoided: 0);

  /// Completed days the user actually engaged with.
  final int trackedDays;

  /// Cigarettes smoked on those days.
  final int smoked;

  /// Cigarettes under the baseline on those days (never negative per day).
  final int avoided;

  /// Builds the ledger from stored [rows].
  ///
  /// [startKey] is the day the user began (inclusive); [todayKey] is today
  /// (exclusive — the day in progress never counts). A day is *tracked* when
  /// it holds a smoked record or a resisted craving; otherwise it is unknown.
  factory SavingsLedger.from({
    required double baselineCpd,
    required String startKey,
    required String todayKey,
    required Iterable<LedgerRow> rows,
  }) {
    var tracked = 0;
    var smoked = 0;
    var avoided = 0;
    for (final row in rows) {
      if (row.dateKey.compareTo(startKey) < 0 ||
          row.dateKey.compareTo(todayKey) >= 0) {
        continue;
      }
      if (row.count <= 0 && row.resisted <= 0) {
        continue;
      }
      tracked++;
      smoked += row.count;
      avoided += math.max(0, (baselineCpd - row.count).round());
    }
    return SavingsLedger(trackedDays: tracked, smoked: smoked, avoided: avoided);
  }
}
