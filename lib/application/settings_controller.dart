import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities.dart';
import 'settings_screen_controller.dart';

/// Theme selection, persisted in the Settings table. The build watches the
/// settings row so a restored/imported database re-applies its theme too.
class ThemeOptionController extends Notifier<ThemeOption> {
  @override
  ThemeOption build() =>
      ref.watch(settingsProvider).value?.theme ?? ThemeOption.system;

  void set(ThemeOption option) => state = option;
}

final themeOptionProvider =
    NotifierProvider<ThemeOptionController, ThemeOption>(
  ThemeOptionController.new,
);
