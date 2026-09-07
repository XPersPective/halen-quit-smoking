import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/notification_service.dart';
import 'providers.dart';

/// Reactive settings row (theme, reduce motion, haptics, notification
/// density, trial start).
final settingsProvider = StreamProvider<SettingsRow>((ref) {
  return ref.watch(databaseProvider).settingsDao.watchSettings();
});

/// Single app-scoped notification service.
final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

/// Persists appearance/notification switches.
Future<void> updateSetting(WidgetRef ref, SettingsCompanion companion) async {
  await ref.read(databaseProvider).settingsDao.updateSettings(companion);
}
