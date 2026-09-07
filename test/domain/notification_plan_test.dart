import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/notification_plan.dart';

void main() {
  test('density → type mapping follows report §20 defaults', () {
    final off = DensityPlan.forDensity(NotificationDensity.off);
    expect(off.dailySummary, isFalse);
    expect(off.morningGoal, isFalse);
    expect(off.gentleReturn, isFalse);

    final calm = DensityPlan.forDensity(NotificationDensity.calm);
    expect(calm.dailySummary, isTrue);
    expect(calm.morningGoal, isFalse);
    expect(calm.gentleReturn, isFalse);

    final standard = DensityPlan.forDensity(NotificationDensity.standard);
    expect(standard.dailySummary, isTrue);
    expect(standard.morningGoal, isTrue);
    expect(standard.gentleReturn, isFalse);

    final intense = DensityPlan.forDensity(NotificationDensity.intense);
    expect(intense.dailySummary, isTrue);
    expect(intense.morningGoal, isTrue);
    expect(intense.gentleReturn, isTrue);
  });

  test('plan-time reminder is never scheduled at any density', () {
    for (final density in NotificationDensity.values) {
      expect(DensityPlan.forDensity(density).planReminder, isFalse);
    }
  });
}
