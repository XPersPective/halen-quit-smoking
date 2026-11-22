import 'package:flutter_test/flutter_test.dart';
import 'package:halen/data/notification_service.dart';

void main() {
  group('NotificationService.trialReminderDate', () {
    test('lands 12 hours after the start', () {
      final start = DateTime(2026, 1, 1, 18, 0);
      final when = NotificationService.trialReminderDate(
        start,
        DateTime(2026, 1, 2),
      );
      expect(when, DateTime(2026, 1, 2, 6));
    });

    test('a late-night start moves the reminder to the following morning', () {
      final start = DateTime(2026, 1, 1, 23, 30);
      final when = NotificationService.trialReminderDate(
        start,
        DateTime(2026, 1, 2),
      );
      expect(when, DateTime(2026, 1, 2, 11, 30));
    });

    test('null once the moment has passed, valid one second before', () {
      final start = DateTime(2026, 1, 1);
      expect(
        NotificationService.trialReminderDate(start, DateTime(2026, 1, 1, 12)),
        isNull,
      );
      expect(
        NotificationService.trialReminderDate(
          start,
          DateTime(2026, 1, 1, 11, 59, 59),
        ),
        DateTime(2026, 1, 1, 12),
      );
    });
  });
}
