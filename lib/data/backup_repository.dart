import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/entities.dart';
import '../domain/plan_kinds.dart';
import '../domain/cessation.dart';
import '../domain/soft_taper.dart';
import 'db/app_database.dart';

/// User-initiated JSON export/import (report §23/§26): the honest answer to
/// "device change" without any cloud. The file is plain JSON, fully under
/// the user's control; nothing is ever uploaded by the app itself.

T enumByName<T extends Enum>(List<T> values, String name) =>
    values.firstWhere((v) => v.name == name);

T? enumByNameOrNull<T extends Enum>(List<T> values, String? name) {
  if (name == null) {
    return null;
  }
  for (final v in values) {
    if (v.name == name) {
      return v;
    }
  }
  return null;
}

class BackupRepository {
  BackupRepository(this._db);

  final AppDatabase _db;

  static const formatVersion = 1;

  /// Serializes every user table into a versioned JSON map.
  Future<Map<String, dynamic>> exportToJson() async {
    final user = await _db.profileDao.getUserProfile();
    final profile = await _db.profileDao.getSmokingProfile();
    final events = await _db.select(_db.cigaretteEvent).get();
    final products = await _db.select(_db.cigaretteProduct).get();
    final plans = await _db.select(_db.dailyPlan).get();
    final adjustments = await _db.select(_db.planAdjustment).get();
    final triggers = await _db.select(_db.trigger).get();
    final cravings = await _db.select(_db.cravingEvent).get();
    final summaries = await _db.select(_db.dailySummary).get();
    final timeline = await _db.timelineDao.getState();
    final settings = await _db.settingsDao.getSettings();
    // T26: the newer personal tables ride along — a backup that loses the
    // user's mood history or plans is not a backup.
    final moodLogs = await _db.select(_db.moodLog).get();
    final supportLogs = await _db.select(_db.supportLog).get();
    final indexSnapshots = await _db.select(_db.indexSnapshot).get();
    final planState = await _db.select(_db.planState).get();
    final savingsGoal = await _db.select(_db.savingsGoalTable).get();
    final cessationPlan = await _db.select(_db.cessationPlanTable).get();
    final copingPlans = await _db.select(_db.copingPlanTable).get();
    final moodScreens = await _db.select(_db.moodScreen).get();
    final packPurchases = await _db.select(_db.packPurchaseTable).get();

    return {
      'format': 'halen-backup',
      'version': formatVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'userProfile': user == null
          ? null
          : {
              'createdAt': user.createdAt.toIso8601String(),
              'locale': user.locale,
              'ageBand': user.ageBand.name,
            },
      'smokingProfile': profile == null
          ? null
          : {
              'baselineCpd': profile.baselineCpd,
              'ttfcBand': profile.ttfcBand.name,
              'pricePerPack': profile.pricePerPack,
              'packSize': profile.packSize,
              'brandId': profile.brandId,
              'brandName': profile.brandName,
              'targetMode': profile.targetMode.name,
              'pace': profile.pace.name,
              'startedAt': profile.startedAt.toIso8601String(),
              'declaredRhythmMinutes': profile.declaredRhythmMinutes,
              'heightCm': profile.heightCm,
              'weightKg': profile.weightKg,
              'smokingYears': profile.smokingYears,
            },
      'cigaretteEvents': [
        for (final e in events)
          {
            'ts': e.ts.toIso8601String(),
            'source': e.source.name,
            'triggerLabel': e.triggerLabel?.name,
            'mood': e.mood,
            'context': e.context,
            'planDay': e.planDay,
          },
      ],
      'cigaretteProducts': [
        for (final p in products)
          {
            'barcode': p.barcode,
            'brand': p.brand,
            'variant': p.variant,
            'packSize': p.packSize,
            'market': p.market,
            'source': p.source,
            'verifiedByUser': p.verifiedByUser,
          },
      ],
      'dailyPlans': [
        for (final p in plans)
          {
            'date': p.date,
            'targetCount': p.targetCount,
            'windowsJson': p.windowsJson,
            'phase': p.phase.name,
            'tempo': p.tempo.name,
            'quitDate': p.quitDate,
          },
      ],
      'planAdjustments': [
        for (final a in adjustments)
          {
            'date': a.date,
            'reason': a.reason.name,
            'fromCount': a.fromCount,
            'toCount': a.toCount,
            'messageKey': a.messageKey,
          },
      ],
      'triggers': [
        for (final t in triggers)
          {'labelKey': t.labelKey.name, 'custom': t.custom},
      ],
      'cravingEvents': [
        for (final c in cravings)
          {
            'ts': c.ts.toIso8601String(),
            'intensity': c.intensity.index,
            'triggerLabel': c.triggerLabel?.name,
            'outcome': c.outcome.name,
          },
      ],
      'dailySummaries': [
        for (final s in summaries)
          {
            'date': s.date,
            'count': s.count,
            'planTarget': s.planTarget,
            'adherence': s.adherence,
            'savings': s.savings,
            'avoidedCount': s.avoidedCount,
            'resistedCount': s.resistedCount,
            'firstTs': s.firstTs?.toIso8601String(),
            'lastTs': s.lastTs?.toIso8601String(),
            'minGapMinutes': s.minGapMinutes,
          },
      ],
      'moodLogs': [
        for (final m in moodLogs)
          {
            'ts': m.ts.toIso8601String(),
            'reportedBand': m.reportedBand,
            'estimated': m.estimated,
            'prompted': m.prompted,
          },
      ],
      'supportLogs': [
        for (final l in supportLogs)
          {'date': l.date, 'cardKey': l.cardKey, 'done': l.done},
      ],
      'indexSnapshots': [
        for (final i in indexSnapshots)
          {'date': i.date, 'progressScore': i.progressScore, 'harmLoad': i.harmLoad},
      ],
      'planState': planState.isEmpty
          ? null
          : {
              'kind': planState.first.kind.name,
              'startedAt': planState.first.startedAt.toIso8601String(),
              'intervalMinutes': planState.first.intervalMinutes,
              'targetIntervalMinutes': planState.first.targetIntervalMinutes,
              'daysAtStep': planState.first.daysAtStep,
              'taperMode': planState.first.taperMode.name,
              'switchHistoryJson': planState.first.switchHistoryJson,
              'lastStepDate': planState.first.lastStepDate,
              'lastStepDecision': planState.first.lastStepDecision?.name,
            },
      'savingsGoal': savingsGoal.isEmpty
          ? null
          : {'label': savingsGoal.first.label, 'amount': savingsGoal.first.amount},
      'cessationPlan': cessationPlan.isEmpty
          ? null
          : {
              'quitDate': cessationPlan.first.quitDate,
              'quitDateMoves': cessationPlan.first.quitDateMoves,
              'reason': cessationPlan.first.reason?.name,
              'supportPerson': cessationPlan.first.supportPerson,
              'notAPuffAccepted': cessationPlan.first.notAPuffAccepted,
            },
      'copingPlans': [
        for (final c in copingPlans)
          {
            'trigger': c.trigger.name,
            'plan': c.plan,
            'rehearsed': c.rehearsed,
            'updatedAt': c.updatedAt.toIso8601String(),
          },
      ],
      'moodScreens': [
        for (final m in moodScreens)
          {'ts': m.ts.toIso8601String(), 'lowInterest': m.lowInterest, 'lowMood': m.lowMood, 'total': m.total},
      ],
      'packPurchases': [
        for (final p in packPurchases)
          {
            'ts': p.ts.toIso8601String(),
            'packs': p.packs,
            'pricePerPack': p.pricePerPack,
            'packSize': p.packSize,
            'brand': p.brand,
          },
      ],
      'timeline': {
        'quitTs': timeline.quitTs?.toIso8601String(),
        'acknowledgedMilestones': timeline.acknowledgedMilestones,
      },
      'settings': {
        'notifLevel': settings.notifLevel.name,
        'theme': settings.theme.name,
        'reduceMotion': settings.reduceMotion,
        'haptics': settings.haptics,
        'appLocale': settings.appLocale,
        'trialNudge': settings.trialNudge,
        'widgetShowLastCigarette': settings.widgetShowLastCigarette,
        'widgetTheme': settings.widgetTheme,
      },
    };
  }

