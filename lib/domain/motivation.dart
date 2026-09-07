/// Motivation numbers (report §16): process + result, no guilt.
///
/// Streak rule (§16): a broken streak is NOT highlighted — the longest
/// on-plan run is kept and shown, current is never displayed as zero.
library;

class Streaks {
  const Streaks({required this.currentDays, required this.longestDays});

  final int currentDays;
  final int longestDays;

  /// What the UI shows: never zero — a broken streak falls back to the
  /// longest run ("Yeniden başlamak normaldir.").
  int get displayDays => currentDays > 0 ? currentDays : longestDays;

  bool get isBroken => currentDays == 0;
}

/// One day of plan adherence (date-ordered, oldest first).
class DayAdherence {
  const DayAdherence({required this.count, required this.planTarget});

  final int count;
  final int? planTarget;

  bool get onPlan => planTarget == null || count <= planTarget!;
}

/// Computes current and longest on-plan streaks from daily summaries
/// ordered oldest → newest. Days without a plan target still count when the
/// user stayed within target==null (first days count only if recorded).
Streaks computeStreaks(List<DayAdherence> days) {
  var longest = 0;
  var run = 0;
  var current = 0;
  var sawBreak = false;

  for (final day in days) {
    if (day.onPlan) {
      run += 1;
      if (run > longest) {
        longest = run;
      }
    } else {
      run = 0;
      sawBreak = true;
    }
  }
  // Current streak: the trailing run. Zero when the last day broke the plan.
  current = run;
  if (days.isNotEmpty && !days.last.onPlan) {
    current = 0;
    sawBreak = true;
  }
  assert(!(!sawBreak && current == 0) || days.isEmpty);
  return Streaks(currentDays: current, longestDays: longest);
}
