import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../data/repositories/medicine_repository.dart';
import '../domain/cessation.dart';
import '../domain/entities.dart';
import 'module_providers.dart';
import 'providers.dart';

/// The quit attempt (premium brief §C).
const medicineRepository = MedicineRepository();

final medicineRepositoryProvider =
    Provider<MedicineRepository>((ref) => medicineRepository);

/// The stored attempt, assembled with its coping plans and last mood screen.
final cessationStateProvider = StreamProvider<CessationState>((ref) {
  final db = ref.watch(databaseProvider);
  return db.cessationDao.watchPlan().asyncMap((plan) async {
    final plans = await db.cessationDao.copingPlans();
    final mood = await db.cessationDao.latestMoodScreen();
    return CessationState(
      quitDate: plan?.quitDate == null ? null : parseDayKey(plan!.quitDate!),
      quitDateMoves: plan?.quitDateMoves ?? 0,
      reason: plan?.reason,
      supportPerson: plan?.supportPerson,
      notAPuffAccepted: plan?.notAPuffAccepted ?? false,
      copingPlans: [
        for (final row in plans)
          CopingPlan(
            trigger: row.trigger,
            plan: row.plan,
            rehearsed: row.rehearsed,
          ),
      ],
      lastMoodScreen: mood?.ts,
      lastMoodScore: mood?.total,
    );
  });
});

/// Days until the quit date; negative once it has passed.
final daysToQuitProvider = Provider<int?>((ref) {
  final date = ref.watch(cessationStateProvider).value?.quitDate;
  return date == null ? null : QuitDateGuidance.daysUntil(DateTime.now(), date);
});

/// True on the quit date itself — the day that gets its own screen.
final isQuitDayProvider = Provider<bool>((ref) => ref.watch(daysToQuitProvider) == 0);

/// What has happened since the quit date, in Marlatt's terms.
///
/// Deliberately a *classification*, not a judgement: the app shows the user
/// which of these they are in and what the next move is, because a silence
/// after a slip gets filled by their own worst reading of it.
final slipVerdictProvider = Provider<SlipVerdict>((ref) {
  final quitDate = ref.watch(cessationStateProvider).value?.quitDate;
  final events = ref.watch(eventTimestampsProvider).value ?? const [];
  final profile = ref.watch(smokingProfileProvider).value;
  if (quitDate == null) {
    return SlipVerdict.none;
  }
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  final since = events.where((e) => !e.isBefore(quitDate)).toList();
  final lastWeek = since.where((e) => e.isAfter(weekAgo)).length;
  // Their own recent rate, over whichever is shorter: the week, or the time
  // since they quit.
  final daysObserved = now.difference(quitDate).inHours / 24;
  final window = daysObserved < 7 ? daysObserved : 7.0;
  final recentCpd = window <= 0 ? 0.0 : lastWeek / window;
  return slipVerdict(
    slipsInLastWeek: lastWeek,
    recentCpd: recentCpd,
    baselineCpd: (profile?.baselineCpd ?? 0).toDouble(),
  );
});

/// The triggers this person told the app about, as the seed for their
/// relapse-prevention plan. An empty coping-plan form is one nobody fills in.
final highRiskTriggersProvider = FutureProvider<List<TriggerLabel>>((ref) async {
  final db = ref.watch(databaseProvider);
  final rows = await db.select(db.trigger).get();
  final chosen = rows.map((r) => r.labelKey).toSet();
  if (chosen.isNotEmpty) {
    return chosen.toList();
  }
  // Nothing chosen at onboarding: fall back to the situations that break
  // most attempts, so the screen still opens with something to work on.
  return const [
    TriggerLabel.coffee,
    TriggerLabel.stress,
    TriggerLabel.alcohol,
    TriggerLabel.afterMeal,
    TriggerLabel.wakeUp,
  ];
});

/// Whether the guidelines' "start with combination therapy" case applies.
final suggestsCombinationProvider = Provider<bool>((ref) {
  final profile = ref.watch(smokingProfileProvider).value;
  return suggestsCombinationTherapy(
    hsi: profile?.hsi,
    baselineCpd: (profile?.baselineCpd ?? 0).toDouble(),
  );
});

/// Whether to offer the two-item mood screen again.
final moodScreenDueProvider = Provider<bool>((ref) {
  final state = ref.watch(cessationStateProvider).value;
  return state?.moodScreenDue(DateTime.now()) ?? false;
});

/// Writes for the quit attempt.
class CessationController {
  const CessationController(this._ref);

  final Ref _ref;

  Future<void> setQuitDate(DateTime? date) async {
    await _ref.read(databaseProvider).cessationDao.setQuitDate(date);
  }

  Future<void> setReason(QuitReason? reason) async {
    await _ref.read(databaseProvider).cessationDao.setReason(reason);
  }

  Future<void> setSupportPerson(String? name) async {
    await _ref.read(databaseProvider).cessationDao.setSupportPerson(name);
  }

  Future<void> acceptNotAPuffRule({required bool accepted}) async {
    await _ref
        .read(databaseProvider)
        .cessationDao
        .setNotAPuffAccepted(accepted: accepted);
  }

  Future<void> saveCopingPlan(TriggerLabel trigger, String plan) async {
    await _ref
        .read(databaseProvider)
        .cessationDao
        .saveCopingPlan(trigger: trigger, plan: plan);
  }

  Future<void> recordMoodScreen({
    required int lowInterest,
    required int lowMood,
  }) async {
    await _ref.read(databaseProvider).cessationDao.recordMoodScreen(
          lowInterest: lowInterest,
          lowMood: lowMood,
        );
  }
}

final cessationControllerProvider =
    Provider<CessationController>(CessationController.new);
