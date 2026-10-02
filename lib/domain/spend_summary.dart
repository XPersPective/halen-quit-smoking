/// What smoking has cost, in money and time — the sum that makes the habit
/// concrete (owner request 2026-10-02: "10 years x 20 a day, how much is
/// that?").
///
/// Two honest halves, never blended silently:
///  - RECORDED: cigarettes the user logged since starting Halen, priced at
///    the current pack price (today, 7, 30, 365 days, since start);
///  - DECLARED: the years the user said they smoked before Halen x their
///    declared daily number x the current price. This is an estimate and is
///    labelled so; prices were lower in the past, so it is a floor, not a
///    ceiling, in most currencies.
library;

/// Minutes one cigarette takes to smoke. Published figures run 5–7; the
/// lower bound is used so the total is never inflated.
const double minutesPerCigaretteSmoked = 5;

/// A stored day (only what the summary needs).
class SpendDay {
  const SpendDay({required this.dateKey, required this.count});

  /// Local day key `yyyy-MM-dd`.
  final String dateKey;
  final int count;
}

class SpendSummary {
  const SpendSummary({
    required this.perCigarette,
    required this.todayCount,
    required this.today,
    required this.week,
    required this.month,
    required this.year,
    required this.recordedTotal,
    required this.recordedCigarettes,
    required this.declaredCigarettes,
    required this.declaredTotal,
  });

  /// Price of one cigarette.
  final double perCigarette;

  /// Cigarettes recorded today.
  final int todayCount;

  /// Money spent today / in the last 7 / 30 / 365 days (recorded only).
  final double today;
  final double week;
  final double month;
  final double year;

  /// Money and cigarettes recorded since the first day of Halen.
  final double recordedTotal;
  final int recordedCigarettes;

  /// Estimated cigarettes and money BEFORE Halen, from the declared years.
  /// Null when the user never said how long they have smoked.
  final int? declaredCigarettes;
  final double? declaredTotal;

  /// Best available lifetime figure: declared history + recorded since.
  /// Null until the user has told us how long they have smoked.
  double? get lifetimeTotal =>
      declaredTotal == null ? null : declaredTotal! + recordedTotal;

  int? get lifetimeCigarettes => declaredCigarettes == null
      ? null
      : declaredCigarettes! + recordedCigarettes;

  /// Time spent smoking over [lifetimeCigarettes].
  Duration? get lifetimeTimeSmoking => lifetimeCigarettes == null
      ? null
      : Duration(
          minutes: (lifetimeCigarettes! * minutesPerCigaretteSmoked).round(),
        );

  factory SpendSummary.compute({
    required List<SpendDay> days,
    required DateTime now,
    required double pricePerPack,
    required int packSize,
    required String startKey,
    required double declaredCpd,
    required double? smokingYears,
  }) {
    final per = packSize <= 0 ? 0.0 : pricePerPack / packSize;
    String key(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    final todayKey = key(now);
    final dayOnly = DateTime(now.year, now.month, now.day);
    final weekKey = key(dayOnly.subtract(const Duration(days: 6)));
    final monthKey = key(dayOnly.subtract(const Duration(days: 29)));
    final yearKey = key(dayOnly.subtract(const Duration(days: 364)));

    int sum(bool Function(String k) test) {
      var n = 0;
      for (final d in days) {
        if (d.dateKey.compareTo(startKey) >= 0 && test(d.dateKey)) {
          n += d.count;
        }
      }
      return n;
    }

    final todayCount = sum((k) => k == todayKey);
    final all = sum((_) => true);
    final declaredCigs = smokingYears == null
        ? null
        : (smokingYears * 365.25 * declaredCpd).round();
    return SpendSummary(
      perCigarette: per,
      todayCount: todayCount,
      today: todayCount * per,
      week: sum((k) => k.compareTo(weekKey) >= 0) * per,
      month: sum((k) => k.compareTo(monthKey) >= 0) * per,
      year: sum((k) => k.compareTo(yearKey) >= 0) * per,
      recordedTotal: all * per,
      recordedCigarettes: all,
      declaredCigarettes: declaredCigs,
      declaredTotal: declaredCigs == null ? null : declaredCigs * per,
    );
  }
}
