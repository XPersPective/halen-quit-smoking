/// Economy module (module report §3) — the product's most CERTAIN screen.
///
/// Everything here is the user's own data (S2) plus arithmetic, so the copy
/// is allowed to say "this is not an estimate, it is your own numbers" —
/// with one exception: the time ledger uses the published population average
/// of ~20 minutes of life expectancy per cigarette (17 for men, 22 for
/// women), which is S4 and must always carry the word "average".
///
/// Baseline honesty rule: the baseline is the FIRST WEEK OF MEASURED records,
/// not the onboarding declaration, because self-reported intake is
/// systematically under-reported and would inflate every saving shown.
library;

/// Minutes of life expectancy lost per cigarette, population average (S4).
abstract final class LifeMinutes {
  static const double average = 20;
  static const double male = 17;
  static const double female = 22;
}

/// Optional sex, used only for the time ledger's published split.
enum SexOption { unspecified, male, female }

double lifeMinutesPerCigarette(SexOption sex) => switch (sex) {
      SexOption.male => LifeMinutes.male,
      SexOption.female => LifeMinutes.female,
      SexOption.unspecified => LifeMinutes.average,
    };

/// The two lines drawn on the projection chart.
enum EconomyScenario { keepThisPace, finishThePlan }

/// One projected point.
class ProjectionPoint {
  const ProjectionPoint({
    required this.dayIndex,
    required this.keepThisPace,
    required this.finishThePlan,
  });

  /// Days from today.
  final int dayIndex;

  /// Cumulative money spent if nothing changes.
  final double keepThisPace;

  /// Cumulative money spent if the plan is completed.
  final double finishThePlan;

  /// The shaded area's value at this point — "your decision".
  double get difference => keepThisPace - finishThePlan;
}

/// Money and time ledger.
class Economy {
  const Economy({
    required this.pricePerPack,
    required this.packSize,
    this.sex = SexOption.unspecified,
  });

  final double pricePerPack;
  final int packSize;
  final SexOption sex;

  double get perCigarette => packSize <= 0 ? 0 : pricePerPack / packSize;

  /// Calibrated baseline: the mean of the first week of MEASURED days.
  /// Falls back to [onboardingCpd] until at least [minDays] real days exist.
  static double baselineFromFirstWeek({
    required List<int> firstWeekDailyCounts,
    required int onboardingCpd,
    int minDays = 3,
  }) {
    final days = firstWeekDailyCounts.take(7).where((c) => c > 0).toList();
    if (days.length < minDays) {
      return onboardingCpd.toDouble();
    }
    return days.reduce((a, b) => a + b) / days.length;
  }

  /// Money not spent, from cigarettes avoided against the baseline.
  double saved(int avoidedCount) => avoidedCount * perCigarette;

  /// Money actually spent on [smokedCount} cigarettes — the "loss" side of
  /// the ledger nobody else in the category is willing to show. Rendered
  /// neutral grey, never red, never commented on.
  double spent(int smokedCount) => smokedCount * perCigarette;

  /// Cumulative spend projection over [days].
  ///
  /// [currentCpd] is today's pace; [planCpd] is the plan's daily budget path
  /// (one entry per day, shorter lists hold their last value, an empty list
  /// means a completed plan at zero).
  List<ProjectionPoint> projection({
    required double currentCpd,
    required List<double> planCpd,
    int days = 365,
    int step = 7,
  }) {
    final points = <ProjectionPoint>[];
    var keep = 0.0;
    var plan = 0.0;
    for (var day = 0; day <= days; day++) {
      if (day > 0) {
        keep += currentCpd * perCigarette;
        final planned = planCpd.isEmpty
            ? 0.0
            : planCpd[day - 1 < planCpd.length ? day - 1 : planCpd.length - 1];
        plan += planned * perCigarette;
      }
      if (day % step == 0 || day == days) {
        points.add(
          ProjectionPoint(
            dayIndex: day,
            keepThisPace: keep,
            finishThePlan: plan,
          ),
        );
      }
    }
    return points;
  }

