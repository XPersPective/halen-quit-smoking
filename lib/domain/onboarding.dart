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
  });

  final AgeBand ageBand;
  final int baselineCpd;
  final TtfcBand ttfcBand;
  final double pricePerPack;
  final int packSize;
  final Set<TriggerLabel> triggers;
  final TargetMode targetMode;
  final String? brandName;

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
      brandName!.trim().length <= 100;

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
