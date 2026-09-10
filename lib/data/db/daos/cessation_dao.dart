import 'package:drift/drift.dart';

import '../../../core/dates.dart';
import '../../../domain/cessation.dart';
import '../../../domain/entities.dart';
import '../app_database.dart';
import '../tables.dart';

part 'cessation_dao.g.dart';

/// Storage for the quit attempt (premium brief §C).
///
/// Three small tables: the attempt itself (one row), the coping plans (one
/// row per trigger) and the mood screens (append-only). All of it optional —
/// a person who only ever reduces never writes a row here.
@DriftAccessor(tables: [CessationPlanTable, CopingPlanTable, MoodScreen])
class CessationDao extends DatabaseAccessor<AppDatabase>
    with _$CessationDaoMixin {
  CessationDao(super.db);

  // --- The attempt ---------------------------------------------------------

  Future<CessationPlanRow?> getPlan() =>
      (select(cessationPlanTable)..where((t) => t.id.equals(1)))
          .getSingleOrNull();

  Stream<CessationPlanRow?> watchPlan() =>
      (select(cessationPlanTable)..where((t) => t.id.equals(1)))
          .watchSingleOrNull();

  Future<void> _upsert(CessationPlanTableCompanion companion) async {
    await into(cessationPlanTable).insertOnConflictUpdate(
      companion.copyWith(id: const Value(1)),
    );
  }

  /// Sets or moves the quit date.
  ///
  /// Moving it increments a counter and nothing else: the app does not warn,
  /// block or shame. A date moved repeatedly is worth reflecting back to the
  /// person later, and that is the only thing the count is for.
  Future<void> setQuitDate(DateTime? date) async {
    final existing = await getPlan();
    final moving = existing?.quitDate != null && date != null;
    await _upsert(
      CessationPlanTableCompanion(
        quitDate: Value(date == null ? null : dayKey(date)),
        quitDateMoves: Value(
          (existing?.quitDateMoves ?? 0) + (moving ? 1 : 0),
        ),
      ),
    );
  }

  Future<void> setReason(QuitReason? reason) =>
      _upsert(CessationPlanTableCompanion(reason: Value(reason)));

  Future<void> setSupportPerson(String? name) => _upsert(
        CessationPlanTableCompanion(
          supportPerson: Value(name?.trim().isEmpty ?? true ? null : name!.trim()),
        ),
      );

  Future<void> setNotAPuffAccepted({required bool accepted}) =>
      _upsert(CessationPlanTableCompanion(notAPuffAccepted: Value(accepted)));

  // --- Coping plans --------------------------------------------------------

  Future<List<CopingPlanRow>> copingPlans() => select(copingPlanTable).get();

  Stream<List<CopingPlanRow>> watchCopingPlans() =>
      select(copingPlanTable).watch();

  Future<void> saveCopingPlan({
    required TriggerLabel trigger,
    required String plan,
    bool? rehearsed,
  }) async {
    final trimmed = plan.trim();
    if (trimmed.isEmpty) {
      await (delete(copingPlanTable)..where((t) => t.trigger.equalsValue(trigger)))
          .go();
      return;
    }
    await into(copingPlanTable).insertOnConflictUpdate(
      CopingPlanTableCompanion.insert(
        trigger: trigger,
        plan: trimmed,
        rehearsed: Value(rehearsed ?? false),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> markRehearsed(TriggerLabel trigger, {required bool value}) =>
      (update(copingPlanTable)..where((t) => t.trigger.equalsValue(trigger)))
          .write(CopingPlanTableCompanion(rehearsed: Value(value)));

  // --- Mood screens --------------------------------------------------------

  Future<int> recordMoodScreen({
    required int lowInterest,
    required int lowMood,
    DateTime? at,
  }) =>
      into(moodScreen).insert(
        MoodScreenCompanion.insert(
          ts: at ?? DateTime.now(),
          lowInterest: lowInterest,
          lowMood: lowMood,
          total: Phq2.score(lowInterest: lowInterest, lowMood: lowMood),
        ),
      );

  Future<MoodScreenRow?> latestMoodScreen() => (select(moodScreen)
        ..orderBy([(t) => OrderingTerm.desc(t.ts)])
        ..limit(1))
      .getSingleOrNull();

  Stream<MoodScreenRow?> watchLatestMoodScreen() => (select(moodScreen)
        ..orderBy([(t) => OrderingTerm.desc(t.ts)])
        ..limit(1))
      .watchSingleOrNull();
}
