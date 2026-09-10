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
