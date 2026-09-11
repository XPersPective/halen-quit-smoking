import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/body_load_model.dart';
import 'package:halen/domain/environment_impact.dart';
import 'package:halen/domain/organ_exposure.dart';
import 'package:halen/domain/pack_purchases.dart';
import 'package:halen/domain/tar_intake.dart';

void main() {
  final now = DateTime(2026, 9, 20, 12);

  group('pack purchases', () {
    PackPurchase buy(int daysAgo, {int packs = 1, double price = 100}) =>
        PackPurchase(
          at: now.subtract(Duration(days: daysAgo)),
          packs: packs,
          pricePerPack: price,
          packSize: 20,
        );

    test('empty history says so instead of showing zeros as findings', () {
      final s = PurchaseSummary.of(const [], now);
      expect(s.isEmpty, isTrue);
      expect(s.averageDaysBetween, isNull);
      expect(s.monthlyRate, isNull);
    });

    test('this month and last month split on the calendar, not 30 days', () {
      final s = PurchaseSummary.of([
        buy(2, price: 120), // this month
        buy(25, packs: 2, price: 100), // August 26th — last month
      ], now);
      expect(s.thisMonth, 120);
      expect(s.lastMonth, 200);
    });

    test('the six-month series keeps empty months', () {
      final s = PurchaseSummary.of([buy(1)], now);
      expect(s.months, hasLength(6));
      expect(s.months.where((m) => m.total == 0), hasLength(5));
      expect(s.months.last.total, 100);
    });

    test('frequency is the mean gap between purchases', () {
      final s = PurchaseSummary.of([buy(10), buy(6), buy(2)], now);
      expect(s.averageDaysBetween, closeTo(4, 0.01));
    });

    test('monthly rate scales the last 30 days to a month', () {
      final s = PurchaseSummary.of([buy(10), buy(4)], now);
      // 200 spent over the 10 days since the first of them.
      expect(s.monthlyRate, closeTo(600, 1));
    });
  });

  group('tar intake', () {
    test('missing label values fall back to the legal maximum, and say so', () {
      const intake = TarIntake();
      expect(intake.tarMgPerCigarette, LabelLimits.tarMg);
      expect(intake.nicotineMgPerCigarette, LabelLimits.nicotineMg);
      expect(intake.usesLegalMaximum, isTrue);
      const own = TarIntake(tarMgPerCigarette: 6, nicotineMgPerCigarette: 0.5);
      expect(own.usesLegalMaximum, isFalse);
    });

    test('a pack a day at the legal cap is 1.4 g of tar a week', () {
      const intake = TarIntake();
      expect(intake.tarGrams(140), closeTo(1.4, 1e-9));
    });

    test('pictures pick the largest measure filled at least halfway', () {
      // 1.4 g at ~1 g/mL is 1.4 mL: over half a tea spoon (2.5 mL), under
      // half a dessert spoon (5 mL).
      final week = TarIntake.picture(1.4);
      expect(week.measure, Measure.teaSpoon);
      expect(week.count, closeTo(0.56, 0.01));
      // A year of that is 73 g: a third of a water glass, so table spoons.
      final year = TarIntake.picture(73);
      expect(year.measure, Measure.tableSpoon);
      expect(year.count, closeTo(4.87, 0.01));
    });

    test('weekly series counts each week once and ends at now', () {
      final events = [
        now.subtract(const Duration(days: 1)),
        now.subtract(const Duration(days: 2)),
        now.subtract(const Duration(days: 9)),
      ];
      final weeks = weeklyTarGrams(
        events: events,
        now: now,
        intake: const TarIntake(),
        weeks: 3,
      );
      expect(weeks, [0, 0.01, 0.02]);
    });
  });

  group('organ exposure', () {
    const model = BodyLoadModel();

    test('every organ curve peaks at 100 on its own scale', () {
      final start = now.subtract(const Duration(hours: 24));
      final events = [
        now.subtract(const Duration(hours: 5)),
        now.subtract(const Duration(hours: 2)),
      ];
      for (final key in ['heart', 'lungs', 'bloodVessels', 'liver']) {
        final curve = organCurve(
          model: model,
          organKey: key,
          start: start,
          end: now,
          events: events,
        );
        expect(curve, isNotEmpty, reason: key);
        expect(curve.map((s) => s.value).reduce((a, b) => a > b ? a : b), 100,
            reason: key);
      }
    });

    test('mix weights sum to one for every mapped organ', () {
      for (final entry in organLoadMixes.entries) {
        final total = entry.value.weights.values.fold<double>(0, (a, b) => a + b);
        expect(total, closeTo(1, 1e-9), reason: entry.key);
      }
      final fallback =
          defaultOrganMix.weights.values.fold<double>(0, (a, b) => a + b);
      expect(fallback, closeTo(1, 1e-9));
    });

    test('an organ with no cigarettes in the window stays at zero', () {
      final curve = organCurve(
        model: model,
        organKey: 'heart',
        start: now.subtract(const Duration(hours: 24)),
        end: now,
        events: const [],
      );
      expect(curve.every((s) => s.value == 0), isTrue);
    });
  });

  group('environment', () {
    test('one tree per 300 cigarettes, one filter per cigarette', () {
      const impact = EnvironmentImpact(cigarettesAvoided: 450);
      expect(impact.trees, 1.5);
      expect(impact.filters, 450);
    });

    test('saplings are floored, and nothing comes from nothing', () {
      expect(EnvironmentImpact.saplingsFor(149, pricePerSapling: 50), 2);
      expect(EnvironmentImpact.saplingsFor(0), 0);
      expect(EnvironmentImpact.saplingsFor(100, pricePerSapling: 0), 0);
    });

    test('every planting link is https', () {
      for (final partner in plantingPartners) {
        expect(partner.url, startsWith('https://'), reason: partner.name);
      }
    });
  });
}
