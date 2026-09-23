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
    // Module report §0.1 — S5 claims: a phone cannot measure any of these,
    // so the app may model them but never assert them about a body.
    'kanındaki nikotin',
    'kanındaki katran',
    'akciğerinin %',
    'ciğerinin %',
    'in deinem blut',
    // Claims that turn population guidance into a guarantee or a fixed
    // personal timetable.
    'mucizevi onarım',
    'mutlaka kırılır',
    'irade yükünü %90',
    'completely cleared',
    'cravings peak and fade within',
    'nach 72 stunden ist der körper nikotinfrei',
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

  test('no hardcoded Turkish copy in the presentation layer', () {
    // UI copy must come from the ARB catalogs: a Turkish literal in
    // lib/presentation ships Turkish text to English and German users.
    // Comments are skipped; only quoted literals are checked.
    final literal = RegExp(r'''(['"])([^'"\n]*)\1''');
    final turkishChars = RegExp('[şıİŞğĞ]');
    final offenders = <String>[];
    for (final file in Directory('lib/presentation')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))) {
      for (final line in file.readAsLinesSync()) {
        final cut = line.indexOf('//');
        final code = cut >= 0 ? line.substring(0, cut) : line;
        for (final match in literal.allMatches(code)) {
          if (turkishChars.hasMatch(match.group(2)!)) {
            offenders.add('${file.path}: ${match.group(2)}');
          }
        }
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
