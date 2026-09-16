import 'package:flutter_test/flutter_test.dart';
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
}
