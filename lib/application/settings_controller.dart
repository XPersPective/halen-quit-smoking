import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities.dart';

/// Theme selection controller. In the data phase this becomes backed by the
/// persistent Settings table; the public provider surface stays the same.
class ThemeOptionController extends Notifier<ThemeOption> {
  @override
  ThemeOption build() => ThemeOption.system;

  void set(ThemeOption option) => state = option;
}

final themeOptionProvider =
    NotifierProvider<ThemeOptionController, ThemeOption>(
  ThemeOptionController.new,
);
