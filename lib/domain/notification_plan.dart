import 'entities.dart';

/// Which notification types a density level schedules (report §20).
///
/// Defaults per type: plan reminder OFF everywhere (spam risk); daily
/// summary and morning goal ON at standard; intense adds the midday
/// gentle-return nudge; off schedules nothing.
class DensityPlan {
  const DensityPlan({
    required this.dailySummary,
    required this.morningGoal,
    required this.planReminder,
    required this.gentleReturn,
  });

  final bool dailySummary;
  final bool morningGoal;
  final bool planReminder;
  final bool gentleReturn;

  static DensityPlan forDensity(NotificationDensity density) =>
      switch (density) {
        NotificationDensity.off => const DensityPlan(
            dailySummary: false,
            morningGoal: false,
            planReminder: false,
            gentleReturn: false,
          ),
        NotificationDensity.calm => const DensityPlan(
            dailySummary: true,
            morningGoal: false,
            planReminder: false,
            gentleReturn: false,
          ),
        NotificationDensity.standard => const DensityPlan(
            dailySummary: true,
            morningGoal: true,
            planReminder: false,
            gentleReturn: false,
          ),
        NotificationDensity.intense => const DensityPlan(
            dailySummary: true,
            morningGoal: true,
            planReminder: false,
            gentleReturn: true,
          ),
      };
}
