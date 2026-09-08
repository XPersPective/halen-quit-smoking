import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../data/db/app_database.dart';
import '../data/repositories/library_repository.dart';
import '../domain/body_load_model.dart';
import '../domain/craving_risk.dart';
import '../domain/economy.dart';
import '../domain/entities.dart';
import '../domain/harm_load.dart';
import '../domain/lung_model.dart';
import '../domain/plan_kinds.dart';
import '../domain/progress_index.dart';
import '../domain/withdrawal_model.dart';
import 'providers.dart';
import 'record_providers.dart';
import 'taper_controller.dart';

/// Wiring for the module-report features. Every provider here reads only
/// local data and runs a published formula — nothing is fetched, nothing is
/// inferred that the "How is this calculated?" screen does not explain.

final libraryRepositoryProvider =
    Provider<LibraryRepository>((ref) => const LibraryRepository());

/// The user's account row — only the age band is read, and only to give the
/// Harm Load a rough age. The onboarding never asks for a birth date.
final userProfileProvider = FutureProvider<UserProfileRow?>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.profileDao.getUserProfile();
});

/// The user's smoking profile row (null before onboarding completes).
final smokingProfileProvider = FutureProvider<SmokingProfileRow?>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.profileDao.getSmokingProfile();
});

/// Cigarette timestamps, newest last — the input every model shares.
final eventTimestampsProvider = Provider<AsyncValue<List<DateTime>>>((ref) {
  return ref.watch(cigaretteEventsProvider).whenData(
        (rows) => [for (final r in rows) r.ts]..sort(),
      );
});

/// The body-load model, calibrated with the user's chosen metabolism speed.
final bodyLoadModelProvider = Provider<BodyLoadModel>((ref) {
  final profile = ref.watch(smokingProfileProvider).value;
  return BodyLoadModel(
    metabolism: profile?.metabolism ?? MetabolismSpeed.normal,
  );
});

/// "What is in me right now" — the Body Load card header (S3).
final bodyLoadSnapshotProvider = Provider<AsyncValue<BodyLoadSnapshot>>((ref) {
  final model = ref.watch(bodyLoadModelProvider);
  return ref
      .watch(eventTimestampsProvider)
      .whenData((events) => model.snapshot(DateTime.now(), events));
});

/// 24-hour normalized curve for one load kind.
final loadCurveProvider =
    Provider.family<AsyncValue<List<LoadSample>>, LoadKind>((ref, kind) {
  final model = ref.watch(bodyLoadModelProvider);
  final now = DateTime.now();
  return ref.watch(eventTimestampsProvider).whenData(
        (events) => model.normalizedCurve(
          kind,
          now.subtract(const Duration(hours: 24)),
          now,
          events,
        ),
      );
});

/// Relative particle ("tar") load against the user's own baseline (S4).
final tarLoadProvider = Provider<AsyncValue<int>>((ref) {
  final model = ref.watch(bodyLoadModelProvider);
  final profile = ref.watch(smokingProfileProvider).value;
  return ref.watch(eventTimestampsProvider).whenData(
        (events) => model.tarLoadVsBaseline(
          now: DateTime.now(),
          events: events,
          baselineCpd: (profile?.baselineCpd ?? 0).toDouble(),
        ),
      );
});

/// Per-hour share of records that carried a trigger label — the craving
/// model's context signal.
final triggerHourWeightsProvider = Provider<AsyncValue<List<double>>>((ref) {
  return ref.watch(cigaretteEventsProvider).whenData((rows) {
    final totals = List<int>.filled(24, 0);
    final labelled = List<int>.filled(24, 0);
    for (final row in rows) {
      totals[row.ts.hour]++;
      if (row.triggerLabel != null) {
        labelled[row.ts.hour]++;
      }
    }
    return [
      for (var h = 0; h < 24; h++)
        totals[h] == 0 ? 0.0 : labelled[h] / totals[h],
    ];
  });
});

/// The craving-risk forecaster, or null while there is too little data.
final cravingRiskModelProvider = Provider<AsyncValue<CravingRiskModel>>((ref) {
  final events = ref.watch(eventTimestampsProvider);
  final weights = ref.watch(triggerHourWeightsProvider);
  final model = ref.watch(bodyLoadModelProvider);
  return events.whenData((list) {
    final histogram = List<int>.filled(24, 0);
    for (final ts in list) {
      histogram[ts.hour]++;
    }
    return CravingRiskModel(
      events: list,
      hourlyHistogram: histogram,
      triggerHourWeights: weights.value ?? List<double>.filled(24, 0),
      loadModel: model,
    );
  });
});

