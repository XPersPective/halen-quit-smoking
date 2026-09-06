import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/settings_controller.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'domain/entities.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/screens/shell_screen.dart';

class HalenApp extends ConsumerWidget {
  const HalenApp({super.key, this.databaseFailed = false});

  final bool databaseFailed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOption = ref.watch(themeOptionProvider);
    return MaterialApp(
      title: 'Halen',
      theme: HalenTheme.light(),
      darkTheme: HalenTheme.dark(),
      themeMode: switch (themeOption) {
        ThemeOption.system => ThemeMode.system,
        ThemeOption.light => ThemeMode.light,
        ThemeOption.dark => ThemeMode.dark,
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (_) => const ShellScreen(),
      },
    );
  }
}
