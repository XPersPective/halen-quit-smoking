import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/plan_engine.dart';

void main() {
  group('PlanSpeed', () {
    test('mid-band weekly rate per pace', () {
      expect(PlanSpeed.forPace(Pace.calm).weeklyRate, closeTo(0.09, 1e-9));
      expect(PlanSpeed.forPace(Pace.standard).weeklyRate, closeTo(0.135, 1e-9));
      expect(PlanSpeed.forPace(Pace.fast).weeklyRate, closeTo(0.20, 1e-9));
    });

    test('TTFC under 5 minutes starts at the slowest tolerated rate', () {
      final speed =
          PlanSpeed.forPaceWithTtfc(Pace.standard, TtfcBand.under5);
      expect(speed.weeklyRate, Pace.standard.minWeeklyRate);
      // Other bands use the normal mid-band rate.
      expect(
        PlanSpeed.forPaceWithTtfc(Pace.standard, TtfcBand.over60).weeklyRate,
        closeTo(0.135, 1e-9),
      );
    });
  });

  group('calibrateBaseline', () {
    test('keeps onboarding value until 3 real days exist', () {
      expect(
        calibrateBaseline(onboardingCpd: 15, firstWeekDailyCounts: [8, 9]),
        15,
      );
      expect(
        calibrateBaseline(
            onboardingCpd: 15, firstWeekDailyCounts: [0, 0, 12, 10, 0]),
        15,
      );
    });

    test('averages real days once 3+ days recorded', () {
      expect(
        calibrateBaseline(
            onboardingCpd: 15, firstWeekDailyCounts: [12, 10, 11, 0, 0, 0, 0]),
        closeTo(11.0, 1e-9),
      );
    });
  });

  group('targetForDay', () {
    test('floor(prevWeekAvg × (1 − rate))', () {
      final speed = PlanSpeed(pace: Pace.standard, weeklyRate: 0.135);
      // 20 × 0.865 = 17.3 → 17
      expect(targetForDay(prevWeekAvg: 20, speed: speed), 17);
      // 10 × 0.865 = 8.65 → 8
      expect(targetForDay(prevWeekAvg: 10, speed: speed), 8);
    });

    test('softening applies 5% before the rate (weekly overshoot)', () {
      final speed = PlanSpeed(pace: Pace.standard, weeklyRate: 0.135);
      // 20 × 0.95 × 0.865 = 16.435 → 16 (one lower than un-softened)
      expect(
        targetForDay(prevWeekAvg: 20, speed: speed, soften: true),
        targetForDay(prevWeekAvg: 20, speed: speed) - 1,
      );
    });

    test('never negative', () {
      final speed = PlanSpeed(pace: Pace.fast, weeklyRate: 0.22);
      expect(targetForDay(prevWeekAvg: 1, speed: speed), 0);
    });
  });

  group('dayWindows', () {
    test('clusters morning and evening peaks, densest first', () {
      // Morning cluster 7–9, evening cluster 19–21, quiet night.
      final histogram = List.filled(24, 0);
      for (final h in [7, 8, 9]) {
        histogram[h] = 6;
      }
      for (final h in [19, 20, 21]) {
        histogram[h] = 4;
      }
      histogram[3] = 1; // Noise far below threshold.

      final windows = dayWindows(histogram, maxWindows: 2);
      expect(windows, hasLength(2));
      // Densest first: the morning block.
      expect(windows.first.startMinute, 7 * 60);
      expect(windows.first.endMinute, 10 * 60);
    });

    test('empty histogram yields no windows', () {
      expect(dayWindows(List.filled(24, 0)), isEmpty);
    });

    test('cyclic wrap merges late-night block across midnight', () {
      final histogram = List.filled(24, 0);
      for (final h in [22, 23, 0, 1]) {
        histogram[h] = 5;
      }
      final windows = dayWindows(histogram);
      expect(windows, hasLength(1));
      expect(windows.single.startMinute, 22 * 60);
      expect(windows.single.endMinute, 2 * 60);
      // Cyclic windows spanning midnight read as (start, 1440) + (0, end) —
      // a single merged block keeps its covering range.
    });
  });

  group('medianGapMinutes', () {
    test('null for fewer than two events', () {
      expect(medianGapMinutes(const []), isNull);
      expect(medianGapMinutes([DateTime(2026, 9, 1, 8)]), isNull);
    });

    test('median of sorted gaps (odd count)', () {
      final events = [
        DateTime(2026, 9, 1, 8, 0),
        DateTime(2026, 9, 1, 9, 0), // 60
        DateTime(2026, 9, 1, 10, 30), // 90
        DateTime(2026, 9, 1, 13, 0), // 150
      ];
      expect(medianGapMinutes(events), 90);
    });

    test('median of even count averages the middle pair', () {
      final events = [
        DateTime(2026, 9, 1, 8, 0),
        DateTime(2026, 9, 1, 9, 0), // 60
        DateTime(2026, 9, 1, 10, 0), // 60
        DateTime(2026, 9, 1, 12, 0), // 120
      ];
      expect(medianGapMinutes(events), 60);
    });
  });

  group('targetGapRange', () {
    test('median ±25% buffer', () {
      final range = targetGapRange(60);
      expect(range.minGapMinutes, 45);
      expect(range.maxGapMinutes, 75);
    });

    test('min-only rule drops the upper bound', () {
      final range = targetGapRange(60, minOnly: true);
      expect(range.minGapMinutes, 45);
      expect(range.maxGapMinutes, isNull);
    });

    test('null median yields open range', () {
      final range = targetGapRange(null);
      expect(range.minGapMinutes, 0);
      expect(range.maxGapMinutes, isNull);
    });
  });

  group('nextSuggestion', () {
    final now = DateTime(2026, 9, 7, 12, 0);

    test('last + median gap at plan pace', () {
      final suggestion = nextSuggestion(
        now: now,
        lastCigarette: DateTime(2026, 9, 7, 11, 0),
        medianGap: 60,
        smokedToday: 2,
        targetToday: 8,
        minutesAwake: 360,
        wakingDayMinutes: 960,
      );
      // plannedRate = 8/960, actualRate = 2/360 < planned → factor 1.
      expect(suggestion, DateTime(2026, 9, 7, 12, 0));
    });

    test('delays when pacing over plan', () {
      final suggestion = nextSuggestion(
        now: now,
        lastCigarette: DateTime(2026, 9, 7, 11, 0),
        medianGap: 60,
        smokedToday: 6,
        targetToday: 8,
        minutesAwake: 360,
        wakingDayMinutes: 960,
      );
      // actualRate 6/360 = 1/60 per min vs planned 1/120 → factor 2 → +120.
      expect(suggestion, DateTime(2026, 9, 7, 13, 0));
    });

    test('null once the daily budget is used up', () {
      expect(
        nextSuggestion(
          now: now,
          lastCigarette: DateTime(2026, 9, 7, 11, 0),
          medianGap: 60,
          smokedToday: 8,
          targetToday: 8,
          minutesAwake: 360,
          wakingDayMinutes: 960,
        ),
        isNull,
      );
    });

    test('null without last cigarette or median gap', () {
      expect(
        nextSuggestion(
          now: now,
          lastCigarette: null,
          medianGap: 60,
          smokedToday: 1,
          targetToday: 8,
          minutesAwake: 60,
          wakingDayMinutes: 960,
        ),
        isNull,
      );
      expect(
        nextSuggestion(
          now: now,
          lastCigarette: DateTime(2026, 9, 7, 11, 0),
          medianGap: null,
          smokedToday: 1,
          targetToday: 8,
          minutesAwake: 60,
          wakingDayMinutes: 960,
        ),
        isNull,
      );
    });
  });

  group('redistributeDay', () {
    final now = DateTime(2026, 9, 7, 15, 0);
    final dayEnd = DateTime(2026, 9, 8, 0, 0);

    test('spreads remaining budget over remaining minutes', () {
      final result = redistributeDay(
        now: now,
        targetToday: 10,
        smokedToday: 5,
        dayEnd: dayEnd,
        todayEvents: List.generate(
          5,
          (i) => DateTime(2026, 9, 7, 8 + i),
        ),
        medianGap: 60,
      );
      // Remaining: 5 cigarettes over 540 minutes → ≥108 min gaps.
      expect(result.remainingBudget, 5);
      expect(result.minGapMinutes, 108);
      expect(result.messageKey, 'recalculated');
      expect(result.completedDay, isFalse);
    });

    test('completed day when budget is exhausted', () {
      final result = redistributeDay(
        now: now,
        targetToday: 5,
        smokedToday: 6,
        dayEnd: dayEnd,
        todayEvents: const [],
        medianGap: 60,
      );
      expect(result.completedDay, isTrue);
      expect(result.remainingBudget, 0);
      expect(result.messageKey, 'completed');
    });

    test('clustered pattern switches the message', () {
      // Last three gaps of 20 min vs median 60 → clustered.
      final events = [
        DateTime(2026, 9, 7, 10, 0),
        DateTime(2026, 9, 7, 11, 0),
        DateTime(2026, 9, 7, 12, 0),
        DateTime(2026, 9, 7, 12, 20),
        DateTime(2026, 9, 7, 12, 40),
        DateTime(2026, 9, 7, 13, 0),
      ];
      final result = redistributeDay(
        now: now,
        targetToday: 10,
        smokedToday: 6,
        dayEnd: dayEnd,
        todayEvents: events,
        medianGap: 60,
      );
      expect(result.messageKey, 'clustered');
    });

    test('no cluster with sparse history', () {
      final events = [
        DateTime(2026, 9, 7, 9, 0),
        DateTime(2026, 9, 7, 12, 0),
        DateTime(2026, 9, 7, 14, 0),
      ];
      final result = redistributeDay(
        now: now,
        targetToday: 10,
        smokedToday: 3,
        dayEnd: dayEnd,
        todayEvents: events,
        medianGap: 150,
      );
      expect(result.messageKey, 'recalculated');
    });
  });

  group('isClusteredPattern', () {
    test('requires at least four events and a median', () {
      expect(
        isClusteredPattern([DateTime(2026, 9, 7, 9)], medianGap: 60),
        isFalse,
      );
      final two = [
        DateTime(2026, 9, 7, 9, 0),
        DateTime(2026, 9, 7, 9, 10),
      ];
      expect(isClusteredPattern(two, medianGap: 60), isFalse);
    });
  });

  group('tempoDecision', () {
    test('adherence ≥85% suggests faster', () {
      expect(tempoDecision(adherence7: 0.85), TempoDecision.suggestFaster);
      expect(tempoDecision(adherence7: 0.95), TempoDecision.suggestFaster);
    });

    test('adherence ≤55% extends the phase', () {
      expect(tempoDecision(adherence7: 0.55), TempoDecision.extendPhase);
      expect(tempoDecision(adherence7: 0.40), TempoDecision.extendPhase);
    });

    test('in between keeps', () {
      expect(tempoDecision(adherence7: 0.70), TempoDecision.keep);
    });
  });

  group('phaseForTarget', () {
    test('final week at ≤3/day, reduction above', () {
      expect(phaseForTarget(3), PlanPhase.finalWeek);
      expect(phaseForTarget(2), PlanPhase.finalWeek);
      expect(phaseForTarget(4), PlanPhase.reduction);
    });
  });

  group('quitWeeksEstimate', () {
    test('already at threshold → one week both ends', () {
      final estimate =
          quitWeeksEstimate(last7DayAvg: 2.5, pace: Pace.standard);
      expect(estimate, isNotNull);
      expect(estimate!.minWeeks, 1);
      expect(estimate.maxWeeks, 1);
    });

    test('interval is two-sided and ordered (fast ≤ slow)', () {
      final estimate = quitWeeksEstimate(last7DayAvg: 15, pace: Pace.standard);
      expect(estimate, isNotNull);
      expect(estimate!.minWeeks, lessThanOrEqualTo(estimate.maxWeeks));
      // 15 → 3 needs ln(5) ≈ 1.61 halvings… at 15%/week:
      // ln(5)/−ln(0.85) ≈ 9.9 → 10; at 12%: ln(5)/−ln(0.88) ≈ 12.6 → 13.
      expect(estimate.minWeeks, 10);
      expect(estimate.maxWeeks, 13);
    });

    test('capped at 52 weeks', () {
      final estimate = quitWeeksEstimate(last7DayAvg: 40, pace: Pace.calm);
      expect(estimate!.maxWeeks, lessThanOrEqualTo(52));
    });
  });
}