/// The riskiest stretches of today, empty until there is enough history.
final riskWindowsProvider = Provider<AsyncValue<List<RiskWindow>>>((ref) {
  return ref
      .watch(cravingRiskModelProvider)
      .whenData((model) => model.topRiskWindows(DateTime.now()));
});

/// "X% of your cravings arrived while your load was in the lowest third" —
/// the module's single most persuasive line. Null until it is honest to say.
final cravingsInLowestThirdProvider = Provider<AsyncValue<double?>>((ref) {
  final cravings = ref.watch(cravingEventsProvider).value ??
      const <CravingEventRow>[];
  final model = ref.watch(bodyLoadModelProvider);
  return ref.watch(eventTimestampsProvider).whenData(
        (list) => cravingsInLowestThird(
          cravings: [for (final c in cravings) c.ts],
          events: list,
          model: model,
        ),
      );
});

/// Estimated withdrawal pressure right now, as a band plus its raw value.
@immutable
class MindState {
  const MindState({
    required this.value,
    required this.band,
    required this.accuracy,
  });

  /// Raw estimate 0..1 — stored with the user's report, never displayed bare.
  final double value;
  final PressureBand band;

  /// Share of past estimates that landed in the band the user reported;
  /// null until there are enough reports to say.
  final double? accuracy;
}

final mindStateProvider = FutureProvider<MindState>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final quitTs = ref.watch(timelineStateProvider).value;
  final plan = await db.moduleDao.getPlanState();
  final phaseStart = quitTs ?? plan?.startedAt ?? now;
  final events = ref.watch(eventTimestampsProvider).value ?? const [];
  final riskModel = ref.watch(cravingRiskModelProvider).value;

  final moods = await db.moduleDao.moodsSince(
    now.subtract(const Duration(days: 60)),
  );
  final reports = [
    for (final m in moods)
      (estimated: m.estimated, reported: m.reportedBand / 2),
  ];

  final value = pressureNow(
    daysSincePhaseStart:
        now.difference(phaseStart).inMinutes / (60 * 24),
    trough: riskModel?.troughSignal(now) ??
        (events.isEmpty ? 0.0 : 0.5),
    offset: personalOffset(reports),
  );
  return MindState(
    value: value,
    band: bandForPressure(value),
    accuracy: estimateAccuracy(reports),
  );
});

/// Records how the user actually feels, so the model can learn its offset.
final moodReportProvider = Provider<Future<void> Function(int, double)>((ref) {
  return (band, estimated) async {
    final db = ref.read(databaseProvider);
    await db.moduleDao.insertMood(
      MoodLogCompanion.insert(
        ts: DateTime.now(),
        reportedBand: band,
        estimated: estimated,
      ),
    );
    ref.invalidate(mindStateProvider);
  };
});

/// The money and time ledger, built from the user's own profile.
final economyProvider = Provider<AsyncValue<Economy>>((ref) {
  return ref.watch(smokingProfileProvider).whenData(
        (profile) => Economy(
          pricePerPack: profile?.pricePerPack ?? 0,
          packSize: profile?.packSize ?? 20,
          sex: profile?.sex ?? SexOption.unspecified,
        ),
      );
});

/// The user's own savings goal, when they set one.
final savingsGoalProvider = StreamProvider<SavingsGoalRow?>((ref) {
  return ref.watch(databaseProvider).moduleDao.watchSavingsGoal();
});

/// Measured baseline (first week of real records), never the onboarding
/// claim once enough days exist.
final measuredBaselineProvider = FutureProvider<double>((ref) async {
  final db = ref.watch(databaseProvider);
  final profile = await ref.watch(smokingProfileProvider.future);
  if (profile == null) {
    return 0;
  }
  final summaries = await db.statsDao.getSummariesBetween(
    dayKey(profile.startedAt),
    dayKey(profile.startedAt.add(const Duration(days: 7))),
  );
  return Economy.baselineFromFirstWeek(
    firstWeekDailyCounts: [for (final s in summaries) s.count],
    onboardingCpd: profile.baselineCpd,
  );
});

/// The active plan row, created on first read.
final planStateProvider = StreamProvider<PlanStateRow?>((ref) {
  return ref.watch(databaseProvider).moduleDao.watchPlanState();
});

