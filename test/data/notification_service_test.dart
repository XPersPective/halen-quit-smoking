import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/notification_service.dart';

void main() {
  group('NotificationService.trialReminderDate', () {
    test('lands at 10:00 on the 5th calendar day', () {
      final start = DateTime(2026, 1, 1, 18, 0);
      final when = NotificationService.trialReminderDate(
        start,
        DateTime(2026, 1, 2),
      );
      expect(when, DateTime(2026, 1, 6, 10, 0));
    });

    test('a late-night trial start still lands at 10:00 of day 5', () {
      final start = DateTime(2026, 1, 1, 23, 30);
      final when = NotificationService.trialReminderDate(
        start,
        DateTime(2026, 1, 2),
      );
      expect(when, DateTime(2026, 1, 6, 10, 0));
    });

    test('null once the moment has passed, valid one second before', () {
      final start = DateTime(2026, 1, 1);
      expect(
        NotificationService.trialReminderDate(start, DateTime(2026, 1, 6, 10)),
        isNull,
      );
      expect(
        NotificationService.trialReminderDate(
          start,
          DateTime(2026, 1, 6, 9, 59, 59),
        ),
        DateTime(2026, 1, 6, 10),
      );
    });
  });
}
