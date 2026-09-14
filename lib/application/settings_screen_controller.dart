import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/notification_service.dart';
import 'providers.dart';

/// Reactive settings row (theme, reduce motion, haptics, notification
/// density, trial start).
final settingsProvider = StreamProvider<SettingsRow>((ref) {
  return ref.watch(databaseProvider).settingsDao.watchSettings();
});

/// Language codes the app ships translations for.
const supportedLanguageCodes = ['en', 'tr', 'de'];

/// Stored UI language ('en'/'tr'/'de'); null = follow the system language.
final storedLocaleProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider).value?.appLocale;
});

/// The locale the app presents: the explicit choice when set, otherwise the
/// system language when translated, otherwise English (the template
/// language). Out-of-context consumers — the article feed, scheduled
/// notification texts — read this so they always agree with what is on
/// screen.
final resolvedLocaleProvider = Provider<String>((ref) {
  final stored = ref.watch(storedLocaleProvider);
  if (stored != null && supportedLanguageCodes.contains(stored)) {
    return stored;
  }
  final system = PlatformDispatcher.instance.locale.languageCode;
  return supportedLanguageCodes.contains(system) ? system : 'en';
});

/// Single app-scoped notification service.
final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

/// Persists appearance/notification switches.
Future<void> updateSetting(WidgetRef ref, SettingsCompanion companion) async {
  await ref.read(databaseProvider).settingsDao.updateSettings(companion);
}
