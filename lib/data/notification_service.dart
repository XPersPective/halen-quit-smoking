import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/entities.dart';
import '../domain/notification_plan.dart';

/// Localized strings bundle resolved by the caller (UI has BuildContext;
/// the service stays presentation-free).
class NotificationTexts {
  const NotificationTexts({
    required this.summaryTitle,
    required this.summaryBody,
    required this.morningTitle,
    required this.morningBody,
    required this.returnTitle,
    required this.returnBody,
    required this.quitTitle,
    required this.quitBody,
    required this.milestoneTitle,
    required this.milestoneBody,
  });

  final String summaryTitle;
  final String summaryBody;
  final String morningTitle;
  final String morningBody;
  final String returnTitle;
  final String returnBody;
  final String quitTitle;
  final String quitBody;
  final String milestoneTitle;
  final String milestoneBody;
}

/// Local notification scheduling (report §20).
///
/// Rules baked in here:
///  - "planned time approaching" defaults OFF (spam risk);
///  - daily summary (evening) and morning goal default ON;
///  - exact alarms are a user opt-in — default scheduling is inexact
///    (USE_EXACT_ALARM is deliberately NOT declared, Play rejects it);
///  - density: calm/standard/intense + a full off switch;
///  - Android 13+ runtime permission requested from the splash rationale;
///    iOS requests provisional (time deliverable without alert perm);
///  - reboot rescheduling is handled by the plugin's boot receiver
///    (RECEIVE_BOOT_COMPLETED in the manifest).
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool _exactEnabled = false;

  static const _remindersChannel = 'halen_reminders';
  static const _supportChannel = 'halen_support';

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    tzdata.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      // Provisional: quiet delivery; the user upgrades permission in time.
      requestProvisionalPermission: true,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  /// Runtime permission (Android 13+ POST_NOTIFICATIONS / iOS alert).
  /// Returns whether notifications are allowed.
  Future<bool> requestPermission() async {
    await init();
    final android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  /// User opt-in for exact-time reminders (Android: Settings deep link via
  /// the plugin; iOS: time-sensitive entitlement is a no-op here).
  Future<void> setExactTimeEnabled(bool enabled) async {
    await init();
    _exactEnabled = enabled;
    if (!enabled) {
      return;
    }
    final android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final canExact = await android.canScheduleExactNotifications();
      if (canExact != true) {
        await android.requestExactAlarmsPermission();
      }
    }
  }

  AndroidScheduleMode get _scheduleMode => _exactEnabled
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle;

  /// Applies a density level: cancels everything, then schedules the types
  /// the level implies (report §20 defaults).
  Future<void> applyDensity(
    NotificationDensity density, {
    required NotificationTexts texts,
  }) async {
    await init();
    await _plugin.cancelAll();
    if (density == NotificationDensity.off) {
      return;
    }

    // Which types this density level implies (pure decision in domain).
    final plan = DensityPlan.forDensity(density);

    // (2) Daily summary — evening, default ON.
    if (plan.dailySummary) {
      await _scheduleDaily(
        id: _dailySummaryId,
        hour: 20,
        minute: 0,
        channel: _remindersChannel,
        title: texts.summaryTitle,
        body: texts.summaryBody,
      );
    }

    // (3) Morning goal — default ON (calm keeps only the summary).
    if (plan.morningGoal) {
      await _scheduleDaily(
        id: _morningGoalId,
        hour: 9,
        minute: 0,
        channel: _remindersChannel,
        title: texts.morningTitle,
        body: texts.morningBody,
      );
    }

    // Intense adds the gentle-return nudge every day at noon.
    if (plan.gentleReturn) {
      await _scheduleDaily(
        id: _returnNudgeId,
        hour: 12,
        minute: 30,
        channel: _supportChannel,
        title: texts.returnTitle,
        body: texts.returnBody,
      );
    }
  }

  static const _dailySummaryId = 1;
  static const _morningGoalId = 2;
  static const _returnNudgeId = 3;
  static const _quitSupportBaseId = 10;

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String channel,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!when.isAfter(now)) {
      when = when.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details(channel),
      androidScheduleMode: _scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily',
    );
  }

  NotificationDetails _details(String channel) => NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channel,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          styleInformation: const BigTextStyleInformation(''),
        ),
        iOS: const DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.active,
        ),
      );

  /// (6) Gentle return: scheduled +3 days out, rescheduled on every record.
  Future<void> scheduleGentleReturn({required NotificationTexts texts}) async {
    await init();
    await _plugin.cancel(id: _returnNudgeId);
    final when =
        tz.TZDateTime.now(tz.local).add(const Duration(days: 3));
    await _plugin.zonedSchedule(
      id: _returnNudgeId,
      title: texts.returnTitle,
      body: texts.returnBody,
      scheduledDate: when,
      notificationDetails: _details(_supportChannel),
      androidScheduleMode: _scheduleMode,
      payload: 'return',
    );
  }

  /// (4) First-72-hours support burst after the quit day (report §20).
  Future<void> scheduleQuitSupport({required NotificationTexts texts}) async {
    await init();
    final base = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < 3; i++) {
      await _plugin.zonedSchedule(
        id: _quitSupportBaseId + i,
        title: texts.quitTitle,
        body: texts.quitBody,
        scheduledDate: base.add(Duration(hours: 24 * (i + 1))),
        notificationDetails: _details(_supportChannel),
        androidScheduleMode: _scheduleMode,
        payload: 'quit_support',
      );
    }
  }

  /// (5) Milestone notification (event-based, on quit-day milestones).
  Future<void> showMilestoneNow({required NotificationTexts texts}) async {
    await init();
    await _plugin.show(
      id: _quitSupportBaseId + 9,
      title: texts.milestoneTitle,
      body: texts.milestoneBody,
      notificationDetails: _details(_supportChannel),
      payload: 'milestone',
    );
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Test/debug visibility.
  @visibleForTesting
  bool get isInitialized => _initialized;
}
