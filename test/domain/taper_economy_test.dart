import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/craving_risk.dart';
import 'package:halen/domain/economy.dart';
import 'package:halen/domain/lung_model.dart';
import 'package:halen/domain/plan_kinds.dart';
import 'package:halen/domain/soft_taper.dart';

void main() {
  group('soft taper', () {
    test('a gentle step never grows the interval by more than 15%', () {
      final step = nextInterval(
        currentIntervalMinutes: 60,
        targetIntervalMinutes: 180,
        daysAtStep: 5,
        adherenceAtStep: 0.9,
      );
      expect(step.intervalMinutes, 69);
      expect(step.decision, TaperDecision.advance);
    });

    test('fast mode steps harder but stays bounded', () {
      final step = nextInterval(
        currentIntervalMinutes: 60,
        targetIntervalMinutes: 180,
        daysAtStep: 5,
        adherenceAtStep: 0.9,
        mode: TaperMode.fast,
      );
      expect(step.intervalMinutes, 75);
    });

    test('a step holds before three days', () {
      final step = nextInterval(
        currentIntervalMinutes: 60,
        targetIntervalMinutes: 180,
        daysAtStep: 2,
        adherenceAtStep: 1,
      );
      expect(step.intervalMinutes, 60);
      expect(step.decision, TaperDecision.holdShortStep);
    });

    test('low adherence repeats the step instead of rolling back', () {
      final step = nextInterval(
        currentIntervalMinutes: 60,
        targetIntervalMinutes: 180,
        daysAtStep: 7,
        adherenceAtStep: 0.5,
      );
      expect(step.intervalMinutes, 60);
      expect(step.decision, TaperDecision.holdLowAdherence);
    });

    test('the step never overshoots the final target', () {
      final step = nextInterval(
        currentIntervalMinutes: 175,
        targetIntervalMinutes: 180,
        daysAtStep: 5,
        adherenceAtStep: 1,
      );
      expect(step.intervalMinutes, 180);
    });

    test('soft landing averages the last three successful days', () {
      expect(
        softLanding(
          successfulDayIntervals: const [40, 50, 60, 70, 80],
          fallbackIntervalMinutes: 30,
        ),
        70,
      );
      expect(
        softLanding(
          successfulDayIntervals: const [],
          fallbackIntervalMinutes: 45,
        ),
        45,
      );
    });

    test('step adherence counts days that met the target', () {
      expect(
        stepAdherence(
          achievedIntervals: const [60, 70, 50, 80],
          targetInterval: 60,
        ),
        0.75,
      );
      expect(
        stepAdherence(achievedIntervals: const [], targetInterval: 60),
        0,
      );
    });

    test('the hardest hours are tapered last', () {
      final histogram = List.filled(24, 1);
      histogram[8] = 20; // wake-up
      histogram[21] = 15; // evening peak
      final order = taperOrderForHours(histogram, wakeHour: 8);
      expect(order.length, 24);
      expect(order.last, anyOf(8, 21));
      expect(order.sublist(order.length - 3), contains(8));
      expect(order.first, isNot(8));
    });

    test('daily budget follows from the interval', () {
      expect(budgetForInterval(intervalMinutes: 60), 16);
      expect(budgetForInterval(intervalMinutes: 0), 0);
    });
  });

  group('plan system', () {
    test('track only can always be left', () {
      expect(
        canSwitchPlan(
          current: PlanKind.trackOnly,
          daysInCurrentPlan: 0,
          switchesLast30Days: 5,
        ),
        SwitchVerdict.allowed,
      );
    });

    test('a plan needs seven days before a switch', () {
      expect(
        canSwitchPlan(
          current: PlanKind.gradualTaper,
          daysInCurrentPlan: 3,
          switchesLast30Days: 0,
        ),
        SwitchVerdict.tooSoon,
      );
    });

    test('frequent switching still allows the switch, with a note', () {
      expect(
        canSwitchPlan(
          current: PlanKind.gradualTaper,
          daysInCurrentPlan: 10,
          switchesLast30Days: 3,
        ),
        SwitchVerdict.allowedWithNote,
      );
    });

    test('an irregular smoker is pointed at the daily quota plan', () {
      expect(
        suggestedPlan(
          current: PlanKind.gradualTaper,
          intervalVariationCoefficient: 0.9,
          adherence: 0.5,
          wantsToQuitNow: false,
        ),
        PlanKind.dailyQuota,
      );
    });

    test('a regular, adherent quota user is offered the taper', () {
      expect(
        suggestedPlan(
          current: PlanKind.dailyQuota,
          intervalVariationCoefficient: 0.3,
          adherence: 0.8,
          wantsToQuitNow: false,
        ),
        PlanKind.gradualTaper,
      );
    });

    test('no suggestion when the current plan fits', () {
      expect(
        suggestedPlan(
          current: PlanKind.gradualTaper,
          intervalVariationCoefficient: 0.2,
          adherence: 0.9,
          wantsToQuitNow: false,
        ),
        isNull,
      );
    });

    test('variation coefficient separates regular from erratic rhythms', () {
      final base = DateTime(2026, 9, 8, 8);
      final regular = [
        for (var i = 0; i < 8; i++) base.add(Duration(minutes: 60 * i)),
      ];
      final erratic = [
        base,
        base.add(const Duration(minutes: 5)),
        base.add(const Duration(minutes: 10)),
        base.add(const Duration(minutes: 400)),
        base.add(const Duration(minutes: 405)),
      ];
      expect(intervalVariationCoefficient(regular), lessThan(0.1));
      expect(intervalVariationCoefficient(erratic), greaterThan(0.7));
    });
  });

  group('economy', () {
    const economy = Economy(pricePerPack: 100, packSize: 20);

    test('per-cigarette price and pack equivalents', () {
      expect(economy.perCigarette, 5);
      expect(economy.saved(10), 50);
      expect(economy.spent(4), 20);
      expect(economy.packsEquivalent(250), 2.5);
    });

    test('a zero pack size cannot divide by zero', () {
      expect(const Economy(pricePerPack: 100, packSize: 0).perCigarette, 0);
    });

    test('baseline uses measured days, not the onboarding claim', () {
      expect(
        Economy.baselineFromFirstWeek(
          firstWeekDailyCounts: const [18, 22, 20],
          onboardingCpd: 10,
        ),
        20,
      );
      expect(
        Economy.baselineFromFirstWeek(
          firstWeekDailyCounts: const [18],
          onboardingCpd: 10,
        ),
        10,
      );
    });

    test('projection separates the two scenarios and their gap', () {
      final points = economy.projection(
        currentCpd: 20,
        planCpd: List.filled(365, 5),
        days: 28,
        step: 7,
      );
      expect(points.first.dayIndex, 0);
      expect(points.last.dayIndex, 28);
      expect(points.last.keepThisPace, closeTo(28 * 20 * 5, 1e-9));
      expect(points.last.finishThePlan, closeTo(28 * 5 * 5, 1e-9));
      expect(points.last.difference, greaterThan(0));
    });

    test('an empty plan path projects a completed plan at zero', () {
      final points = economy.projection(
        currentCpd: 20,
        planCpd: const [],
        days: 7,
        step: 7,
      );
      expect(points.last.finishThePlan, 0);
    });

    test('the time ledger uses the published per-sex averages', () {
      expect(economy.timeRegained(3), const Duration(minutes: 60));
      const male = Economy(pricePerPack: 100, packSize: 20, sex: SexOption.male);
      const female =
          Economy(pricePerPack: 100, packSize: 20, sex: SexOption.female);
      expect(male.timeLost(1), const Duration(minutes: 17));
      expect(female.timeLost(1), const Duration(minutes: 22));
    });

    test('a savings goal reports progress and days remaining', () {
      const goal = SavingsGoal(label: 'Trip', amount: 1000);
      expect(goal.progress(250), 0.25);
      expect(goal.progress(5000), 1.0);
      expect(goal.daysRemaining(250, 50), 15);
      expect(goal.daysRemaining(250, 0), isNull);
    });
  });

  group('lung scenarios', () {
    test('quitting today beats keeping the pace at every later age', () {
      final gap = scenarioGapAt(fromAge: 40, atAge: 70, cigarettesPerDay: 20);
      expect(gap, greaterThan(0));
    });

    test('a heavier intake declines faster', () {
      expect(
        Fev1Decline.forIntake(20),
        greaterThan(Fev1Decline.forIntake(5)),
      );
      expect(Fev1Decline.forIntake(20), Fev1Decline.currentSmokerHeavy);
    });

    test('curves stay inside 0-100 and start at the current age', () {
      final curve = typicalFev1Curve(
        scenario: LungScenario.keepThisPace,
        fromAge: 35,
        cigarettesPerDay: 20,
      );
      expect(curve.first.age, 35);
      expect(curve.last.age, 80);
      expect(curve.every((p) => p.percentOfPeak >= 0 && p.percentOfPeak <= 100),
          isTrue);
    });

    test('mist level tracks the relative particle load', () {
      expect(mistLevel(tarLoadVsBaseline: 0), 0);
      expect(mistLevel(tarLoadVsBaseline: 50), 0.5);
      expect(mistLevel(tarLoadVsBaseline: 200), 1.0);
    });
  });

  group('craving risk', () {
    final day = DateTime(2026, 9, 8);
    List<DateTime> hourlyEvents(int count) => [
          for (var i = 0; i < count; i++)
            day.add(Duration(hours: 8 + (i % 12), minutes: (i * 7) % 60)),
        ];

    CravingRiskModel modelFor(List<DateTime> events) {
      final histogram = List.filled(24, 0);
      for (final e in events) {
        histogram[e.hour]++;
      }
      return CravingRiskModel(
        events: events,
        hourlyHistogram: histogram,
        triggerHourWeights: List.filled(24, 0.5),
      );
    }

    test('weights are published and sum to one', () {
      expect(
        CravingRiskWeights.trough +
            CravingRiskWeights.hourPattern +
            CravingRiskWeights.triggerContext,
        closeTo(1.0, 1e-9),
      );
    });

    test('risk rises as the trough deepens', () {
      final model = modelFor(hourlyEvents(40));
      final justSmoked = model.events.last;
      expect(
        model.riskAt(justSmoked.add(const Duration(hours: 4))),
        greaterThan(model.riskAt(justSmoked)),
      );
    });

    test('too little data suppresses the hour-based signals', () {
      final model = modelFor(hourlyEvents(5));
      expect(model.hasEnoughData, isFalse);
      expect(model.hourSignal(day.add(const Duration(hours: 9))), 0);
      expect(model.topRiskWindows(day), isEmpty);
    });

    test('windows appear once there is enough history', () {
      final model = modelFor(hourlyEvents(60));
      expect(model.topRiskWindows(day).length, inInclusiveRange(1, 2));
    });

    test('scores stay inside 0-100 and map to bands', () {
      final model = modelFor(hourlyEvents(40));
      final score = model.riskAt(day.add(const Duration(hours: 15)));
      expect(score, inInclusiveRange(0, 100));
      expect(riskBandFor(10), RiskBand.calm);
      expect(riskBandFor(50), RiskBand.watch);
      expect(riskBandFor(90), RiskBand.high);
    });

    test('the lowest-third share needs enough cravings to be reported', () {
      final events = hourlyEvents(40);
      expect(
        cravingsInLowestThird(cravings: const [], events: events),
        isNull,
      );
      final cravings = [
        for (var i = 0; i < 12; i++)
          events.last.add(Duration(hours: 6 + i * 24)),
      ];
      expect(
        cravingsInLowestThird(cravings: cravings, events: events),
        greaterThan(0.8),
      );
    });
  });
}