  /// Packs' worth of money — the "n packs" framing.
  double packsEquivalent(double amount) =>
      pricePerPack <= 0 ? 0 : amount / pricePerPack;

  /// Time regained from avoided cigarettes (S4 — population average).
  Duration timeRegained(int avoidedCount) => Duration(
        minutes: (avoidedCount * lifeMinutesPerCigarette(sex)).round(),
      );

  /// Time lost to cigarettes actually smoked (S4 — population average).
  Duration timeLost(int smokedCount) => Duration(
        minutes: (smokedCount * lifeMinutesPerCigarette(sex)).round(),
      );
}

/// A user-defined savings goal — the user's own goal always outranks any
/// equivalent we could suggest, so this is the primary form.
class SavingsGoal {
  const SavingsGoal({required this.label, required this.amount});

  final String label;
  final double amount;

  /// Progress towards the goal, 0..1.
  double progress(double saved) =>
      amount <= 0 ? 0 : (saved / amount).clamp(0.0, 1.0);

  /// Days left at [dailySaving]; null when nothing is being saved yet.
  int? daysRemaining(double saved, double dailySaving) {
    if (dailySaving <= 0) {
      return null;
    }
    final remaining = amount - saved;
    return remaining <= 0 ? 0 : (remaining / dailySaving).ceil();
  }
}

/// Localizable equivalent suggestions. Keys resolve to ARB copy; the amounts
/// are per-market defaults the user can overwrite with their own goal.
enum EquivalentKey { groceries, fuelTank, gymMonth, flightTicket, phone }

/// Rough, market-typical price points used only to turn a saved amount into
/// something you can picture. They are ordered small to large and are NOT
/// claimed to be accurate prices — the user's own goal always outranks them
/// (module report §3.③), which is why the UI shows a goal when one exists
/// and falls back to these only when it does not.
List<({EquivalentKey key, double amount})> equivalentDefaults(String locale) {
  final code = locale.toLowerCase();
  if (code.startsWith('tr')) {
    return const [
      (key: EquivalentKey.gymMonth, amount: 1200),
      (key: EquivalentKey.fuelTank, amount: 2500),
      (key: EquivalentKey.groceries, amount: 9000),
      (key: EquivalentKey.flightTicket, amount: 4000),
      (key: EquivalentKey.phone, amount: 30000),
    ];
  }
  if (code.startsWith('de')) {
    return const [
      (key: EquivalentKey.gymMonth, amount: 35),
      (key: EquivalentKey.fuelTank, amount: 90),
      (key: EquivalentKey.flightTicket, amount: 150),
      (key: EquivalentKey.groceries, amount: 400),
      (key: EquivalentKey.phone, amount: 800),
    ];
  }
  return const [
    (key: EquivalentKey.gymMonth, amount: 45),
    (key: EquivalentKey.fuelTank, amount: 60),
    (key: EquivalentKey.flightTicket, amount: 200),
    (key: EquivalentKey.groceries, amount: 500),
    (key: EquivalentKey.phone, amount: 900),
  ];
}

/// The most substantial equivalent [amount] covers, with how many of it.
/// Null while the saving is too small to picture as anything yet — better to
/// stay quiet than to say "0.3 of a tank of fuel".
({EquivalentKey key, int count})? bestEquivalent({
  required double amount,
  required String locale,
}) {
  ({EquivalentKey key, int count})? best;
  // Sorted here rather than trusted to the table's order, so a market list
  // can be edited without silently changing which equivalent wins.
  final options = [...equivalentDefaults(locale)]
    ..sort((a, b) => a.amount.compareTo(b.amount));
  for (final option in options) {
    final count = amount ~/ option.amount;
    if (count >= 1) {
      best = (key: option.key, count: count);
    }
  }
  return best;
}
