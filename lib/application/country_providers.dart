import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../domain/countries.dart';
import 'providers.dart';
import 'settings_screen_controller.dart';

/// Country names, currencies and codes (assets/data/countries.json).
final countryDirectoryProvider = FutureProvider<CountryDirectory>((ref) async {
  final source = await rootBundle.loadString('assets/data/countries.json');
  return CountryDirectory.fromJson(source);
});

/// The country the user chose; null until they do. Never defaulted: a guess
/// would put a Turkish phone number in front of a German user.
final countryCodeProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider).value?.countryCode;
});

/// The device's region, offered as a one-tap suggestion (never applied
/// silently). Null when the phone reports none or it is not a real country.
final detectedCountryProvider = Provider<String?>((ref) {
  final directory = ref.watch(countryDirectoryProvider).value;
  final region =
      WidgetsBinding.instance.platformDispatcher.locale.countryCode;
  if (directory == null || region == null || !directory.contains(region)) {
    return null;
  }
  return region.toUpperCase();
});

/// ISO 4217 currency of the chosen country (null until chosen).
final currencyCodeProvider = Provider<String?>((ref) {
  final directory = ref.watch(countryDirectoryProvider).value;
  return directory?.currencyOf(ref.watch(countryCodeProvider));
});

/// Persists the user's country (or clears it).
final setCountryProvider = Provider<Future<void> Function(String?)>((ref) {
  return (code) async {
    await ref.read(databaseProvider).settingsDao.updateSettings(
          SettingsCompanion(countryCode: Value(code)),
        );
  };
});
