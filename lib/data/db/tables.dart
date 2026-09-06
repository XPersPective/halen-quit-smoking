import 'package:drift/drift.dart';

import '../../domain/entities.dart';

/// Local schema per report §25 — 13 tables, fully on-device, SQLCipher
/// encrypted. Local calendar days are stored as ISO "yyyy-MM-dd" text to be
/// time-zone stable. Row classes carry an explicit `Row` suffix so table
/// classes and data classes never collide.

@DataClassName('UserProfileRow')
class UserProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get locale => text().withLength(min: 2, max: 10)();
  TextColumn get ageBand => textEnum<AgeBand>()();
}

@DataClassName('SmokingProfileRow')
class SmokingProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get baselineCpd => integer()();
  TextColumn get ttfcBand => textEnum<TtfcBand>()();
  RealColumn get pricePerPack => real()();
  IntColumn get packSize => integer().withDefault(const Constant(20))();
  TextColumn get brandId => text().nullable()();
  TextColumn get brandName => text().nullable()();
  TextColumn get targetMode => textEnum<TargetMode>()();
  TextColumn get pace => textEnum<Pace>()();
  DateTimeColumn get startedAt => dateTime()();
}

@DataClassName('CigaretteEventRow')
class CigaretteEvent extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  TextColumn get source => textEnum<RecordSource>()();
  TextColumn get triggerLabel => textEnum<TriggerLabel>().nullable()();
  TextColumn get mood => text().nullable()();
  TextColumn get context => text().nullable()();
  TextColumn get planDay => text().nullable()();
}

@DataClassName('CigaretteProductRow')
class CigaretteProduct extends Table {
  TextColumn get barcode => text()();
  TextColumn get brand => text()();
  TextColumn get variant => text().nullable()();
  IntColumn get packSize => integer()();
  TextColumn get market => text()();
  TextColumn get source => text()();
  BoolColumn get verifiedByUser => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {barcode};
}

@DataClassName('DailyPlanRow')
class DailyPlan extends Table {
  TextColumn get date => text()();
  IntColumn get targetCount => integer()();
  TextColumn get windowsJson => text().withDefault(const Constant('[]'))();
  TextColumn get phase => textEnum<PlanPhase>()();
  TextColumn get tempo => textEnum<Pace>()();
  TextColumn get quitDate => text().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}

@DataClassName('PlanAdjustmentRow')
class PlanAdjustment extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get reason => textEnum<AdjustmentReason>()();
  IntColumn get fromCount => integer()();
  IntColumn get toCount => integer()();
  TextColumn get messageKey => text()();
}

@DataClassName('TriggerRow')
class Trigger extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get labelKey => textEnum<TriggerLabel>()();
  TextColumn get custom => text().nullable()();
}

@DataClassName('CravingEventRow')
class CravingEvent extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  IntColumn get intensity => intEnum<CravingIntensity>()();
  TextColumn get triggerLabel => textEnum<TriggerLabel>().nullable()();
  TextColumn get outcome => textEnum<CravingOutcome>()();
}

@DataClassName('DailySummaryRow')
class DailySummary extends Table {
  TextColumn get date => text()();
  IntColumn get count => integer()();
  IntColumn get planTarget => integer().nullable()();
  RealColumn get adherence => real().nullable()();
  RealColumn get savings => real().withDefault(const Constant(0))();
  IntColumn get avoidedCount => integer().withDefault(const Constant(0))();
  IntColumn get resistedCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get firstTs => dateTime().nullable()();
  DateTimeColumn get lastTs => dateTime().nullable()();
  IntColumn get minGapMinutes => integer().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}

@DataClassName('TimelineStateRow')
class HealthTimelineState extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get quitTs => dateTime().nullable()();
  TextColumn get acknowledgedMilestones => text()
      .withDefault(const Constant('[]'))();
}

@DataClassName('MotivationContentRow')
class MotivationContent extends Table {
  TextColumn get id => text()();
  TextColumn get lang => text().withLength(min: 2, max: 2)();
  TextColumn get category => text()();
  TextColumn get body => text()();
  TextColumn get sourceUrl => text()();
  TextColumn get sourceDate => text()();
  TextColumn get conditionJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PurchaseEntitlementRow')
class PurchaseEntitlement extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get store => text()();
  TextColumn get productId => text()();
  TextColumn get purchaseToken => text()();
  TextColumn get state => text()();
  DateTimeColumn get lastVerifiedAt => dateTime()();
}

@DataClassName('SettingsRow')
class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get notifLevel => textEnum<NotificationDensity>()
      .withDefault(const Constant('standard'))();
  TextColumn get theme => textEnum<ThemeOption>()
      .withDefault(const Constant('system'))();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();
  BoolColumn get haptics => boolean().withDefault(const Constant(true))();
  DateTimeColumn get trialStartedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