/// Both indices plus their history — the twin gauge card and the scissor
/// chart read this single provider.
@immutable
class IndicesState {
  const IndicesState({
    required this.progress,
    required this.harm,
    required this.progressHistory,
    required this.harmHistory,
    required this.delta7d,
  });

  final ProgressResult progress;
  final HarmResult harm;
  final List<int> progressHistory;
  final List<int> harmHistory;
  final int delta7d;
}

final indicesProvider = FutureProvider<IndicesState>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final profile = await ref.watch(smokingProfileProvider.future);
  final baseline = await ref.watch(measuredBaselineProvider.future);
  final events = ref.watch(eventTimestampsProvider).value ?? const [];
  final cravings = ref.watch(cravingEventsProvider).value ?? const [];

  final windowStart = dayStartMinusDays(now, progressWindowDays - 1);
  final summaries = await db.statsDao.getSummariesBetween(
    dayKey(windowStart),
    dayKey(now),
  );
  final adherences = [
    for (final s in summaries)
      if (s.adherence != null) s.adherence!,
  ];
  final recentCounts = [for (final s in summaries) s.count];
  final recentCpd = recentCounts.isEmpty
      ? 0.0
      : recentCounts.reduce((a, b) => a + b) / recentCounts.length;

  final windowCravings =
      cravings.where((c) => c.ts.isAfter(windowStart)).toList();
  final model = ref.watch(bodyLoadModelProvider);
  final baselineNow = model.normalizedNow(
    LoadKind.nicotineBaseline,
    now,
    events,
    window: const Duration(days: 14),
  );

  final history = await db.moduleDao.indexSnapshotsSince(
    dayKey(dayStartMinusDays(now, 89)),
  );
  final previous = await db.moduleDao.latestIndexSnapshot();

  final progress = progressScore(
    ProgressInputs(
      adherence14d: adherences.isEmpty
          ? 0
          : adherences.reduce((a, b) => a + b) / adherences.length,
      baselineCpd: baseline,
      recentCpd: recentCpd,
      cravingsResisted: windowCravings
          .where((c) => c.outcome == CravingOutcome.resisted)
          .length,
      cravingsTotal: windowCravings.length,
      daysLogged: summaries.where((s) => s.count > 0).length,
      daysInWindow: summaries.isEmpty ? progressWindowDays : summaries.length,
      nicotineBaselineFall: 1 - baselineNow / 100,
    ),
    previousScore:
        previous?.date == dayKey(now) ? null : previous?.progressScore,
  );

  final quitTs = ref.watch(timelineStateProvider).value;
  final user = await ref.watch(userProfileProvider.future);
  final harm = harmLoad(
    HarmInputs(
      ageYears: midpointAge(user?.ageBand),
      smokingYears: profile?.smokingYears ?? 10,
      baselineCpd: baseline,
      recentCpd: recentCpd,
      hsi: profile?.hsi ?? _hsiFromProfile(profile),
      bmi: bmiFrom(
        heightCm: profile?.heightCm,
        weightKg: profile?.weightKg,
      ),
      yearsSinceQuit: quitTs == null
          ? 0
          : now.difference(quitTs).inDays / 365.0,
    ),
  );

  await db.moduleDao.putIndexSnapshot(
    date: dayKey(now),
    progressScore: progress.score,
    harmLoad: harm.score,
  );

  final progressHistory = [
    for (final row in history)
      if (row.date != dayKey(now)) row.progressScore,
    progress.score,
  ];
  return IndicesState(
    progress: progress,
    harm: harm,
    progressHistory: progressHistory,
    harmHistory: [
      for (final row in history)
        if (row.date != dayKey(now)) row.harmLoad,
      harm.score,
    ],
    delta7d: progressDelta(progressHistory),
  );
});

/// Age-band midpoints — the Harm Load only ever needs a rough age.
int midpointAge(AgeBand? band) => switch (band) {
      AgeBand.under18 => 17,
      AgeBand.y18to24 => 21,
      AgeBand.y25to34 => 30,
      AgeBand.y35to44 => 40,
      AgeBand.y45to54 => 50,
      AgeBand.y55plus => 60,
      null => 40,
    };

/// HSI from the profile when the two-item score was not asked directly:
/// the time-to-first-cigarette band plus the baseline intake.
int _hsiFromProfile(SmokingProfileRow? profile) {
  if (profile == null) {
    return 0;
  }
  final minutes = switch (profile.ttfcBand) {
    TtfcBand.under5 => 3,
    TtfcBand.five30 => 20,
    TtfcBand.thirtyOne60 => 45,
    TtfcBand.over60 => 90,
  };
  return heavinessOfSmokingIndex(
    cigarettesPerDay: profile.baselineCpd,
    minutesToFirstCigarette: minutes,
  );
}

