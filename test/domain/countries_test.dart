import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/quitline_directory.dart';
import 'package:halen/domain/countries.dart';

void main() {
  late CountryDirectory dir;

  setUpAll(() {
    dir = CountryDirectory.fromJson(
      File('assets/data/countries.json').readAsStringSync(),
    );
  });

  test('names come back in the user language, English as the fallback', () {
    expect(dir.nameOf('DE', ['tr', 'en']), 'Almanya');
    expect(dir.nameOf('DE', ['de', 'en']), 'Deutschland');
    expect(dir.nameOf('JP', ['ja', 'en']), '日本');
    expect(dir.nameOf('DE', ['xx', 'en']), 'Germany');
  });

  test('language tags map to the right name tables', () {
    expect(CountryDirectory.tagChain('iw').first, 'he');
    expect(CountryDirectory.tagChain('zh', countryCode: 'TW').first, 'zh-TW');
    expect(
      CountryDirectory.tagChain('zh', scriptCode: 'Hant').first,
      'zh-TW',
    );
    expect(
      CountryDirectory.tagChain('pt', countryCode: 'PT'),
      ['pt-PT', 'pt', 'en'],
    );
  });

  test('search finds by local name, English name and code; sorted', () {
    final chain = ['tr', 'en'];
    expect(dir.search('almanya', chain).map((c) => c.code), contains('DE'));
    expect(dir.search('germany', chain).map((c) => c.code), contains('DE'));
    expect(dir.search('de', chain).map((c) => c.code), contains('DE'));
    // Turkish dotted/dotless i do not break matching.
    expect(dir.search('turkiye', chain).first.code, 'TR');
    final all = dir.search('', chain);
    expect(all.length, greaterThan(240));
    final names = [for (final c in all) CountryDirectory.fold(c.name)];
    expect(names, [...names]..sort());
  });

  test('currency follows the country', () {
    expect(dir.currencyOf('TR'), 'TRY');
    expect(dir.currencyOf('US'), 'USD');
    expect(dir.currencyOf('DE'), 'EUR');
    expect(dir.currencyOf('JP'), 'JPY');
  });

  test('every quit line belongs to a real country and has a dialable number',
      () {
    for (final entry in quitlinesByCountry.entries) {
      expect(dir.contains(entry.key), isTrue, reason: entry.key);
      expect(entry.value, isNotEmpty);
      for (final line in entry.value) {
        expect(line.number.length, greaterThanOrEqualTo(2),
            reason: '${entry.key} ${line.display}');
      }
    }
  });

  test('previously verified lines are intact (no regressions)', () {
    String n(String c, int i) => quitlinesByCountry[c]![i].number;
    expect(n('TR', 0), '171');
    expect(n('TR', 1), '115');
    expect(n('US', 0), '18007848669');
    expect(n('DE', 0), '08008313131');
    expect(n('GB', 0), '03001231044');
    expect(n('GB', 1), '0800848484');
    expect(n('GB', 2), '08000852219');
  });
}
