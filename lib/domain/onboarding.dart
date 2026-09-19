import 'cessation.dart';
import 'entities.dart';

/// The seven onboarding answers (report §11). Deliberately minimal data:
/// no birthday, sex, weight, health conditions or pregnancy status.
class OnboardingAnswers {
  const OnboardingAnswers({
    required this.ageBand,
    required this.baselineCpd,
    required this.ttfcBand,
    required this.pricePerPack,
    required this.packSize,
    required this.triggers,
    required this.targetMode,
    this.brandName,
    this.quitReason,
    this.rhythmMinutes,
    this.heightCm,
    this.weightKg,
    this.smokingYears,
  });

  final AgeBand ageBand;
  final int baselineCpd;
  final TtfcBand ttfcBand;
  final double pricePerPack;
  final int packSize;
  final Set<TriggerLabel> triggers;
  final TargetMode targetMode;
  final String? brandName;

  /// Declared typical gap between cigarettes, in minutes. Null is the
  /// honest "not sure"; it seeds (never locks) the taper's first interval.
  final int? rhythmMinutes;

  /// Optional body context for the harm-load index (brain T5): sharpening
  /// only — nothing is gated on them, and "not shared" stays null forever.
  final double? heightCm;
  final double? weightKg;
  final double? smokingYears;

  /// Why they are doing this, in their own words. Optional — the app never
  /// blocks on it (premium brief §C.7).
  final QuitReason? quitReason;

  bool get valid =>
      baselineCpd >= 1 &&
      baselineCpd <= 60 &&
      packSize >= 1 &&
      packSize <= 100 &&
      pricePerPack.isFinite &&
      pricePerPack > 0 &&
      pricePerPack <= 1000000 &&
      (brandName?.trim().isNotEmpty ?? false) &&
      brandName!.trim().length <= 100 &&
      (rhythmMinutes == null ||
          (rhythmMinutes! >= 10 && rhythmMinutes! <= 720)) &&
      (heightCm == null ||
          (heightCm!.isFinite && heightCm! >= 100 && heightCm! <= 230)) &&
      (weightKg == null ||
          (weightKg!.isFinite && weightKg! >= 30 && weightKg! <= 300)) &&
      (smokingYears == null ||
          (smokingYears!.isFinite &&
              smokingYears! >= 0 &&
              smokingYears! <= maxPlausibleSmokingYears(ageBand)));

  /// A smoking history cannot exceed the person's lifetime; we read the age
  /// band's upper edge and assume nobody started before 13. `y55plus` has no
  /// real ceiling, so use a generous 80 years — this is a sanity guard, not
  /// a clinical limit.
  static double maxPlausibleSmokingYears(AgeBand band) => switch (band) {
    AgeBand.under18 => 4,
    AgeBand.y18to24 => 11,
    AgeBand.y25to34 => 21,
    AgeBand.y35to44 => 31,
    AgeBand.y45to54 => 41,
    AgeBand.y55plus => 80,
  };

  /// Optional body fields: blank is legal (means "not shared"), typed text
  /// must be a clean decimal inside [min, max]. Two-step API because the UI
  /// must tell "empty" apart from "invalid".
  static bool bodyFieldOk(String raw, {required double min, required double max}) {
    final text = raw.trim();
    if (text.isEmpty) return true;
    return parseBodyField(text, min: min, max: max) != null;
  }

  /// Blank → null (unspecified); invalid → null as well, so always check
  /// [bodyFieldOk] first in the form validator.
  static double? parseBodyField(String raw, {required double min, required double max}) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    if (!RegExp(r'^\d{1,3}(?:[.,]\d{1,2})?$').hasMatch(text)) return null;
    final v = double.tryParse(text.replaceAll(',', '.'));
    if (v == null || !v.isFinite || v < min || v > max) return null;
    return v;
  }

  /// Decimal input, not scientific notation, NaN, infinity or digit stripping.
  static double? parsePrice(String value) {
    final text = value.trim();
    if (!RegExp(r'^\d+(?:[.,]\d{1,2})?$').hasMatch(text)) return null;
    final price = double.tryParse(text.replaceAll(',', '.'));
    return price != null && price.isFinite && price > 0 && price <= 1000000
        ? price
        : null;
  }

  static int? parsePackSize(String value) {
    final text = value.trim();
    if (!RegExp(r'^\d{1,3}$').hasMatch(text)) return null;
    final count = int.tryParse(text);
    return count != null && count >= 1 && count <= 100 ? count : null;
  }
}

/// Country-based defaults for the pack price question (report §11 step 4:
/// pre-filled, editable). Values are typical 2026 retail prices per report §2.
class PackPriceDefaults {
  static const _byCountryCode = <String, (double, String)>{
    'tr': (130.0, '₺'),
    'us': (10.15, r'$'),
    'gb': (16.50, '£'),
    'de': (9.75, '€'),
    'at': (9.75, '€'),
    'jp': (600.0, '¥'),
  };

  static const fallback = (10.0, r'$');

  static double priceFor(String? countryCode) =>
      (_byCountryCode[countryCode?.toLowerCase()] ?? fallback).$1;

  static String currencySymbolFor(String? countryCode) =>
      (_byCountryCode[countryCode?.toLowerCase()] ?? fallback).$2;
}
