import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:halen/application/settings_screen_controller.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/data/notification_service.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/settings/settings_screen.dart';
import 'package:halen/presentation/widgets/notification_permission_card.dart';
import 'package:drift/drift.dart' show Value;

import '../helpers/pump_app.dart';

class _FakeNotifications extends NotificationService {
  _FakeNotifications({this.granted = false});

  bool granted;
  var asked = 0;
  var openedSettings = 0;
  var trialScheduled = 0;
  var trialCancelled = 0;

  @override
  Future<bool> isPermissionGranted() async => granted;

  @override
  Future<bool> requestPermission() async {
    asked++;
    return granted;
  }

  @override
  Future<void> openSystemSettings() async {
    openedSettings++;
  }

  @override
  Future<void> scheduleTrialReminder({
    required DateTime trialStartedAt,
    required NotificationTexts texts,
  }) async {
    trialScheduled++;
  }

  @override
  Future<void> cancelTrialReminder() async {
    trialCancelled++;
  }
}

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await seedOnboardedProfile();
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('granted permission shows an honest confirmation', (
    tester,
  ) async {
    final service = _FakeNotifications(granted: true);
    await pumpModuleWidget(
      tester,
      db: db,
      child: const NotificationPermissionCard(),
      extraOverrides: [
        notificationServiceProvider.overrideWithValue(service),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text('Notifications are on'), findsOneWidget);
    expect(find.text('Open system settings'), findsNothing);
    expect(service.asked, 0);
    await disposeApp(tester);
  });

  testWidgets('denied permission offers the ask and the settings shortcut', (
    tester,
  ) async {
    final service = _FakeNotifications();
    await pumpModuleWidget(
      tester,
      db: db,
      child: const NotificationPermissionCard(),
      extraOverrides: [
        notificationServiceProvider.overrideWithValue(service),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text('Notifications are on'), findsNothing);

    final allow = find.widgetWithText(FilledButton, 'Allow notifications');
    await tester.tap(allow);
    await tester.pump();
    expect(service.asked, 1);
    // Still denied (user said no in the dialog) — nothing else changes.
    expect(find.text('Notifications are on'), findsNothing);

    final openSettings = find.widgetWithText(
      TextButton,
      'Open system settings',
    );
    await tester.tap(openSettings);
    await tester.pump();
    expect(service.openedSettings, 1);
    await disposeApp(tester);
  });

  testWidgets('ask followed by grant flips the card to confirmed', (
    tester,
  ) async {
    final service = _FakeNotifications();
    await pumpModuleWidget(
      tester,
      db: db,
      child: const NotificationPermissionCard(),
      extraOverrides: [
        notificationServiceProvider.overrideWithValue(service),
      ],
    );
    await tester.pumpAndSettle();
    service.granted = true;
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Notifications are on'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('trial nudge switch stores its own preference and schedules', (
    tester,
  ) async {
    await db.settingsDao.updateSettings(
      SettingsCompanion(trialStartedAt: Value(DateTime(2026, 9, 1))),
    );
    final service = _FakeNotifications();
    await pumpModuleWidget(
      tester,
      db: db,
      child: const SettingsScreen(),
      scrollable: false,
      extraOverrides: [
        notificationServiceProvider.overrideWithValue(service),
      ],
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(SettingsScreen)),
    )!;
    final tile = find.widgetWithText(SwitchListTile, l10n.notifTrialNudge);
    expect(tile, findsOneWidget);
    expect((db.settingsDao.getSettings()).then((s) => s.trialNudge), completion(isFalse));

    await tester.tap(find.descendant(of: tile, matching: find.byType(Switch)));
    await tester.pumpAndSettle();
    expect(
      (await db.settingsDao.getSettings()).trialNudge,
      isTrue,
      reason: 'the preference is the user’s own, not implied by anything',
    );
    expect(service.trialScheduled, 1);

    await tester.tap(find.descendant(of: tile, matching: find.byType(Switch)));
    await tester.pumpAndSettle();
    expect((await db.settingsDao.getSettings()).trialNudge, isFalse);
    expect(service.trialCancelled, 1);
    await disposeApp(tester);
  });
}
