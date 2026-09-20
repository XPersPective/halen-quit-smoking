import 'package:drift/drift.dart' hide Trigger;

import '../../domain/body_load_model.dart';
import '../../domain/cessation.dart';
import '../../domain/economy.dart';
import '../../domain/entities.dart';
import '../../domain/plan_kinds.dart';
import '../../domain/soft_taper.dart';
import 'daos/content_dao.dart';
import 'daos/craving_dao.dart';
import 'daos/cessation_dao.dart';
import 'daos/module_dao.dart';
import 'daos/pack_purchase_dao.dart';
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
    CessationPlanTable,
    CopingPlanTable,
    MoodScreen,
    PackPurchaseTable,
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
    CessationDao,
    PackPurchaseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.connect(super.e);

  @override
  int get schemaVersion => 10;

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
          if (from < 4) {
            // v4 — the opt-in risky-window heads-up.
            await m.addColumn(settings, settings.riskyWindowReminder);
          }
          if (from < 5) {
            // v5 — the quit attempt: a date, a reason, a person told, a plan
            // for the hard situations, and the mood screen. Additive only.
            await m.createTable(cessationPlanTable);
            await m.createTable(copingPlanTable);
            await m.createTable(moodScreen);
          }
          if (from < 6) {
            // v6 — purchase history and the pack label values. Additive.
            await m.addColumn(smokingProfile, smokingProfile.tarMgPerCigarette);
            await m.addColumn(
              smokingProfile,
              smokingProfile.nicotineMgPerCigarette,
            );
            await m.createTable(packPurchaseTable);
          }
          if (from < 7) {
            // v7 — the UI language override. Nullable, so existing rows keep
            // following the system language.
            await m.addColumn(settings, settings.appLocale);
          }
          if (from < 8) {
            // v8 — separate opt-in for the day-5 trial nudge (brain T2).
            // Default false: the trial clock never grants marketing consent.
            await m.addColumn(settings, settings.trialNudge);
          }
          if (from < 9) {
            // v9 — the onboarding-declared smoking rhythm (brain T4).
            await m.addColumn(
              smokingProfile,
              smokingProfile.declaredRhythmMinutes,
            );
          }
          if (from < 10) {
            // v10 — home-widget customisation (brain T7).
            await m.addColumn(settings, settings.widgetShowLastCigarette);
            await m.addColumn(settings, settings.widgetTheme);
          }
        },
      );
}
