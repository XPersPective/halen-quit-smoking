import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/cessation.dart';
import 'package:halen/domain/entities.dart';

void main() {
  group('quit date', () {
    final now = DateTime(2026, 9, 10, 14, 30);

    test('counts calendar days, not 24-hour blocks', () {
      // Set late at night, "tomorrow" must still read as 1 all day today.
      expect(
        QuitDateGuidance.daysUntil(
          DateTime(2026, 9, 10, 23, 55),
          DateTime(2026, 9, 11, 0, 5),
        ),
        1,
      );
    });

    test('windows follow the preparation guidance', () {
      QuitDateWindow at(int days) => QuitDateGuidance.windowFor(
            quitDate: now.add(Duration(days: days)),
            now: now,
          );
      expect(at(-1), QuitDateWindow.started);
      expect(at(0), QuitDateWindow.soon);
      expect(at(14), QuitDateWindow.soon);
      expect(at(21), QuitDateWindow.planned);
      expect(at(60), QuitDateWindow.distant);
    });

    test('the suggested default sits inside the useful window', () {
      expect(
        QuitDateGuidance.suggestedDays,
        inInclusiveRange(
          QuitDateGuidance.minPreparationDays,
          QuitDateGuidance.maxUsefulDays,
        ),
      );
    });
  });

  group('lapse versus relapse', () {
    SlipVerdict verdict({
      required int slips,
      double recent = 1,
      double baseline = 20,
    }) =>
        slipVerdict(
          slipsInLastWeek: slips,
          recentCpd: recent,
          baselineCpd: baseline,
        );

    test('no cigarettes is no verdict at all', () {
      expect(verdict(slips: 0), SlipVerdict.none);
    });

    test('one is a lapse, and stays a lapse', () {
      expect(verdict(slips: 1), SlipVerdict.lapse);
      expect(verdict(slips: 3), SlipVerdict.lapse);
    });

    test('four in a week is clustering', () {
      expect(verdict(slips: 4, recent: 0.6), SlipVerdict.clustering);
    });

    test('relapse is measured against the person own baseline', () {
      // 15 a day is a relapse for someone who smoked 20...
      expect(
        verdict(slips: 40, recent: 15, baseline: 20),
        SlipVerdict.relapse,
      );
      // ...and not yet for someone who smoked 40.
      expect(
        verdict(slips: 40, recent: 15, baseline: 40),
        SlipVerdict.clustering,
      );
    });

    test('no baseline never produces a relapse verdict', () {
      expect(verdict(slips: 5, recent: 9, baseline: 0), SlipVerdict.clustering);
    });
  });

  group('PHQ-2', () {
    test('scores the two items and clamps out-of-range answers', () {
      expect(Phq2.score(lowInterest: 0, lowMood: 0), 0);
      expect(Phq2.score(lowInterest: 3, lowMood: 3), Phq2.maxScore);
      expect(Phq2.score(lowInterest: 9, lowMood: -2), 3);
    });

    test('uses the validated cut-off', () {
      expect(Phq2.isPositive(Phq2.threshold - 1), isFalse);
      expect(Phq2.isPositive(Phq2.threshold), isTrue);
    });
  });

  group('medicines', () {
    test('every medicine carries a published effect size', () {
      for (final medicine in StopSmokingMedicine.values) {
        expect(
          MedicineEvidence.riskRatio[medicine],
          isNotNull,
          reason: '$medicine has no ratio',
        );
        expect(MedicineEvidence.riskRatio[medicine], greaterThan(1));
      }
    });

    test('only the combination compares against single-form NRT', () {
      final againstNrt = StopSmokingMedicine.values
          .where(MedicineEvidence.comparesToSingleNrt)
          .toList();
      expect(againstNrt, [StopSmokingMedicine.combinationNrt]);
    });

    test('the prescription-only set is exactly the two tablets', () {
      final prescription = StopSmokingMedicine.values
          .where(MedicineEvidence.needsPrescription)
          .toSet();
      expect(prescription, {
        StopSmokingMedicine.varenicline,
        StopSmokingMedicine.bupropion,
      });
    });

    test('combination therapy is suggested by heaviness, either signal', () {
      expect(suggestsCombinationTherapy(hsi: 4, baselineCpd: 5), isTrue);
      expect(suggestsCombinationTherapy(hsi: null, baselineCpd: 20), isTrue);
      expect(suggestsCombinationTherapy(hsi: 1, baselineCpd: 8), isFalse);
    });
  });

  group('readiness', () {
    test('counts only the steps actually taken', () {
      const empty = CessationState();
      expect(empty.readinessSteps(totalSteps: 5), 0);

      final full = CessationState(
        quitDate: DateTime(2026, 9, 20),
        reason: QuitReason.children,
        supportPerson: 'Ayşe',
        notAPuffAccepted: true,
        copingPlans: const [
          CopingPlan(trigger: TriggerLabel.coffee, plan: 'walk'),
        ],
      );
      expect(full.readinessSteps(totalSteps: 5), 5);
    });

    test('a blank support name does not count as told', () {
      const state = CessationState(supportPerson: '   ');
      expect(state.readinessSteps(totalSteps: 5), 0);
    });

    test('the mood screen comes back round after a fortnight', () {
      final now = DateTime(2026, 9, 10);
      expect(const CessationState().moodScreenDue(now), isTrue);
      expect(
        CessationState(lastMoodScreen: now.subtract(const Duration(days: 3)))
            .moodScreenDue(now),
        isFalse,
      );
      expect(
        CessationState(lastMoodScreen: now.subtract(const Duration(days: 15)))
            .moodScreenDue(now),
        isTrue,
      );
    });
  });
}
