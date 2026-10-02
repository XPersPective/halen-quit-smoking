import 'package:drift/drift.dart';

import '../../core/dates.dart';
import '../../domain/entities.dart';
import '../db/app_database.dart';

/// Central write-side for cigarette and craving records plus the
/// DailySummary maintenance used by stats/motivation surfaces.
class RecordRepository {
  RecordRepository(this._db);

  final AppDatabase _db;

  /// A finger can bounce, a quick tile can fire twice while the sheet is
  /// still closing. The same source within this window is the same
  /// cigarette (brain T9) — we return the existing row, no phantom count.
  static const duplicateWindow = Duration(seconds: 3);

  Future<int> logCigarette({
    required RecordSource source,
    TriggerLabel? triggerLabel,
    String? mood,
    String? context,
    DateTime? at,
  }) {
    final ts = at ?? DateTime.now();
    return _db.transaction(() async {
      final last = await (_db.select(_db.cigaretteEvent)
            ..orderBy([(e) => OrderingTerm.desc(e.ts)])
            ..limit(1))
          .getSingleOrNull();
      if (last != null &&
          (ts.difference(last.ts)).abs() < duplicateWindow) {
        return last.id;
      }
      final id = await _db.recordDao.insertEvent(
        CigaretteEventCompanion.insert(
          ts: ts,
          source: source,
          triggerLabel: Value(triggerLabel),
          mood: Value(mood),
          context: Value(context),
          planDay: Value(dayKey(ts)),
        ),
      );
      await recomputeDailySummary(ts);
      return id;
    });
  }

  Future<void> updateEventTrigger(int eventId, TriggerLabel? triggerLabel) async {
    final event = await (_db.select(_db.cigaretteEvent)
          ..where((e) => e.id.equals(eventId)))
        .getSingleOrNull();
    if (event == null) {
      return;
    }
    await (_db.update(_db.cigaretteEvent)..where((e) => e.id.equals(eventId)))
        .write(CigaretteEventCompanion(
      triggerLabel: Value(triggerLabel),
    ));
    await recomputeDailySummary(event.ts);
  }

  Future<int> logCraving({
    required CravingOutcome outcome,
    CravingIntensity intensity = CravingIntensity.medium,
    TriggerLabel? triggerLabel,
    DateTime? at,
    String? techniqueKey,
  }) {
    final ts = at ?? DateTime.now();
    return _db.transaction(() async {
      final last = await (_db.select(_db.cravingEvent)
            ..orderBy([(e) => OrderingTerm.desc(e.ts)])
            ..limit(1))
          .getSingleOrNull();
      if (last != null && (ts.difference(last.ts)).abs() < duplicateWindow) {
        return last.id;
      }
      final id = await _db.cravingDao.insertCraving(
        CravingEventCompanion.insert(
          ts: ts,
          intensity: intensity,
          triggerLabel: Value(triggerLabel),
          outcome: outcome,
          // Which SOS technique was in play, so the toolkit can learn what
          // works for this user (module report §5.⑤).
          techniqueKey: Value(techniqueKey),
        ),
      );
      await recomputeDailySummary(ts);
      return id;
    });
  }

  /// Re-prices every finished day once it is over. A day's savings are only
  /// credited after midnight (see [recomputeDailySummary]), and nothing else
  /// touches a day after it ends, so the app calls this on start, on resume
  /// and when the date changes.
  Future<void> finalizeCompletedDays() async {
    final profile = await _db.profileDao.getSmokingProfile();
    if (profile == null) {
      return;
    }
    final today = dayKey(DateTime.now());
    final rows = await _db.statsDao.getSummariesBetween('0000-00-00', today);
    for (final row in rows) {
      if (row.date.compareTo(today) >= 0) {
        continue;
      }
      final baseline = profile.baselineCpd;
      final expected =
          baseline > 0 && row.count < baseline ? baseline - row.count : 0;
      if (row.avoidedCount != expected) {
        await recomputeDailySummary(DateTime.parse(row.date));
      }
    }
  }

  /// Recomputes the DailySummary row for the local day of [day].
  ///
  /// avoidedCount/savings compare actual consumption against the declared
  /// baseline, for completed days only (see SavingsLedger).
  Future<void> recomputeDailySummary(DateTime day) async {
    final dayStart = day.dayStart;
    final nextDay = dayStart.add(const Duration(days: 1));

    final events = await _db.recordDao.getEventsBetween(dayStart, nextDay);
    final resisted =
        await _db.cravingDao.countResistedBetween(dayStart, nextDay);

    int? minGapMinutes;
    if (events.length >= 2) {
      var minGap = 1 << 30;
      for (var i = 1; i < events.length; i++) {
        final gap = events[i].ts.difference(events[i - 1].ts).inMinutes;
        if (gap < minGap) {
          minGap = gap;
        }
      }
      minGapMinutes = minGap;
    }

    final profile = await _db.profileDao.getSmokingProfile();
    final plan = await _db.planDao.getPlan(dayKey(day));
    final planTarget = plan?.targetCount;

    final count = events.length;
    // Savings are credited only once the day is over, against the baseline
    // the user declared — never against a plan target, and never for a day
    // still in progress (4 cigarettes by 9am is not "13 avoided").
    final isCompleted = dayStart.isBefore(DateTime.now().dayStart);
    final baseline = profile?.baselineCpd ?? 0;
    final avoided =
        isCompleted && baseline > 0 && count < baseline ? baseline - count : 0;
    final perCigarettePrice = profile == null || profile.packSize == 0
        ? 0.0
        : profile.pricePerPack / profile.packSize;

    double? adherence;
    if (planTarget != null && planTarget > 0) {
      adherence = count <= planTarget ? 1.0 : planTarget / count;
    }

    await _db.statsDao.upsertSummary(DailySummaryCompanion.insert(
      date: dayKey(day),
      count: count,
      planTarget: Value(planTarget),
      adherence: Value(adherence),
      savings: Value(avoided * perCigarettePrice),
      avoidedCount: Value(avoided),
      resistedCount: Value(resisted),
      firstTs: Value(events.isEmpty ? null : events.first.ts),
      lastTs: Value(events.isEmpty ? null : events.last.ts),
      minGapMinutes: Value(minGapMinutes),
    ));
  }
}
