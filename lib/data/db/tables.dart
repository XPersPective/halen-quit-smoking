import 'package:drift/drift.dart';

import '../../domain/body_load_model.dart';
import '../../domain/cessation.dart';
import '../../domain/economy.dart';
import '../../domain/entities.dart';
import '../../domain/plan_kinds.dart';
import '../../domain/soft_taper.dart';

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

  // Optional Harm Load inputs (module report §14.2). Every one of these may
  // stay null: no feature is gated on body data and the index renormalizes
  // its weights over whatever the user chose to share.
  RealColumn get heightCm => real().nullable()();
  RealColumn get weightKg => real().nullable()();
  TextColumn get sex => textEnum<SexOption>().nullable()();
  RealColumn get smokingYears => real().nullable()();
  IntColumn get hsi => integer().nullable()();
  TextColumn get metabolism => textEnum<MetabolismSpeed>()
      .withDefault(const Constant('normal'))();

  // The pack label's machine yields per cigarette (item 4). Optional: when
  // absent, the legal maximum is used and the screen says so.
  RealColumn get tarMgPerCigarette => real().nullable()();
  RealColumn get nicotineMgPerCigarette => real().nullable()();
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

  /// Which SOS technique the user reached for (module report §5.⑤) — powers
  /// the "what worked for you before" ordering. Null for older records.
  TextColumn get techniqueKey => text().nullable()();
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

  /// Opt-in pre-log pause in seconds (module report §12.③). The record is
  /// still written immediately; the pause only offers a window to undo it.
  /// 0 = off, the default.
  IntColumn get preLogPauseSeconds => integer()
      .withDefault(const Constant(0))();

  /// Opt-in heads-up 20 minutes before the riskiest hour of the day
  /// (module report §4.③). Off by default — the category's own reviews show
  /// what unrequested pushes do to a quit app's rating.
  BoolColumn get riskyWindowReminder =>
      boolean().withDefault(const Constant(false))();

  /// UI language override: 'en', 'tr' or 'de'. Null = follow the system
  /// language, the default.
  TextColumn get appLocale => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// How the user actually felt, against what the model guessed
/// (module report §8). The pair teaches the personal offset and lets the app
/// show its own accuracy instead of hiding it.
@DataClassName('MoodLogRow')
class MoodLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();

  /// The user's own report, 0 = calm, 1 = under pressure, 2 = tough.
  IntColumn get reportedBand => integer()();

  /// What the model estimated at that moment, 0..1 — kept so accuracy can be
  /// computed later without re-deriving history.
  RealColumn get estimated => real()();

  /// True when the app asked, false when the user opened it themselves.
  BoolColumn get prompted => boolean().withDefault(const Constant(false))();
}

/// Daily support-card completions (module report §10). Skipping costs
/// nothing: absence of a row is not a failure anywhere in the app.
@DataClassName('SupportLogRow')
class SupportLog extends Table {
  TextColumn get date => text()();
  TextColumn get cardKey => text()();
  BoolColumn get done => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {date, cardKey};
}

/// Daily snapshot of the two indices (module report §14) — the history the
/// Progress Score needs for its ±4/day clamp and its 7-day delta, and the
/// series both index charts draw.
@DataClassName('IndexSnapshotRow')
class IndexSnapshot extends Table {
  TextColumn get date => text()();
  IntColumn get progressScore => integer()();
  IntColumn get harmLoad => integer()();

  @override
  Set<Column> get primaryKey => {date};
}

/// The active plan and its switching history (module report §13).
@DataClassName('PlanStateRow')
class PlanState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get kind => textEnum<PlanKind>()
      .withDefault(const Constant('gradualTaper'))();
  DateTimeColumn get startedAt => dateTime()();

  /// Current and final target interval for the taper engine, in minutes.
  IntColumn get intervalMinutes => integer().nullable()();
  IntColumn get targetIntervalMinutes => integer().nullable()();

  /// Days spent at the current taper step — the stabilization counter.
  IntColumn get daysAtStep => integer().withDefault(const Constant(0))();
  TextColumn get taperMode => textEnum<TaperMode>()
      .withDefault(const Constant('gentle'))();

  /// ISO dates of recent plan switches, JSON array.
  TextColumn get switchHistoryJson => text()
      .withDefault(const Constant('[]'))();

  /// The local day the taper engine last ran, and what it decided. The
  /// engine acts at most once per calendar day, and reading a stored
  /// decision keeps the daily provider free of any write — a provider that
  /// both watches and writes this table would loop forever.
  TextColumn get lastStepDate => text().nullable()();
  TextColumn get lastStepDecision => textEnum<TaperDecision>().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The user's own savings goal — always ranked above any equivalent the app
/// could suggest (module report §3.③).
@DataClassName('SavingsGoalRow')
class SavingsGoalTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get label => text()();
  RealColumn get amount => real()();

  @override
  Set<Column> get primaryKey => {id};
}


/// The quit attempt itself (premium brief §C.2, §C.4, §C.6).
///
/// One row. Everything here is optional: a person can use the app to reduce
/// without ever setting a date, and nothing is gated on filling this in.
@DataClassName('CessationPlanRow')
class CessationPlanTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// Local calendar day, ISO "yyyy-MM-dd" — a quit date is a day, not an
  /// instant, and storing it as one keeps it stable across time zones.
  TextColumn get quitDate => text().nullable()();

  /// Times the date has been moved. Counted, never scolded.
  IntColumn get quitDateMoves => integer().withDefault(const Constant(0))();

  TextColumn get reason => textEnum<QuitReason>().nullable()();

  /// First name or nickname only. The app stores no contact details and
  /// never reads the address book.
  TextColumn get supportPerson => text().nullable()();

  BoolColumn get notAPuffAccepted =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One high-risk situation and what the person will do instead.
@DataClassName('CopingPlanRow')
class CopingPlanTable extends Table {
  TextColumn get trigger => textEnum<TriggerLabel>()();
  TextColumn get plan => text()();
  BoolColumn get rehearsed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {trigger};
}

/// A PHQ-2 result. Kept so the app can notice a trend and offer the
/// referral again — never to label the user.
@DataClassName('MoodScreenRow')
class MoodScreen extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  IntColumn get lowInterest => integer()();
  IntColumn get lowMood => integer()();
  IntColumn get total => integer()();
}


/// A pack purchase, as it happened (items 2 and 3). Price and brand are per
/// purchase, not per profile, because people do not buy one pack at one price
/// forever.
@DataClassName('PackPurchaseRow')
class PackPurchaseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get ts => dateTime()();
  IntColumn get packs => integer().withDefault(const Constant(1))();
  RealColumn get pricePerPack => real()();
  IntColumn get packSize => integer().withDefault(const Constant(20))();
  TextColumn get brand => text().nullable()();
}
