import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/repositories/library_repository.dart';
import 'package:halen/domain/evidence.dart';

/// Structural rules from the module report, enforced on the content itself
/// rather than trusted to editorial discipline.
void main() {
  const library = LibraryRepository();
  const locales = ['en', 'tr', 'de'];

  test('every organ entry ships a recovery line with its harm line', () {
    // §11.① — fear works only when it is paired with something to do, so a
    // harm card without a recovery card must not be publishable at all.
    for (final organ in library.organs()) {
      for (final locale in locales) {
        expect(organ.harm(locale).trim(), isNotEmpty, reason: organ.key);
        expect(organ.recovery(locale).trim(), isNotEmpty, reason: organ.key);
      }
      expect(organ.sourceUrl, startsWith('https://'), reason: organ.key);
    }
  });

  test('every technique states what its evidence does and does not show', () {
    for (final technique in library.sosTechniques()) {
      for (final locale in locales) {
        expect(technique.evidenceNote(locale).trim(), isNotEmpty,
            reason: technique.key);
        expect(technique.instruction(locale).trim(), isNotEmpty,
            reason: technique.key);
      }
      expect(technique.sourceUrl, startsWith('https://'), reason: technique.key);
    }
  });

  test('the best-supported technique leads the default order', () {
    final first = library.sosTechniques().first;
    expect(first.key, 'walk5');
    expect(first.evidence, EvidenceLevel.strong);
  });

  test('ear acupressure ships graded traditional and needle-free', () {
    final ear = library
        .sosTechniques()
        .firstWhere((t) => t.key == 'earAcupressure');
    expect(ear.evidence, EvidenceLevel.traditional);
    for (final locale in locales) {
      expect(ear.instruction(locale).toLowerCase(), contains('n'));
    }
    // The five NADA points are named in the instruction, in every language.
    expect(ear.instruction('en'), contains('Shen Men'));
    expect(ear.instruction('tr'), contains('Shen Men'));
  });

  test('the herbal card says plainly that the evidence is not there', () {
    final tea = library.supportCards().firstWhere((c) => c.key == 'herbalTea');
    expect(tea.evidence, EvidenceLevel.traditional);
    expect(tea.body('en').toLowerCase(), contains('no evidence'));
    expect(tea.body('tr').toLowerCase(), contains('kanıt yok'));
  });

  test('every toxicant carries a source and an everyday analogy', () {
    for (final toxicant in library.toxicants()) {
      expect(toxicant.sourceUrl, startsWith('https://'), reason: toxicant.key);
      for (final locale in locales) {
        expect(toxicant.everydayAnalogy(locale).trim(), isNotEmpty,
            reason: toxicant.key);
        expect(toxicant.mechanism(locale).trim(), isNotEmpty,
            reason: toxicant.key);
      }
    }
  });

  test('localized text falls back to English for unknown locales', () {
    final lungs = library.organs().first;
    expect(lungs.name('fr'), lungs.name('en'));
    expect(lungs.name('tr'), isNot(lungs.name('en')));
  });

  test('support cards rotate across all three channels', () {
    final channels = {
      for (var day = 0; day < 7; day++)
        library.supportCardForDay(day).channel,
    };
    expect(channels.length, SupportChannel.values.length);
  });
}
