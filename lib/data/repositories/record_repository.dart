import 'package:drift/drift.dart';

import '../../core/dates.dart';
import '../../domain/entities.dart';
import '../db/app_database.dart';

/// Central write-side for cigarette and craving records plus the
/// DailySummary maintenance used by stats/motivation surfaces.
class RecordRepository {
  RecordRepository(this._db);

  final AppDatabase _db;

  Future<int> logCigarette({
    required RecordSource source,
    TriggerLabel? triggerLabel,
    String? mood,
    String? context,
    DateTime? at,
  }) {
    final ts = at ?? DateTime.now();
    return _db.transaction(() async {
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
  }) {
    final ts = at ?? DateTime.now();
    return _db.transaction(() async {
      final id = await _db.cravingDao.insertCraving(
        CravingEventCompanion.insert(
          ts: ts,
          intensity: intensity,
          triggerLabel: Value(triggerLabel),
          outcome: outcome,
        ),
      );
      await recomputeDailySummary(ts);
      return id;
    });
  }

  /// Recomputes the DailySummary row for the local day of [day].
  ///
  /// avoidedCount/savings compare actual consumption against the plan target
  /// for that day when one exists, otherwise against the onboarding baseline
  /// (first day, no plan yet — report §4: estimate from onboarding data).
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
    final expected = planTarget ?? profile?.baselineCpd ?? 0;
    final avoided = expected > 0 && count < expected ? expected - count : 0;
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
