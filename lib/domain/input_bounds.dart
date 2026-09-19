/// Central, domain-level bounds for every user-reachable input (brain T6).
library;

/// The UI-level `TextField` pattern ("type, tryParse, silent null") is only
/// safe when every caller guards with these same rules — otherwise one screen
/// accepts `9999cm` height while another rejects it. Constants are public so
/// onboarding, settings and tests share one literal instead of drifting.
abstract final class InputBounds {
  /// Money (price, goal amount). Strictly positive, finite, capped at an
  /// intentionally generous 1,000,000.
  static const moneyMax = 1000000.0;
  static bool money(double? v) =>
      v != null && v.isFinite && v > 0 && v <= moneyMax;

  /// Pack size: integer 1..100.
  static const packSizeMax = 100;
  static bool packSize(int? v) => v != null && v >= 1 && v <= packSizeMax;

  /// Optional body number, bounded when non-null. Shared with onboarding so
  /// settings can't loosen what onboarding forbids.
  static const heightMin = 100.0;
  static const heightMax = 230.0;
  static const weightMin = 30.0;
  static const weightMax = 300.0;
  static const smokingYearsMax = 99.0;
  static bool heightCm(double? v) =>
      v == null || (v.isFinite && v >= heightMin && v <= heightMax);
  static bool weightKg(double? v) =>
      v == null || (v.isFinite && v >= weightMin && v <= weightMax);
  static bool smokingYears(double? v) =>
      v == null || (v.isFinite && v >= 0 && v <= smokingYearsMax);

  /// Pack-label chemistry: the legal EU/TR max is 10 mg tar / 1 mg nicotine,
  /// but some markets print above it. Sanity ceiling — a typo/paste guard,
  /// not a clinical rule.
  static const tarMax = 50.0;
  static const nicotineMax = 10.0;
  static bool tarMg(double? v) =>
      v == null || (v.isFinite && v >= 0 && v <= tarMax);
  static bool nicotineMg(double? v) =>
      v == null || (v.isFinite && v >= 0 && v <= nicotineMax);

  /// A brand / label / goal name: trimmed, 1..100 visible characters.
  /// Null or blank stays null — "not set" is legal.
  static String? name(String? raw) {
    final t = raw?.trim();
    if (t == null || t.isEmpty) return null;
    return t.length <= 100 ? t : t.substring(0, 100);
  }
}
