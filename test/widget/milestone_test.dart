import 'package:flutter_test/flutter_test.dart';
import 'package:halen/presentation/widgets/milestone_celebration.dart';

void main() {
  group('milestone crossings', () {
    test('fires only on the crossing, never on a day already past', () {
      expect(Milestone.crossed(before: 0, after: 1), Milestone.day1);
      expect(Milestone.crossed(before: 1, after: 1), isNull);
      expect(Milestone.crossed(before: 1, after: 2), isNull);
      expect(Milestone.crossed(before: 2, after: 3), Milestone.day3);
    });

    test('several crossed at once yields the largest, not a queue', () {
      // The app was closed for a fortnight: one moment, not four.
      expect(Milestone.crossed(before: 0, after: 14), Milestone.week1);
      expect(Milestone.crossed(before: 0, after: 90), Milestone.month1);
    });

    test('days smoke free counts whole days and never goes negative', () {
      expect(daysSmokeFree(const Duration(hours: 23)), 0);
      expect(daysSmokeFree(const Duration(hours: 25)), 1);
      expect(daysSmokeFree(const Duration(days: 7, hours: 5)), 7);
      expect(daysSmokeFree(const Duration(hours: -10)), 0);
    });

    test('the ladder is ordered and has no duplicates', () {
      final days = Milestone.values.map((m) => m.days).toList();
      expect(days, orderedEquals([...days]..sort()));
      expect(days.toSet(), hasLength(days.length));
    });
  });
}