/// Typical FEV1 scenarios for the lung chart (S4).
final lungScenariosProvider =
    FutureProvider<Map<LungScenario, List<LungPoint>>>((ref) async {
  final user = await ref.watch(userProfileProvider.future);
  final baseline = await ref.watch(measuredBaselineProvider.future);
  final age = midpointAge(user?.ageBand);
  return {
    for (final scenario in LungScenario.values)
      scenario: typicalFev1Curve(
        scenario: scenario,
        fromAge: age,
        cigarettesPerDay: baseline,
        quitAge: age,
      ),
  };
});

/// Today's support card and whether it is already ticked off.
final supportCardProvider = FutureProvider<({SupportCard card, bool done})>(
  (ref) async {
    final db = ref.watch(databaseProvider);
    final library = ref.watch(libraryRepositoryProvider);
    final now = DateTime.now();
    final card = library.supportCardForDay(
      now.difference(DateTime(now.year)).inDays,
    );
    final rows = await db.moduleDao.watchSupportSince(dayKey(now)).first;
    return (
      card: card,
      done: rows.any((r) => r.cardKey == card.key && r.done),
    );
  },
);

/// Plan report card and switching (module report §13). Switching is allowed
/// but deliberate: the user sees their own numbers first, and history is
/// never deleted — only the plan changes.
class PlanKindController {
  PlanKindController(this._ref);

  final Ref _ref;

  Future<PlanReportCard> reportCard() async {
    final db = _ref.read(databaseProvider);
    final now = DateTime.now();
    final state = await db.moduleDao.ensurePlanState(now: now);
    final daysInPlan = now.difference(state.startedAt).inDays;
    final summaries = await db.statsDao.getSummariesBetween(
      dayKey(state.startedAt),
      dayKey(now),
    );
    final adherences = [
      for (final s in summaries)
        if (s.adherence != null) s.adherence!,
    ];
    final histogram = await db.statsDao.hourlyHistogram(state.startedAt, now);
    final peak = histogram.isEmpty
        ? 0
        : histogram.reduce((a, b) => a > b ? a : b);
    return PlanReportCard(
      daysInPlan: daysInPlan,
      adherence: adherences.isEmpty
          ? 0
          : adherences.reduce((a, b) => a + b) / adherences.length,
      hardestHour: peak == 0 ? null : histogram.indexOf(peak),
      cravingsResisted: await db.cravingDao.countResistedBetween(
        state.startedAt,
        now,
      ),
    );
  }

  Future<SwitchVerdict> verdict() async {
    final db = _ref.read(databaseProvider);
    final now = DateTime.now();
    final state = await db.moduleDao.ensurePlanState(now: now);
    return canSwitchPlan(
      current: state.kind,
      daysInCurrentPlan: now.difference(state.startedAt).inDays,
      switchesLast30Days: await db.moduleDao.switchesLast30Days(now),
    );
  }

  /// The data-backed suggestion, or null when the current plan fits.
  Future<PlanKind?> suggestion() async {
    final db = _ref.read(databaseProvider);
    final now = DateTime.now();
    final state = await db.moduleDao.ensurePlanState(now: now);
    final events = _ref.read(eventTimestampsProvider).value ?? const [];
    final card = await reportCard();
    final profile = await db.profileDao.getSmokingProfile();
    return suggestedPlan(
      current: state.kind,
      intervalVariationCoefficient: intervalVariationCoefficient(events),
      adherence: card.adherence,
      wantsToQuitNow: profile?.targetMode == TargetMode.quitNow,
    );
  }

  /// Applies a switch. Refuses only when the 7-day minimum has not passed.
  Future<bool> switchTo(PlanKind kind) async {
    if (await verdict() == SwitchVerdict.tooSoon) {
      return false;
    }
    await _ref
        .read(databaseProvider)
        .moduleDao
        .switchPlan(kind: kind, now: DateTime.now());
    _ref.invalidate(planStateProvider);
    // The taper note is derived from a write, so it is refreshed explicitly
    // rather than by watching the table (see dailyTaperStepProvider).
    _ref.invalidate(dailyTaperStepProvider);
    return true;
  }
}

final planKindControllerProvider =
    Provider<PlanKindController>(PlanKindController.new);
