import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/motivation.dart';

DayAdherence day(int count, int? target) =>
    DayAdherence(count: count, planTarget: target);

void main() {
  group('computeStreaks', () {
    test('counts consecutive on-plan days', () {
      final streaks = computeStreaks([
        day(8, 8),
        day(7, 8),
        day(8, 8),
      ]);
      expect(streaks.currentDays, 3);
      expect(streaks.longestDays, 3);
      expect(streaks.displayDays, 3);
      expect(streaks.isBroken, isFalse);
    });

    test('keeps the longest run after a break', () {
      final streaks = computeStreaks([
        day(8, 8),
        day(7, 8),
        day(9, 8), // Over plan → break.
        day(8, 8),
      ]);
      expect(streaks.currentDays, 1);
      expect(streaks.longestDays, 2);
    });

    test('broken streak never shows zero — longest is displayed', () {
      final streaks = computeStreaks([
        day(8, 8),
        day(10, 8),
      ]);
      expect(streaks.currentDays, 0);
      expect(streaks.isBroken, isTrue);
      expect(streaks.displayDays, 1);
    });

    test('days without a target count as on-plan', () {
      final streaks = computeStreaks([
        day(12, null),
        day(11, null),
        day(12, null),
      ]);
      expect(streaks.currentDays, 3);
    });
  });
}
