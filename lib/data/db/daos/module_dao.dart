import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/dates.dart';
import '../../../domain/plan_kinds.dart';
import '../app_database.dart';
import '../tables.dart';

part 'module_dao.g.dart';

/// Storage for the module-report features (mood reports, support-card
/// completions, the daily index snapshots, plan state and the savings goal).
///
/// Everything here is local and cheap: these tables hold at most one row per
/// day, so full-range reads are fine and keep the query surface small.
@DriftAccessor(
  tables: [MoodLog, SupportLog, IndexSnapshot, PlanState, SavingsGoalTable],
)
class ModuleDao extends DatabaseAccessor<AppDatabase> with _$ModuleDaoMixin {
  ModuleDao(super.db);

  // --- Mood reports (module report §8) -------------------------------------

  Future<int> insertMood(MoodLogCompanion companion) =>
      into(moodLog).insert(companion);

  Stream<List<MoodLogRow>> watchMoods() =>
      (select(moodLog)..orderBy([(m) => OrderingTerm.desc(m.ts)])).watch();

  Future<List<MoodLogRow>> moodsSince(DateTime since) =>
      (select(moodLog)
            ..where((m) => m.ts.isBiggerOrEqualValue(since))
            ..orderBy([(m) => OrderingTerm.asc(m.ts)]))
          .get();

  // --- Support cards (module report §10) -----------------------------------

  Future<void> setSupportDone(String date, String cardKey, {bool done = true}) =>
      into(supportLog).insertOnConflictUpdate(
        SupportLogRow(date: date, cardKey: cardKey, done: done),
      );

  Stream<List<SupportLogRow>> watchSupportSince(String fromDate) =>
      (select(supportLog)..where((s) => s.date.isBiggerOrEqualValue(fromDate)))
          .watch();

  // --- Index snapshots (module report §14) ---------------------------------

  Future<void> putIndexSnapshot({
    required String date,
    required int progressScore,
    required int harmLoad,
  }) =>
      into(indexSnapshot).insertOnConflictUpdate(
        IndexSnapshotRow(
          date: date,
          progressScore: progressScore,
          harmLoad: harmLoad,
        ),
      );

  Future<IndexSnapshotRow?> latestIndexSnapshot() =>
      (select(indexSnapshot)
            ..orderBy([(s) => OrderingTerm.desc(s.date)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<IndexSnapshotRow>> indexSnapshotsSince(String fromDate) =>
      (select(indexSnapshot)
            ..where((s) => s.date.isBiggerOrEqualValue(fromDate))
            ..orderBy([(s) => OrderingTerm.asc(s.date)]))
          .get();

  Stream<List<IndexSnapshotRow>> watchIndexSnapshots() =>
      (select(indexSnapshot)..orderBy([(s) => OrderingTerm.asc(s.date)]))
          .watch();

  // --- Plan state (module report §13) --------------------------------------

  Stream<PlanStateRow?> watchPlanState() =>
      (select(planState)..where((p) => p.id.equals(1))).watchSingleOrNull();

  Future<PlanStateRow?> getPlanState() =>
      (select(planState)..where((p) => p.id.equals(1))).getSingleOrNull();

  /// Reads the plan state, creating the default row on first use.
  Future<PlanStateRow> ensurePlanState({
    required DateTime now,
    PlanKind kind = PlanKind.gradualTaper,
  }) async {
    final existing = await getPlanState();
    if (existing != null) {
      return existing;
    }
    await into(planState).insert(
      PlanStateCompanion.insert(kind: Value(kind), startedAt: now),
      mode: InsertMode.insertOrIgnore,
    );
    return (await getPlanState())!;
  }

  Future<void> updatePlanState(PlanStateCompanion companion) =>
      (update(planState)..where((p) => p.id.equals(1))).write(companion);

  /// Switches the plan, stamping the switch date so the 30-day switch count
  /// stays honest. History is never deleted — only the plan changes.
  Future<void> switchPlan({
    required PlanKind kind,
    required DateTime now,
  }) async {
    final current = await ensurePlanState(now: now);
    final history = <String>[
      ...(jsonDecode(current.switchHistoryJson) as List).cast<String>(),
      dayKey(now),
    ];
    await updatePlanState(
      PlanStateCompanion(
        kind: Value(kind),
        startedAt: Value(now),
        daysAtStep: const Value(0),
        switchHistoryJson: Value(jsonEncode(history)),
      ),
    );
  }

  /// Plan switches within the last 30 days.
  Future<int> switchesLast30Days(DateTime now) async {
    final state = await getPlanState();
    if (state == null) {
      return 0;
    }
    final cutoff = dayKey(now.subtract(const Duration(days: 30)));
    final history = (jsonDecode(state.switchHistoryJson) as List).cast<String>();
    return history.where((d) => d.compareTo(cutoff) >= 0).length;
  }

  // --- Savings goal (module report §3) --------------------------------------

  Stream<SavingsGoalRow?> watchSavingsGoal() =>
      (select(savingsGoalTable)..where((g) => g.id.equals(1)))
          .watchSingleOrNull();

  Future<void> setSavingsGoal({required String label, required double amount}) =>
      into(savingsGoalTable).insertOnConflictUpdate(
        SavingsGoalRow(id: 1, label: label, amount: amount),
      );

  Future<void> clearSavingsGoal() =>
      (delete(savingsGoalTable)..where((g) => g.id.equals(1))).go();
}
