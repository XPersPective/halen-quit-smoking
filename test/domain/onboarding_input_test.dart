import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/onboarding.dart';

void main() {
  test('price accepts local decimals, rejects unsafe or ambiguous numbers', () {
    expect(OnboardingAnswers.parsePrice('12,50'), 12.5);
    expect(OnboardingAnswers.parsePrice(' 12.5 '), 12.5);
    for (final value in [
      '',
      '0',
      '-1',
      'NaN',
      'Infinity',
      '1e6',
      '1.234',
      '1,234.50',
      '1000001',
      'hello',
    ]) {
      expect(OnboardingAnswers.parsePrice(value), isNull, reason: value);
    }
  });
  test('pack count is integral and never strips decimal separators', () {
    expect(OnboardingAnswers.parsePackSize('20'), 20);
    for (final value in ['', '1.2', '1,2', '-2', '0', '101', 'NaN', '1e2']) {
      expect(OnboardingAnswers.parsePackSize(value), isNull, reason: value);
    }
  });

  OnboardingAnswers baseAnswers({int? rhythm}) => OnboardingAnswers(
        ageBand: AgeBand.y25to34,
        baselineCpd: 15,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        packSize: 20,
        triggers: const {},
        targetMode: TargetMode.reduce,
        brandName: 'X',
        rhythmMinutes: rhythm,
      );

  test('rhythm is optional but bounded when given', () {
    expect(baseAnswers(rhythm: 45).valid, isTrue);
    expect(baseAnswers(rhythm: 10).valid, isTrue);
    expect(baseAnswers(rhythm: 720).valid, isTrue);
    expect(baseAnswers(rhythm: null).valid, isTrue);
    expect(baseAnswers(rhythm: 5).valid, isFalse);
    expect(baseAnswers(rhythm: 721).valid, isFalse);
  });

  test('body fields: blank is valid, typed values stay in domain bounds', () {
    expect(OnboardingAnswers.bodyFieldOk('', min: 100, max: 230), isTrue);
    expect(OnboardingAnswers.bodyFieldOk('170', min: 100, max: 230), isTrue);
    expect(OnboardingAnswers.bodyFieldOk('45,5', min: 30, max: 300), isTrue);
    for (final bad in ['', 'abc']) {
      assert(OnboardingAnswers.parseBodyField(bad, min: 1, max: 2) == null);
    }
    expect(OnboardingAnswers.bodyFieldOk('95', min: 100, max: 230), isFalse);
    expect(OnboardingAnswers.bodyFieldOk('1.5.5', min: 1, max: 2), isFalse);
    expect(OnboardingAnswers.bodyFieldOk('NaN', min: 1, max: 2), isFalse);
  });

  test('smoking years cannot exceed the age band', () {
    expect(baseAnswers(rhythm: null).valid, isTrue);
    expect(
      OnboardingAnswers(
        ageBand: AgeBand.y25to34,
        baselineCpd: 15,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        packSize: 20,
        triggers: const {},
        targetMode: TargetMode.reduce,
        brandName: 'X',
        smokingYears: 40,
      ).valid,
      isFalse,
    );
    expect(
      OnboardingAnswers(
        ageBand: AgeBand.y25to34,
        baselineCpd: 15,
        ttfcBand: TtfcBand.five30,
        pricePerPack: 100,
        packSize: 20,
        triggers: const {},
        targetMode: TargetMode.reduce,
        brandName: 'X',
        smokingYears: 20,
        heightCm: 172,
        weightKg: 70,
      ).valid,
      isTrue,
    );
  });
}