  /// Writes the export into the user-visible documents folder
  /// (iOS Files / Android files app) and returns the file path.
  Future<String> exportToFile() async {
    final data = await exportToJson();
    final dir = await _documentsDir();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File('${dir.path}/halen-backup-$stamp.json');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
    return file.path;
  }

  Future<Directory> _documentsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/halen-exports');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Replaces all user data with the given backup. Returns the number of
  /// imported cigarette events.
  Future<int> importFromJson(Map<String, dynamic> data) async {
    if (data['format'] != 'halen-backup') {
      throw const FormatException('Not a Halen backup file');
    }
    final version = (data['version'] as num?)?.toInt() ?? 0;
    if (version > formatVersion) {
      throw const FormatException('Backup from a newer app version');
    }

    await _db.transaction(() async {
      await _wipeUserData();

      final user = data['userProfile'] as Map<String, dynamic>?;
      if (user != null) {
        await _db.profileDao.saveUserProfile(
          locale: user['locale'] as String? ?? 'en',
          ageBand: enumByName(AgeBand.values, user['ageBand'] as String),
        );
      }
      final profile = data['smokingProfile'] as Map<String, dynamic>?;
      if (profile != null) {
        await _db.profileDao.saveSmokingProfile(
          SmokingProfileCompanion(
            baselineCpd: Value(profile['baselineCpd'] as int),
            ttfcBand: Value(
              enumByName(TtfcBand.values, profile['ttfcBand'] as String),
            ),
            pricePerPack: Value((profile['pricePerPack'] as num).toDouble()),
            packSize: Value(profile['packSize'] as int),
            brandId: Value(profile['brandId'] as String?),
            brandName: Value(profile['brandName'] as String?),
            targetMode: Value(
              enumByName(TargetMode.values, profile['targetMode'] as String),
            ),
            pace: Value(enumByName(Pace.values, profile['pace'] as String)),
            startedAt: Value(DateTime.parse(profile['startedAt'] as String)),
            declaredRhythmMinutes:
                Value(profile['declaredRhythmMinutes'] as int?),
            heightCm: Value((profile['heightCm'] as num?)?.toDouble()),
            weightKg: Value((profile['weightKg'] as num?)?.toDouble()),
            smokingYears: Value((profile['smokingYears'] as num?)?.toDouble()),
          ),
        );
      }

      for (final e in (data['cigaretteEvents'] as List? ?? []).cast<Map>()) {
        await _db.recordDao.insertEvent(
          CigaretteEventCompanion.insert(
            ts: DateTime.parse(e['ts'] as String),
            source: enumByName(RecordSource.values, e['source'] as String),
            triggerLabel: Value(
              enumByNameOrNull(
                TriggerLabel.values,
                e['triggerLabel'] as String?,
              ),
            ),
            mood: Value(e['mood'] as String?),
            context: Value(e['context'] as String?),
            planDay: Value(e['planDay'] as String?),
          ),
        );
      }

      for (final p in (data['cigaretteProducts'] as List? ?? []).cast<Map>()) {
        await _db
            .into(_db.cigaretteProduct)
            .insert(
              CigaretteProductCompanion.insert(
                barcode: p['barcode'] as String,
                brand: p['brand'] as String,
                variant: Value(p['variant'] as String?),
                packSize: p['packSize'] as int,
                market: p['market'] as String,
                source: p['source'] as String,
                verifiedByUser: Value(p['verifiedByUser'] as bool? ?? false),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }

      for (final p in (data['dailyPlans'] as List? ?? []).cast<Map>()) {
        await _db.planDao.upsertPlan(
          DailyPlanCompanion.insert(
            date: p['date'] as String,
            targetCount: p['targetCount'] as int,
            phase: enumByName(PlanPhase.values, p['phase'] as String),
            tempo: enumByName(Pace.values, p['tempo'] as String),
            windowsJson: Value(p['windowsJson'] as String? ?? '[]'),
            quitDate: Value(p['quitDate'] as String?),
          ),
        );
      }

      for (final a in (data['planAdjustments'] as List? ?? []).cast<Map>()) {
        await _db.planDao.insertAdjustment(
          PlanAdjustmentCompanion.insert(
            date: a['date'] as String,
            reason: enumByName(AdjustmentReason.values, a['reason'] as String),
            fromCount: a['fromCount'] as int,
            toCount: a['toCount'] as int,
            messageKey: a['messageKey'] as String,
          ),
        );
      }

      for (final t in (data['triggers'] as List? ?? []).cast<Map>()) {
        await _db
            .into(_db.trigger)
            .insert(
              TriggerCompanion.insert(
                labelKey: enumByName(
                  TriggerLabel.values,
                  t['labelKey'] as String,
                ),
                custom: Value(t['custom'] as String?),
              ),
            );
      }

      for (final c in (data['cravingEvents'] as List? ?? []).cast<Map>()) {
        await _db.cravingDao.insertCraving(
          CravingEventCompanion.insert(
            ts: DateTime.parse(c['ts'] as String),
            intensity: CravingIntensity.values[c['intensity'] as int],
            triggerLabel: Value(
              enumByNameOrNull(
                TriggerLabel.values,
                c['triggerLabel'] as String?,
              ),
            ),
            outcome: enumByName(CravingOutcome.values, c['outcome'] as String),
          ),
        );
      }

      for (final s in (data['dailySummaries'] as List? ?? []).cast<Map>()) {
        await _db.statsDao.upsertSummary(
          DailySummaryCompanion.insert(
            date: s['date'] as String,
            count: s['count'] as int,
            planTarget: Value(s['planTarget'] as int?),
            adherence: Value((s['adherence'] as num?)?.toDouble()),
            savings: Value((s['savings'] as num?)?.toDouble() ?? 0),
            avoidedCount: Value((s['avoidedCount'] as int?) ?? 0),
            resistedCount: Value((s['resistedCount'] as int?) ?? 0),
            firstTs: Value(_dateOrNull(s['firstTs'] as String?)),
            lastTs: Value(_dateOrNull(s['lastTs'] as String?)),
            minGapMinutes: Value(s['minGapMinutes'] as int?),
          ),
        );
      }

      // T26: the newer personal tables ride along in both directions.
      for (final m in (data['moodLogs'] as List? ?? []).cast<Map>()) {
        await _db.into(_db.moodLog).insert(
              MoodLogCompanion.insert(
                ts: DateTime.parse(m['ts'] as String),
                reportedBand: m['reportedBand'] as int,
                estimated: (m['estimated'] as num).toDouble(),
                prompted: Value(m['prompted'] as bool? ?? false),
              ),
            );
      }
      for (final l in (data['supportLogs'] as List? ?? []).cast<Map>()) {
        await _db.into(_db.supportLog).insert(
              SupportLogCompanion.insert(
                date: l['date'] as String,
                cardKey: l['cardKey'] as String,
                done: Value(l['done'] as bool? ?? true),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final i in (data['indexSnapshots'] as List? ?? []).cast<Map>()) {
        await _db.into(_db.indexSnapshot).insert(
              IndexSnapshotCompanion.insert(
                date: i['date'] as String,
                progressScore: i['progressScore'] as int,
                harmLoad: i['harmLoad'] as int,
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      final planState = data['planState'] as Map<String, dynamic>?;
      if (planState != null) {
        await _db.into(_db.planState).insert(
              PlanStateCompanion.insert(
                startedAt: DateTime.parse(planState['startedAt'] as String),
                kind: Value(
                  enumByName(
                    PlanKind.values,
                    planState['kind'] as String,
                  ),
                ),
                intervalMinutes: Value(planState['intervalMinutes'] as int?),
                targetIntervalMinutes:
                    Value(planState['targetIntervalMinutes'] as int?),
                daysAtStep: Value(planState['daysAtStep'] as int? ?? 0),
                taperMode: Value(
                  enumByName(
                    TaperMode.values,
                    (planState['taperMode'] as String?) ?? 'gentle',
                  ),
                ),
                switchHistoryJson: Value(
                  (planState['switchHistoryJson'] as String?) ?? '[]',
                ),
                lastStepDate: Value(planState['lastStepDate'] as String?),
                lastStepDecision: Value(
                  enumByNameOrNull(
                    TaperDecision.values,
                    planState['lastStepDecision'] as String?,
                  ),
                ),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      final savingsGoal = data['savingsGoal'] as Map<String, dynamic>?;
      if (savingsGoal != null) {
        await _db.into(_db.savingsGoalTable).insert(
              SavingsGoalTableCompanion.insert(
                label: savingsGoal['label'] as String,
                amount: (savingsGoal['amount'] as num).toDouble(),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      final cessationPlan = data['cessationPlan'] as Map<String, dynamic>?;
      if (cessationPlan != null) {
        await _db.into(_db.cessationPlanTable).insert(
              CessationPlanTableCompanion.insert(
                quitDate: Value(cessationPlan['quitDate'] as String?),
                quitDateMoves:
                    Value(cessationPlan['quitDateMoves'] as int? ?? 0),
                reason: Value(
                  enumByNameOrNull(
                    QuitReason.values,
                    cessationPlan['reason'] as String?,
                  ),
                ),
                supportPerson:
                    Value(cessationPlan['supportPerson'] as String?),
                notAPuffAccepted: Value(
                  cessationPlan['notAPuffAccepted'] as bool? ?? false,
                ),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final c in (data['copingPlans'] as List? ?? []).cast<Map>()) {
        await _db.into(_db.copingPlanTable).insert(
              CopingPlanTableCompanion.insert(
                trigger: enumByName(
                  TriggerLabel.values,
                  c['trigger'] as String,
                ),
                plan: c['plan'] as String,
                rehearsed: Value(c['rehearsed'] as bool? ?? false),
                updatedAt: DateTime.parse(c['updatedAt'] as String),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final m in (data['moodScreens'] as List? ?? []).cast<Map>()) {
        await _db.into(_db.moodScreen).insert(
              MoodScreenCompanion.insert(
                ts: DateTime.parse(m['ts'] as String),
                lowInterest: m['lowInterest'] as int,
                lowMood: m['lowMood'] as int,
                total: m['total'] as int,
              ),
            );
      }
      for (final p in (data['packPurchases'] as List? ?? []).cast<Map>()) {
        await _db.into(_db.packPurchaseTable).insert(
              PackPurchaseTableCompanion.insert(
                ts: DateTime.parse(p['ts'] as String),
                pricePerPack: (p['pricePerPack'] as num).toDouble(),
                packs: Value(p['packs'] as int? ?? 1),
                packSize: Value(p['packSize'] as int? ?? 20),
                brand: Value(p['brand'] as String?),
              ),
            );
      }
      final timeline = data['timeline'] as Map<String, dynamic>?;
      if (timeline != null) {
        // A fresh device has no state row yet: create it before the UPDATE-
        // style setQuitTs, or the imported quit date would vanish silently.
        await _db.timelineDao.getState();
        await _db.timelineDao.setQuitTs(
          _dateOrNull(timeline['quitTs'] as String?),
        );
        await _db.timelineDao.setAcknowledgedMilestones(
          (timeline['acknowledgedMilestones'] as String?) ?? '[]',
        );
      }
      final settings = data['settings'] as Map<String, dynamic>?;
      if (settings != null) {
        await _db.settingsDao.updateSettings(
          SettingsCompanion(
            notifLevel: Value(
              enumByName(
                NotificationDensity.values,
                settings['notifLevel'] as String,
              ),
            ),
            theme: Value(
              enumByName(ThemeOption.values, settings['theme'] as String),
            ),
            reduceMotion: Value(settings['reduceMotion'] as bool? ?? false),
            haptics: Value(settings['haptics'] as bool? ?? true),
            appLocale: Value(settings['appLocale'] as String?),
            trialNudge: Value(settings['trialNudge'] as bool? ?? false),
            widgetShowLastCigarette:
                Value(settings['widgetShowLastCigarette'] as bool? ?? true),
            widgetTheme:
                Value((settings['widgetTheme'] as String?) ?? 'system'),
            // Trial and purchases belong to this installation/store, never JSON.
            // Ignore legacy trialStartedAt fields, including malformed values.
          ),
        );
      }
    });

    final events = await _db.select(_db.cigaretteEvent).get();
    return events.length;
  }

  /// Deletes all user rows; settings/timeline defaults are re-created.
  Future<void> wipeAllUserData() async {
    await _db.transaction(() async {
      await _wipeUserData();
      await _db.timelineDao.getState();
      await _db.timelineDao.setQuitTs(null);
      // The milestone checkboxes belong to the quit attempt and go with it.
      await _db.timelineDao.setAcknowledgedMilestones('[]');
    });
  }

  Future<void> _wipeUserData() async {
    await (_db.delete(_db.cigaretteEvent)).go();
    await (_db.delete(_db.cigaretteProduct)).go();
    await (_db.delete(_db.dailyPlan)).go();
    await (_db.delete(_db.planAdjustment)).go();
    await (_db.delete(_db.trigger)).go();
    await (_db.delete(_db.cravingEvent)).go();
    await (_db.delete(_db.dailySummary)).go();
    await (_db.delete(_db.smokingProfile)).go();
    await (_db.delete(_db.userProfile)).go();
    // T26: every personal table, not only the original nine. Purchase
    // entitlements stay: they belong to the store account, not to this
    // local data set.
    await (_db.delete(_db.moodLog)).go();
    await (_db.delete(_db.supportLog)).go();
    await (_db.delete(_db.indexSnapshot)).go();
    await (_db.delete(_db.planState)).go();
    await (_db.delete(_db.savingsGoalTable)).go();
    await (_db.delete(_db.cessationPlanTable)).go();
    await (_db.delete(_db.copingPlanTable)).go();
    await (_db.delete(_db.moodScreen)).go();
    await (_db.delete(_db.packPurchaseTable)).go();
  }

  DateTime? _dateOrNull(String? iso) =>
      iso == null ? null : DateTime.parse(iso);
}
