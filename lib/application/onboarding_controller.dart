import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/cessation.dart';
import '../domain/entities.dart';
import '../domain/onboarding.dart';
import 'providers.dart';

/// Holds the seven onboarding answers and submits them to the repository.
class OnboardingController extends Notifier<OnboardingAnswers> {
  @override
  OnboardingAnswers build() {
    return OnboardingAnswers(
      ageBand: AgeBand.y25to34,
      baselineCpd: 20,
      ttfcBand: TtfcBand.five30,
      pricePerPack: 0,
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

  /// Declared rhythm: band minutes, or null for "not sure". Re-selecting an
  /// already picked band clears it back to null.
  void setRhythmMinutes(int? minutes) => state = OnboardingAnswers(
        ageBand: state.ageBand,
        baselineCpd: state.baselineCpd,
        ttfcBand: state.ttfcBand,
        pricePerPack: state.pricePerPack,
        packSize: state.packSize,
        triggers: state.triggers,
        targetMode: state.targetMode,
        brandName: state.brandName,
        quitReason: state.quitReason,
        rhythmMinutes: state.rhythmMinutes == minutes ? null : minutes,
        heightCm: state.heightCm,
        weightKg: state.weightKg,
        smokingYears: state.smokingYears,
      );

  void toggleTrigger(TriggerLabel label) {
    final current = {...state.triggers};
    if (!current.add(label)) {
      current.remove(label);
    }
    state = _copy(triggers: current);
  }

  void setTargetMode(TargetMode mode) => state = _copy(targetMode: mode);

  /// Body fields stay null when blank — never a made-up average (brain T5).
  void setBodyData({double? heightCm, double? weightKg, double? smokingYears}) =>
      state = OnboardingAnswers(
        ageBand: state.ageBand,
        baselineCpd: state.baselineCpd,
        ttfcBand: state.ttfcBand,
        pricePerPack: state.pricePerPack,
        packSize: state.packSize,
        triggers: state.triggers,
        targetMode: state.targetMode,
        brandName: state.brandName,
        quitReason: state.quitReason,
        rhythmMinutes: state.rhythmMinutes,
        heightCm: heightCm,
        weightKg: weightKg,
        smokingYears: smokingYears,
      );

  void setBrandName(String? brand) =>
      state = _copy(brandName: brand?.trim() ?? '');

  /// Clearing the reason has to be possible, so this one replaces rather
  /// than merges — the usual `??` copy would make deselection impossible.
  void setQuitReason(QuitReason? reason) => state = OnboardingAnswers(
    ageBand: state.ageBand,
    baselineCpd: state.baselineCpd,
    ttfcBand: state.ttfcBand,
    pricePerPack: state.pricePerPack,
    packSize: state.packSize,
    triggers: state.triggers,
    targetMode: state.targetMode,
    brandName: state.brandName,
      quitReason: reason,
      rhythmMinutes: state.rhythmMinutes,
      heightCm: state.heightCm,
      weightKg: state.weightKg,
      smokingYears: state.smokingYears,
    );

  Future<void> submit() async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.saveOnboardingAnswers(state, locale: _deviceLanguageCode());
    // The reason lives on the quit plan, not the smoking profile: it belongs
    // to the attempt, and the attempt is where it is read back from.
    if (state.quitReason != null) {
      await ref.read(databaseProvider).cessationDao.setReason(state.quitReason);
    }
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
      quitReason: current.quitReason,
      rhythmMinutes: current.rhythmMinutes,
      heightCm: current.heightCm,
      weightKg: current.weightKg,
      smokingYears: current.smokingYears,
    );
  }

  String _deviceLanguageCode() =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingAnswers>(
      OnboardingController.new,
    );
