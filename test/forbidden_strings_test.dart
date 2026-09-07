import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Ethics lint (report §13/§39, prompt §13): banned claim strings must never
/// appear in user-visible copy (ARB files) or Dart sources. These phrases
/// would imply medical claims or fake biological measurement (S5 class).
void main() {
  /// Plain substring bans (Turkish phrases from the report).
  const bannedSubstrings = [
    'tedavi eder',
    'garanti',
    'detoks',
    'kanındaki gerçek',
    'ölçüldü',
  ];

  /// Word-boundary bans for English/German equivalents — avoids false hits
  /// on "secure"/"ensure" for "cure" etc.
  final bannedPatterns = [
    RegExp(r'\bcures?\b', caseSensitive: false),
    RegExp(r'\bguarantee(d)?\b', caseSensitive: false),
    RegExp(r'\bdetox\b', caseSensitive: false),
    RegExp(r'\bgemessen\b', caseSensitive: false),
    RegExp(r'\bgarantiert(er|es|e)?\b', caseSensitive: false),
  ];

  Iterable<File> sources() sync* {
    yield* Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'));
    final tool = Directory('tool');
    if (tool.existsSync()) {
      yield* tool
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));
    }
  }

  Iterable<File> arbFiles() => Directory('lib/l10n')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'));

  test('no banned claim strings in sources and ARB copy', () {
    final offenders = <String>[];
    for (final file in [...sources(), ...arbFiles()]) {
      final content = file.readAsStringSync();
      final lower = content.toLowerCase();
      for (final phrase in bannedSubstrings) {
        if (lower.contains(phrase.toLowerCase())) {
          offenders.add('${file.path}: "$phrase"');
        }
      }
      for (final pattern in bannedPatterns) {
        if (pattern.hasMatch(content)) {
          offenders.add('${file.path}: ${pattern.pattern}');
        }
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
