import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/health_timeline.dart';

void main() {
  group('health timeline milestone arithmetic', () {
    test('quit day shows the first milestones as current', () {
      // Both 20-min and 12-hour windows start at day 0; the "in progress"
      // one is the later of the two.
      expect(currentMilestone(0), HealthMilestone.twelveHours);
      expect(nextMilestone(0), HealthMilestone.twoToTwelveWeeks);
    });

    test('12-hour and week boundaries', () {
      expect(currentMilestone(13), HealthMilestone.twelveHours);
      expect(currentMilestone(14), HealthMilestone.twoToTwelveWeeks);
      expect(currentMilestone(29), HealthMilestone.twoToTwelveWeeks);
      expect(currentMilestone(30), HealthMilestone.oneToNineMonths);
    });

    test('year boundaries up to 15 years', () {
      expect(currentMilestone(365), HealthMilestone.oneYear);
      expect(currentMilestone(5 * 365), HealthMilestone.strokeFiveTo15Years);
      expect(currentMilestone(10 * 365), HealthMilestone.tenYears);
      expect(currentMilestone(15 * 365), HealthMilestone.fifteenYears);
      expect(currentMilestone(20 * 365), HealthMilestone.fifteenYears);
      expect(nextMilestone(20 * 365), HealthMilestone.fifteenYears);
    });

    test('preview is locked until a quit date exists (reduction mode)', () {
      expect(timelinePreviewLocked(quitDate: null), isTrue);
      expect(
        timelinePreviewLocked(quitDate: DateTime(2026, 9, 1)),
        isFalse,
      );
    });

    test('days since quit never negative', () {
      expect(
        daysSinceQuit(DateTime(2026, 9, 7), DateTime(2026, 9, 1)),
        0,
      );
      expect(
        daysSinceQuit(DateTime(2026, 9, 1), DateTime(2026, 9, 7)),
        6,
      );
    });
  });
}
