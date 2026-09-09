import 'package:flutter_test/flutter_test.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/domain/craving_risk.dart';
import 'package:halen/domain/harm_load.dart';
import 'package:halen/domain/progress_index.dart';
import 'package:halen/domain/withdrawal_model.dart';

void main() {
  group('Progress Score', () {
    ProgressInputs inputs({
      double adherence = 0.8,
      double recentCpd = 10,
      int resisted = 8,
      int cravings = 10,
      int daysLogged = 14,
      double baselineFall = 0.5,
    }) =>
        ProgressInputs(
          adherence14d: adherence,
          baselineCpd: 20,
          recentCpd: recentCpd,
          cravingsResisted: resisted,
          cravingsTotal: cravings,
          daysLogged: daysLogged,
          daysInWindow: 14,
          nicotineBaselineFall: baselineFall,
        );

    test('weights sum to 100', () {
      expect(
        ProgressComponent.values.fold<int>(0, (s, c) => s + c.weight),
        100,
      );
    });

    test('perfect behaviour scores 100, no behaviour scores 0', () {
      final best = progressScore(
        inputs(adherence: 1, recentCpd: 0, resisted: 10, baselineFall: 1),
      );
      expect(best.score, 100);
      final worst = progressScore(
        inputs(
          adherence: 0,
          recentCpd: 20,
          resisted: 0,
          daysLogged: 0,
          baselineFall: 0,
        ),
      );
      expect(worst.score, 0);
    });

    test('a single bad day cannot move the score more than the clamp', () {
      final crashed = progressScore(
        inputs(adherence: 0, recentCpd: 20, resisted: 0, baselineFall: 0),
        previousScore: 70,
      );
      expect(crashed.score, 70 - maxDailyDelta);
    });

    test('no cravings logged is neutral, not punitive', () {
      final none = progressScore(inputs(resisted: 0, cravings: 0));
      final some = progressScore(inputs(resisted: 5, cravings: 10));
      expect(none.score, some.score);
    });

    test('breakdown covers every component and sums to the raw score', () {
      final result = progressScore(inputs());
      expect(result.breakdown.length, ProgressComponent.values.length);
      final sum = result.breakdown.fold<double>(0, (s, b) => s + b.points);
      expect(sum.round(), result.score);
    });

    test('bands ladder upward', () {
      expect(progressBandFor(10), ProgressBand.starting);
      expect(progressBandFor(50), ProgressBand.onTrack);
      expect(progressBandFor(75), ProgressBand.strong);
      expect(progressBandFor(95), ProgressBand.veryStrong);
    });

    test('delta reads the trend over the requested window', () {
      expect(progressDelta([40, 42, 44, 46, 48, 50, 52, 54]), 14);
      expect(progressDelta([50]), 0);
    });
  });

  group('Harm Load', () {
    HarmInputs inputs({
      double recentCpd = 20,
      int hsi = 4,
      double? bmi = 24,
      double yearsSinceQuit = 0,
    }) =>
        HarmInputs(
          ageYears: 45,
          smokingYears: 20,
          baselineCpd: 20,
          recentCpd: recentCpd,
          hsi: hsi,
          bmi: bmi,
          yearsSinceQuit: yearsSinceQuit,
        );

    test('weights sum to 100', () {
      expect(HarmComponent.values.fold<int>(0, (s, c) => s + c.weight), 100);
    });

    test('pack-years follow the standard definition', () {
      expect(packYears(cigarettesPerDay: 20, years: 20), 20);
      expect(packYears(cigarettesPerDay: 10, years: 20), 10);
    });

    test('cutting down lowers the score', () {
      final heavy = harmLoad(inputs(recentCpd: 20)).score;
      final light = harmLoad(inputs(recentCpd: 4)).score;
      expect(light, lessThan(heavy));
    });

    test('the moving part is worth about 45 points', () {
      final full = harmLoad(inputs(recentCpd: 20, hsi: 6)).score;
      final none = harmLoad(inputs(recentCpd: 0, hsi: 0)).score;
      expect(full - none, inInclusiveRange(40, 50));
    });

    test('quitting relieves the cumulative component over years', () {
      final fresh = harmLoad(inputs(recentCpd: 0, yearsSinceQuit: 0)).score;
      final tenYears = harmLoad(inputs(recentCpd: 0, yearsSinceQuit: 10)).score;
      expect(tenYears, lessThan(fresh));
    });

    test('omitting body data renormalizes instead of penalizing', () {
      final withBmi = harmLoad(inputs(bmi: 24));
      final without = harmLoad(inputs(bmi: null));
      expect(without.breakdown.length, withBmi.breakdown.length - 1);
      expect(without.score, inInclusiveRange(0, 100));
    });

    test('bmi rejects impossible input', () {
      expect(bmiFrom(heightCm: 180, weightKg: 80), closeTo(24.7, 0.1));
      expect(bmiFrom(heightCm: null, weightKg: 80), isNull);
      expect(bmiFrom(heightCm: 5, weightKg: 80), isNull);
    });
  });

  group('withdrawal model', () {
    test('typical pressure peaks on days 1-3 and decays afterwards', () {
      expect(typicalPressure(2), 1.0);
      expect(typicalPressure(0.5), lessThan(1.0));
      expect(typicalPressure(10), lessThan(typicalPressure(5)));
      expect(typicalPressure(28), lessThan(0.2));
    });

    test('a deeper trough raises pressure within the same phase', () {
      final shallow = pressureNow(daysSincePhaseStart: 2, trough: 0.1);
      final deep = pressureNow(daysSincePhaseStart: 2, trough: 1);
      expect(deep, greaterThan(shallow));
    });

    test('personal offset needs enough reports and stays clamped', () {
      expect(personalOffset(const []), 0);
      final biased = List.generate(
        10,
        (_) => (estimated: 0.2, reported: 1.0),
      );
      expect(personalOffset(biased), 0.2);
    });

    test('accuracy compares bands, not raw values', () {
      final reports = [
        (estimated: 0.1, reported: 0.2),
        (estimated: 0.9, reported: 0.8),
        (estimated: 0.1, reported: 0.9),
        (estimated: 0.5, reported: 0.5),
        (estimated: 0.5, reported: 0.6),
      ];
      expect(estimateAccuracy(reports), closeTo(0.8, 1e-9));
    });

    test('weight gain follows the published anchors', () {
      expect(typicalWeightGainKg(0), 0);
      expect(typicalWeightGainKg(1), closeTo(1.1, 1e-9));
      expect(typicalWeightGainKg(12), closeTo(4.7, 1e-9));
      expect(typicalWeightGainKg(24), closeTo(4.7, 1e-9));
      expect(typicalWeightGainKg(1.5), inInclusiveRange(1.1, 2.3));
    });
  });

  group('HSI', () {
    test('scores 0-6 from the two validated items', () {
      expect(
        heavinessOfSmokingIndex(
          cigarettesPerDay: 5,
          minutesToFirstCigarette: 120,
        ),
        0,
      );
      expect(
        heavinessOfSmokingIndex(
          cigarettesPerDay: 40,
          minutesToFirstCigarette: 3,
        ),
        6,
      );
      expect(
        heavinessOfSmokingIndex(
          cigarettesPerDay: 20,
          minutesToFirstCigarette: 20,
        ),
        3,
      );
    });
  });

  group('short duration formatting', () {
    test('minutes below an hour', () {
      expect(formatShortDuration(const Duration(minutes: 40), 'en'), '40 m');
      expect(formatShortDuration(const Duration(minutes: 40), 'tr'), '40 dk');
    });

    test('hours drop a trailing zero minutes', () {
      expect(formatShortDuration(const Duration(hours: 6), 'en'), '6 h');
      expect(
        formatShortDuration(const Duration(hours: 6, minutes: 20), 'tr'),
        '6 sa 20 dk',
      );
    });

    test('long spans switch to days, because 465 h is not readable', () {
      expect(formatShortDuration(const Duration(hours: 465), 'en'), '19 d 9 h');
      expect(formatShortDuration(const Duration(days: 3), 'tr'), '3 g');
    });
  });
}
