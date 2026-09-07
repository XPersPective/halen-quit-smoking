import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_widget/home_widget.dart';

import 'db/app_database.dart';
import 'quick_log_queue.dart';

/// True on platforms with home_widget / notification / purchase support.
/// The dev/preview Windows build runs without these channels.
bool get mobilePlatform => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

/// Home-screen quick logging (report §11/§13/§27).
///
/// - iOS 17+ interactive WidgetKit widget and the iOS 18 control widget call
///   [quickLogCallback] through `registerInteractivityCallback`;
/// - the Android app widget / QS tile send a broadcast to the plugin's
///   background receiver, which runs the same callback in a background
///   isolate;
/// - both write into a shared_preferences queue that the main isolate drains
///   (startup / resume / widget-click) and records with the right source.
///
/// The widget surface renders three strings the app pushes on every change:
/// today's count, today's target and a "last cigarette" summary
/// ("Bugün 4/8 · Son sigara 1s 12dk").
class WidgetService {
  WidgetService(this._db);

  final AppDatabase _db;
  bool _initialized = false;

  static const _appGroup = 'group.com.halenquitsmoking.shared';

  Future<void> init() async {
    if (_initialized || !mobilePlatform) {
      return;
    }
    _initialized = true;
    await HomeWidget.setAppGroupId(_appGroup);
    try {
      await HomeWidget.registerInteractivityCallback(quickLogCallback);
    } catch (_) {
      // Best-effort: unavailable in test/dev environments.
    }
  }

  /// Pushes the current day state to the widget surface.
  Future<void> refresh() async {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final events = await _db.recordDao.getEventsBetween(
      dayStart,
      dayStart.add(const Duration(days: 1)),
    );
    final profile = await _db.profileDao.getSmokingProfile();
    final plan = await _db.planDao.getPlan(_dayKey(now));

    final count = events.length;
    final target = plan?.targetCount ?? profile?.baselineCpd ?? 0;
    final last = events.isEmpty ? null : events.last.ts;
    final lastPart =
        last == null ? '' : ' · ${_durationLabel(now.difference(last))}';

    await _push(
      count: count,
      target: target,
      label: '$count/$target$lastPart',
    );
  }

  String _durationLabel(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h <= 0) {
      return '${d.inMinutes}m';
    }
    return '${h}h ${m}m';
  }

  Future<void> _push({
    required int count,
    required int target,
    required String label,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('todayCount', count);
      await HomeWidget.saveWidgetData<int>('todayTarget', target);
      await HomeWidget.saveWidgetData<String>('todaySummary', label);
      await HomeWidget.updateWidget(
        androidName: 'HalenWidgetProvider',
        iOSName: 'HalenWidget',
      );
    } catch (_) {
      // Platform channel unavailable in tests/dev — ignore.
    }
  }
}

/// Local-day key duplicated from core/dates to keep this file import-flat.
String _dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Notification action button ("logged from the notification", report §13):
/// background handler for the Android action tap / iOS category.
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) {
  if (response.actionId == 'halen_log') {
    // Fire-and-forget: the queue write is small and idempotent.
    quickLogCallback(Uri.parse('halen://quicklog?source=notif'));
  }
}
