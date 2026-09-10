/// The clinical skeleton of a quit attempt (premium brief §C).
///
/// Everything before this file measured the person. This file is the part
/// that actually *treats*: a reason to quit, a date to quit on, the drugs
/// that double the odds, a plan for the situations that break people, and
/// the single most important teaching in relapse prevention — that one
/// cigarette is a lapse, not the end of the attempt.
///
/// Honesty rules carry over unchanged. Nothing here predicts an individual
/// outcome; the effect sizes are population figures from published
/// meta-analyses and are always shown as such, with their source.
library;

import 'entities.dart';

/// Why the person is quitting.
///
/// Asked in their own words at onboarding and shown back to them at the
/// moment of a craving. This is the motivational-interviewing move the app
/// was missing: a reason a person states themselves outperforms a reason
/// the app supplies.
enum QuitReason {
  children,
  health,
  money,
  freedom,
  smell,
  fitness,
  someoneAsked,
}

/// How a quit date relates to today.
enum QuitDateWindow {
  /// In the past — the attempt has started.
  started,

  /// Within a fortnight. The evidence-backed sweet spot: near enough to be
  /// real, far enough to prepare.
  soon,

  /// Two to six weeks out. Workable, and the reduction plan has room.
  planned,

  /// Beyond six weeks. Far enough that intention decays; the app says so
  /// rather than silently accepting it.
  distant,
}

/// The recommended window for setting a quit date, in days from today.
abstract final class QuitDateGuidance {
  /// Closer than this and there is no time to prepare (get NRT, tell people,
  /// clear the house).
  static const int minPreparationDays = 3;

  /// Beyond this, a date stops functioning as a commitment.
  static const int maxUsefulDays = 42;

  /// The default offered: two weeks out.
  static const int suggestedDays = 14;

  static QuitDateWindow windowFor({
    required DateTime quitDate,
    required DateTime now,
  }) {
    final days = _wholeDaysBetween(now, quitDate);
    if (days < 0) {
      return QuitDateWindow.started;
    }
    if (days <= 14) {
      return QuitDateWindow.soon;
    }
    return days <= maxUsefulDays
        ? QuitDateWindow.planned
        : QuitDateWindow.distant;
  }

  /// Whole days from [from] to [to], counting calendar days rather than
  /// 24-hour blocks so a date set "tomorrow" reads as 1 all day today.
  static int daysUntil(DateTime from, DateTime to) =>
      _wholeDaysBetween(from, to);
}

int _wholeDaysBetween(DateTime from, DateTime to) {
  final a = DateTime(from.year, from.month, from.day);
  final b = DateTime(to.year, to.month, to.day);
  return b.difference(a).inDays;
}

/// What a cigarette during a quit attempt actually was.
///
/// Marlatt's distinction, and the single most useful thing an app can teach
/// here: people who read a lapse as total failure abandon the attempt, and
/// people who read it as one event usually carry on. The app never punishes
/// a record — but it does have to *name* what happened, because a silence
/// after a slip is filled by the user's own worst reading of it.
enum SlipVerdict {
  /// No cigarette since the quit date.
  none,

  /// One, or a handful in a week. A lapse.
  lapse,

  /// Slips are clustering — the attempt is under real pressure.
  clustering,

  /// Back at or near the old daily rate.
  relapse,
}

/// Classifies what has happened since the quit date.
///
/// [recentCpd] and [baselineCpd] are the user's own numbers, so "back to
/// daily" means back to *their* daily, not a population threshold.
SlipVerdict slipVerdict({
  required int slipsInLastWeek,
  required double recentCpd,
  required double baselineCpd,
}) {
  if (slipsInLastWeek == 0) {
    return SlipVerdict.none;
  }
  if (baselineCpd > 0 && recentCpd >= baselineCpd * 0.7) {
    return SlipVerdict.relapse;
  }
  if (slipsInLastWeek >= 4) {
    return SlipVerdict.clustering;
  }
  return SlipVerdict.lapse;
}

/// A two-item depression screen (PHQ-2).
///
/// Included because stopping smoking can unmask or worsen low mood in people
/// who are prone to it, and an app that watches someone's mood every day and
/// never asks the obvious question is negligent. Two items, each 0-3, over
/// the last two weeks.
///
/// **It is a screen, not a diagnosis.** At or above the validated cut-off
/// the only thing the app does is say so plainly and point at a professional.
abstract final class Phq2 {
  /// Validated cut-off for a positive screen.
  static const int threshold = 3;

  /// Maximum possible score.
  static const int maxScore = 6;

  static int score({required int lowInterest, required int lowMood}) =>
      lowInterest.clamp(0, 3) + lowMood.clamp(0, 3);

