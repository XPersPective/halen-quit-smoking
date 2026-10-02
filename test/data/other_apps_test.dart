import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/other_apps_repository.dart';

void main() {
  test('parses a valid catalogue and skips malformed records', () {
    final body = jsonEncode({
      'schema': 1,
      'apps': [
        {
          'id': 'a',
          'androidPackage': 'com.example.a',
          'icon': 'https://example.com/a.png',
          'name': {'en': 'A', 'tr': 'Aa'},
          'description': {'en': 'one'},
          'order': 2,
        },
        {'id': 'no_package', 'name': {'en': 'X'}},
        {'id': 'b', 'androidPackage': 'com.example.b', 'name': {}},
        'garbage',
        {
          'id': 'c',
          'androidPackage': 'com.example.c',
          'icon': 'http://insecure.example/c.png',
          'name': {'en': 'C'},
        },
      ],
    });
    final apps = OtherAppsRepository.parse(body);
    expect(apps.map((a) => a.id), ['a', 'c']);
    // A non-HTTPS icon is dropped, the record survives.
    expect(apps.last.iconUrl, isNull);
    expect(apps.first.storeUri.toString(),
        'https://play.google.com/store/apps/details?id=com.example.a');
  });

  test('wrong schema or broken JSON yields nothing, never throws', () {
    expect(OtherAppsRepository.parse('{"schema":2,"apps":[]}'), isEmpty);
    expect(OtherAppsRepository.parse('not json'), isEmpty);
    expect(OtherAppsRepository.parse('[]'), isEmpty);
  });

  test('text falls back to English, then anything; iw maps to he', () {
    const texts = {'en': 'Hello', 'he': 'שלום', 'tr': 'Merhaba'};
    expect(OtherApp.pick(texts, 'tr'), 'Merhaba');
    expect(OtherApp.pick(texts, 'iw'), 'שלום');
    expect(OtherApp.pick(texts, 'de'), 'Hello');
    expect(OtherApp.pick(const {'ja': 'こんにちは'}, 'de'), 'こんにちは');
  });
}
