import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities.dart';
import '../domain/onboarding.dart';
import 'providers.dart';

/// Holds the seven onboarding answers and submits them to the repository.
class OnboardingController extends Notifier<OnboardingAnswers> {
  @override
  OnboardingAnswers build() {
    final price = PackPriceDefaults.priceFor(countryCode());
    return OnboardingAnswers(
      ageBand: AgeBand.y25to34,
      baselineCpd: 15,
      ttfcBand: TtfcBand.five30,
      pricePerPack: price,
      packSize: 20,
      triggers: const {},
      targetMode: TargetMode.reduce,
    );
  }

  /// Pre-fill the pack price from the device locale (report §11 step 4).
  static String? _countryCodeOverride;

  static String? countryCode() => _countryCodeOverride;

  /// Allows tests to seed the device country (no platform plugin needed).
  static void setCountryCodeOverride(String? code) =>
      _countryCodeOverride = code;

  void setAgeBand(AgeBand band) => state = _copy(ageBand: band);

  void setBaseline(int cpd) => state = _copy(baselineCpd: cpd);

  void setTtfc(TtfcBand band) => state = _copy(ttfcBand: band);

  void setPricePerPack(double price) => state = _copy(pricePerPack: price);

  void setPackSize(int size) => state = _copy(packSize: size);

  void toggleTrigger(TriggerLabel label) {
    final current = {...state.triggers};
    if (!current.add(label)) {
      current.remove(label);
    }
    state = _copy(triggers: current);
  }

  void setTargetMode(TargetMode mode) => state = _copy(targetMode: mode);

  void setBrandName(String? brand) => state = _copy(brandName: brand);

  Future<void> submit() async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.saveOnboardingAnswers(state, locale: _deviceLanguageCode());
  }

  /// Under-18 path (report §39): the age band is recorded, no smoking
  /// profile and no plan are created.
  Future<void> submitUnder18() async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.saveUnder18Profile(locale: _deviceLanguageCode());
  }

  OnboardingAnswers _copy({
    AgeBand? ageBand,
    int? baselineCpd,
    TtfcBand? ttfcBand,
    double? pricePerPack,
    int? packSize,
    Set<TriggerLabel>? triggers,
    TargetMode? targetMode,
    String? brandName,
  }) {
    final current = state;
    return OnboardingAnswers(
      ageBand: ageBand ?? current.ageBand,
      baselineCpd: baselineCpd ?? current.baselineCpd,
      ttfcBand: ttfcBand ?? current.ttfcBand,
      pricePerPack: pricePerPack ?? current.pricePerPack,
      packSize: packSize ?? current.packSize,
      triggers: triggers ?? current.triggers,
      targetMode: targetMode ?? current.targetMode,
      brandName: brandName ?? current.brandName,
    );
  }

  String _deviceLanguageCode() =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingAnswers>(
  OnboardingController.new,
);
