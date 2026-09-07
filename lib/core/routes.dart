/// Route names for the app. Navigation stays on Flutter's built-in Navigator
/// (no extra router package) — the screen count is small and fixed (14).
library;

abstract final class Routes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const today = '/today';
  static const recordDetail = '/record-detail';
  static const plan = '/plan';
  static const stats = '/stats';
  static const cravingSos = '/craving-sos';
  static const settings = '/settings';
  static const paywall = '/paywall';
  static const healthTimeline = '/health-timeline';
  static const howCalculated = '/how-calculated';
  static const under18 = '/under-18';
  static const breathing = '/breathing';
}
