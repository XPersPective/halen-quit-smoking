import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/entities.dart';
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
      'timeline': {
        'quitTs': timeline.quitTs?.toIso8601String(),
        'acknowledgedMilestones': timeline.acknowledgedMilestones,
      },
      'settings': {
        'notifLevel': settings.notifLevel.name,
        'theme': settings.theme.name,
        'reduceMotion': settings.reduceMotion,
        'haptics': settings.haptics,
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

      final timeline = data['timeline'] as Map<String, dynamic>?;
      if (timeline != null) {
        await _db.timelineDao.setQuitTs(
          _dateOrNull(timeline['quitTs'] as String?),
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
      await _db.timelineDao.setQuitTs(null);
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
  }

  DateTime? _dateOrNull(String? iso) =>
      iso == null ? null : DateTime.parse(iso);
}
