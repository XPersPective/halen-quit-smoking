/// Pack purchases (device feedback, items 2 and 3).
///
/// The app asked for a pack price once, at onboarding, and never again. But
/// people do not buy one brand at one price forever — they buy a different
/// pack at an airport, a carton on holiday, a cheaper brand when money is
/// tight. A cost figure frozen at the onboarding price drifts further from
/// the truth every week.
///
/// So purchases are recorded as they happen, and everything money-related
/// can be computed from what was actually paid: this month's spend, how
/// often a pack is bought, and what the habit costs at the current rate.
library;

import 'dart:math' as math;

/// One pack (or several) bought at one time.
class PackPurchase {
  const PackPurchase({
    required this.at,
    required this.packs,
    required this.pricePerPack,
    required this.packSize,
    this.brand,
  });

  final DateTime at;
  final int packs;
  final double pricePerPack;
  final int packSize;
  final String? brand;

  double get total => packs * pricePerPack;
  int get cigarettes => packs * packSize;
}

/// Spending for one calendar month.
class MonthSpend {
  const MonthSpend({required this.month, required this.total, required this.packs});

  /// First day of the month.
  final DateTime month;
  final double total;
  final int packs;
}

/// Everything the purchase screen shows, computed from the purchase list.
class PurchaseSummary {
  const PurchaseSummary({
    required this.thisMonth,
    required this.lastMonth,
    required this.months,
    required this.averageDaysBetween,
    required this.last,
    required this.monthlyRate,
    required this.purchaseCount,
  });

  /// Spend so far this calendar month.
  final double thisMonth;
  final double lastMonth;

  /// The last six calendar months, oldest first, including empty ones — a
  /// month with no purchases is information, not a gap to skip.
  final List<MonthSpend> months;

  /// Mean days between consecutive purchases; null below two purchases.
  final double? averageDaysBetween;

  final PackPurchase? last;

  /// What a month costs at the recent rate (last 30 days, scaled). Null
  /// until there are at least two purchases to establish a rate.
  final double? monthlyRate;

  final int purchaseCount;

  bool get isEmpty => purchaseCount == 0;

  static PurchaseSummary of(List<PackPurchase> purchases, DateTime now) {
    final sorted = [...purchases]..sort((a, b) => a.at.compareTo(b.at));

    double spendIn(DateTime start, DateTime end) => sorted
        .where((p) => !p.at.isBefore(start) && p.at.isBefore(end))
        .fold(0.0, (sum, p) => sum + p.total);

    final monthStart = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);
    final lastMonthStart = DateTime(now.year, now.month - 1);

    final months = <MonthSpend>[
      for (var i = 5; i >= 0; i--)
        () {
          final start = DateTime(now.year, now.month - i);
          final end = DateTime(now.year, now.month - i + 1);
          final inMonth = sorted
              .where((p) => !p.at.isBefore(start) && p.at.isBefore(end));
          return MonthSpend(
            month: start,
            total: inMonth.fold(0.0, (s, p) => s + p.total),
            packs: inMonth.fold(0, (s, p) => s + p.packs),
          );
        }(),
    ];

    double? averageGap;
    if (sorted.length >= 2) {
      final span = sorted.last.at.difference(sorted.first.at).inHours / 24;
      averageGap = span / (sorted.length - 1);
    }

    double? rate;
    final windowStart = now.subtract(const Duration(days: 30));
    final recent = sorted.where((p) => p.at.isAfter(windowStart)).toList();
    if (recent.length >= 2) {
      final days = math.max(
        1.0,
        now.difference(recent.first.at).inHours / 24,
      );
      rate = recent.fold(0.0, (s, p) => s + p.total) / days * 30;
    }

    return PurchaseSummary(
      thisMonth: spendIn(monthStart, nextMonth),
      lastMonth: spendIn(lastMonthStart, monthStart),
      months: months,
      averageDaysBetween: averageGap,
      last: sorted.isEmpty ? null : sorted.last,
      monthlyRate: rate,
      purchaseCount: sorted.length,
    );
  }
}
