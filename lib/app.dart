import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/settings_controller.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'domain/entities.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/shell_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/timeline/health_timeline_screen.dart';
import 'presentation/screens/today/record_detail_screen.dart';
import 'presentation/screens/transparency/how_calculated_screen.dart';
import 'presentation/screens/under18_screen.dart';

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
        Routes.splash: (_) => const SplashScreen(),
        Routes.onboarding: (_) => const OnboardingScreen(),
        Routes.under18: (_) => const Under18Screen(),
        Routes.today: (_) => const ShellScreen(),
      },
      onGenerateRoute: (settings) {
        // Record detail takes the just-logged event id as an argument.
        if (settings.name == Routes.recordDetail) {
          final eventId = settings.arguments! as int;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => RecordDetailScreen(eventId: eventId),
          );
        }
        if (settings.name == Routes.howCalculated) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const HowCalculatedScreen(),
          );
        }
        if (settings.name == Routes.healthTimeline) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const HealthTimelineScreen(),
          );
        }
        return null;
      },
    );
  }
}
