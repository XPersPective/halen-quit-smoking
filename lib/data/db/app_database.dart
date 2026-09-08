import 'package:drift/drift.dart' hide Trigger;

import '../../domain/body_load_model.dart';
import '../../domain/economy.dart';
import '../../domain/entities.dart';
import '../../domain/plan_kinds.dart';
import '../../domain/soft_taper.dart';
import 'daos/content_dao.dart';
import 'daos/craving_dao.dart';
import 'daos/module_dao.dart';
import 'daos/plan_dao.dart';
import 'daos/profile_dao.dart';
import 'daos/purchase_dao.dart';
import 'daos/record_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/stats_dao.dart';
import 'daos/timeline_dao.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserProfile,
    SmokingProfile,
    CigaretteEvent,
    CigaretteProduct,
    DailyPlan,
    PlanAdjustment,
    Trigger,
    CravingEvent,
    DailySummary,
    HealthTimelineState,
    MotivationContent,
    PurchaseEntitlement,
    Settings,
    MoodLog,
    SupportLog,
    IndexSnapshot,
    PlanState,
    SavingsGoalTable,
  ],
  daos: [
    ProfileDao,
    RecordDao,
    PlanDao,
    CravingDao,
    StatsDao,
    ContentDao,
    PurchaseDao,
    SettingsDao,
    TimelineDao,
    ModuleDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.connect(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(settings).insert(
            SettingsCompanion.insert(),
            mode: InsertMode.insertOrIgnore,
          );
          await into(healthTimelineState).insert(
            HealthTimelineStateCompanion.insert(),
            mode: InsertMode.insertOrIgnore,
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2 — module report tables and their optional profile inputs.
            // Every added column is nullable or defaulted, so existing rows
            // stay valid and no user data is touched.
            await m.addColumn(smokingProfile, smokingProfile.heightCm);
            await m.addColumn(smokingProfile, smokingProfile.weightKg);
            await m.addColumn(smokingProfile, smokingProfile.sex);
            await m.addColumn(smokingProfile, smokingProfile.smokingYears);
            await m.addColumn(smokingProfile, smokingProfile.hsi);
            await m.addColumn(smokingProfile, smokingProfile.metabolism);
            await m.addColumn(cravingEvent, cravingEvent.techniqueKey);
            await m.addColumn(settings, settings.preLogPauseSeconds);
            await m.createTable(moodLog);
            await m.createTable(supportLog);
            await m.createTable(indexSnapshot);
            await m.createTable(planState);
            await m.createTable(savingsGoalTable);
          }
          if (from < 3) {
            // v3 — the taper engine's once-a-day marker.
            await m.addColumn(planState, planState.lastStepDate);
            await m.addColumn(planState, planState.lastStepDecision);
          }
        },
      );
}
