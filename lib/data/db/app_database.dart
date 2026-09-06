import 'package:drift/drift.dart' hide Trigger;

import '../../domain/entities.dart';
import 'daos/content_dao.dart';
import 'daos/craving_dao.dart';
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.connect(super.e);

  @override
  int get schemaVersion => 1;

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
      );
}
