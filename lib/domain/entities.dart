/// Shared domain enumerations used across all layers.
/// Pure Dart — no Flutter imports (report §24: domain must be 100% testable).
library;

enum AgeBand { under18, y18to24, y25to34, y35to44, y45to54, y55plus }

/// Time to first cigarette after waking — the strongest single HSI/FTND item.
enum TtfcBand { under5, five30, thirtyOne60, over60 }

enum TargetMode { reduce, quitNow, undecided }

/// Reduction speed preference (report §14).
/// Calm ≈ 8 weeks at 8–10%/week, Standard ≈ 6 weeks at 12–15%, Fast ≈ 4 weeks at 18–22%.
enum Pace {
  calm(8, 0.09, 0.08, 0.10),
  standard(6, 0.135, 0.12, 0.15),
  fast(4, 0.20, 0.18, 0.22);

  const Pace(this.baseWeeks, this.weeklyRate, this.minWeeklyRate, this.maxWeeklyRate);

  final int baseWeeks;
  final double weeklyRate;
  final double minWeeklyRate;
  final double maxWeeklyRate;
}

/// Where a cigarette record came from (report §25 CigaretteEvent.source).
enum RecordSource { app, widget, tile, control, notif }

enum PlanPhase { reduction, finalWeek, quit }

enum AdjustmentReason { overshoot, weekend, missed, paceUp, paceDown }

enum CravingOutcome { resisted, smoked, expired }

enum CravingIntensity { mild, medium, strong }

/// Fixed trigger labels (report §11/§19 — 8+ labels).
enum TriggerLabel {
  coffee,
  afterMeal,
  stress,
  alcohol,
  car,
  social,
  workBreak,
  beforeSleep,
  wakeUp,
}

/// Notification density (report §20): three levels plus a full off switch.
enum NotificationDensity { calm, standard, intense, off }

enum ThemeOption { system, light, dark }