  static bool isPositive(int score) => score >= threshold;
}

/// A licensed stop-smoking medicine.
///
/// The app carries information and a referral, never a recommendation, a
/// dose or a brand. That boundary is why this is an enum of forms rather
/// than a catalogue of products.
enum StopSmokingMedicine {
  nicotinePatch,
  nicotineGum,
  nicotineLozenge,
  nicotineSpray,
  nicotineInhalator,
  combinationNrt,
  varenicline,
  bupropion,
}

/// Published effect sizes, as risk ratios for abstinence versus placebo (or,
/// for [StopSmokingMedicine.combinationNrt], versus single-form NRT).
///
/// Sources are shipped with the content, not hidden here: these are the
/// headline figures from the Cochrane reviews of nicotine replacement
/// therapy, varenicline and bupropion. They are population estimates. The
/// app never multiplies them by anything to produce a personal number.
abstract final class MedicineEvidence {
  static const Map<StopSmokingMedicine, double> riskRatio = {
    StopSmokingMedicine.nicotinePatch: 1.55,
    StopSmokingMedicine.nicotineGum: 1.55,
    StopSmokingMedicine.nicotineLozenge: 1.55,
    StopSmokingMedicine.nicotineSpray: 1.55,
    StopSmokingMedicine.nicotineInhalator: 1.55,
    StopSmokingMedicine.combinationNrt: 1.25,
    StopSmokingMedicine.varenicline: 2.24,
    StopSmokingMedicine.bupropion: 1.64,
  };

  /// True when the ratio compares against single-form NRT rather than
  /// placebo — the comparator has to travel with the number or the number
  /// is misleading.
  static bool comparesToSingleNrt(StopSmokingMedicine medicine) =>
      medicine == StopSmokingMedicine.combinationNrt;

  /// Prescription-only in most markets, so the app can describe it but must
  /// route the user to a clinician.
  static bool needsPrescription(StopSmokingMedicine medicine) =>
      medicine == StopSmokingMedicine.varenicline ||
      medicine == StopSmokingMedicine.bupropion;
}

/// Whether the heaviness of this person's smoking is the kind that the
/// guidelines say benefits most from combination therapy.
///
/// HSI 0-6; 4 and above is the conventional "highly dependent" band. The app
/// uses it to decide what to *show*, never to prescribe.
bool suggestsCombinationTherapy({required int? hsi, required double baselineCpd}) =>
    (hsi != null && hsi >= 4) || baselineCpd >= 20;

/// One high-risk situation and the person's own plan for it.
///
/// Built from the triggers they already told the app about at onboarding, so
/// the plan starts half-written rather than as an empty form — an empty
/// relapse-prevention form is one nobody fills in.
class CopingPlan {
  const CopingPlan({
    required this.trigger,
    required this.plan,
    this.rehearsed = false,
  });

  final TriggerLabel trigger;

  /// What the person will do instead, in their words.
  final String plan;

  /// Whether they have marked it as something they have actually done.
  final bool rehearsed;

  bool get isEmpty => plan.trim().isEmpty;
}

/// The state of a quit attempt.
class CessationState {
  const CessationState({
    this.quitDate,
    this.quitDateMoves = 0,
    this.reason,
    this.supportPerson,
    this.notAPuffAccepted = false,
    this.copingPlans = const [],
    this.lastMoodScreen,
    this.lastMoodScore,
  });

  /// The date the person intends to stop, or has stopped.
  final DateTime? quitDate;

  /// How many times the date has been moved. Moving it is allowed and is
  /// never scolded; it is counted because a date moved repeatedly is a
  /// signal worth reflecting back.
  final int quitDateMoves;

  final QuitReason? reason;

  /// First name or nickname only — the app stores no contact details.
  final String? supportPerson;

  /// Whether they have taken the "not a single puff" rule.
  final bool notAPuffAccepted;

  final List<CopingPlan> copingPlans;

  final DateTime? lastMoodScreen;
  final int? lastMoodScore;

  bool get hasQuitDate => quitDate != null;

  /// Ready to face the date: a reason, a plan for the top triggers, someone
  /// told, and the rule taken.
  int readinessSteps({required int totalSteps}) {
    var done = 0;
    if (hasQuitDate) done++;
    if (reason != null) done++;
    if (copingPlans.any((p) => !p.isEmpty)) done++;
    if (supportPerson != null && supportPerson!.trim().isNotEmpty) done++;
    if (notAPuffAccepted) done++;
    return done.clamp(0, totalSteps);
  }

  /// A mood screen is offered again after a fortnight.
  bool moodScreenDue(DateTime now) =>
      lastMoodScreen == null ||
      now.difference(lastMoodScreen!).inDays >= 14;
}
