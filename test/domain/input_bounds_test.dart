import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/input_bounds.dart';

void main() {
  test('money bound: positive finite up to 1,000,000 only', () {
    expect(InputBounds.money(12.5), isTrue);
    expect(InputBounds.money(1), isTrue);
    expect(InputBounds.money(1000000), isTrue);
    for (final bad in [null, 0.0, -0.1, double.nan, double.infinity, 1000001.0]) {
      expect(InputBounds.money(bad), isFalse, reason: '$bad');
    }
  });

  test('pack size: whole 1..100 only', () {
    expect(InputBounds.packSize(20), isTrue);
    expect(InputBounds.packSize(1), isTrue);
    expect(InputBounds.packSize(100), isTrue);
    for (final bad in [null, 0, -1, 101, 10000]) {
      expect(InputBounds.packSize(bad), isFalse, reason: '$bad');
    }
  });

  test('body values: null is honest absence, bounds hold when given', () {
    expect(InputBounds.heightCm(null), isTrue);
    expect(InputBounds.heightCm(100), isTrue);
    expect(InputBounds.heightCm(230), isTrue);
    expect(InputBounds.heightCm(99), isFalse);
    expect(InputBounds.weightKg(30), isTrue);
    expect(InputBounds.weightKg(300), isTrue);
    expect(InputBounds.weightKg(301), isFalse);
    expect(InputBounds.smokingYears(0), isTrue);
    expect(InputBounds.smokingYears(99), isTrue);
    expect(InputBounds.smokingYears(100), isFalse);
    expect(InputBounds.smokingYears(-1), isFalse);
    expect(InputBounds.smokingYears(double.nan), isFalse);
  });

  test('label chemistry: generous but sane caps', () {
    expect(InputBounds.tarMg(null), isTrue);
    expect(InputBounds.tarMg(10), isTrue);
    expect(InputBounds.tarMg(50), isTrue);
    expect(InputBounds.tarMg(51), isFalse);
    expect(InputBounds.tarMg(-1), isFalse);
    expect(InputBounds.nicotineMg(10), isTrue);
    expect(InputBounds.nicotineMg(11), isFalse);
  });

  test('names trim and cap at 100 chars; blank is null', () {
    expect(InputBounds.name(null), isNull);
    expect(InputBounds.name('   '), isNull);
    expect(InputBounds.name('  Brand  '), 'Brand');
    expect(InputBounds.name('x' * 101)!.length, 100);
  });
}
