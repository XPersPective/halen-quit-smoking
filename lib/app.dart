import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers.dart';
import 'application/plan_controller.dart';
import 'application/quick_log_controller.dart';
import 'application/settings_controller.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'domain/entities.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/screens/articles/article_reader_screen.dart';
import 'presentation/screens/articles/articles_screen.dart';
import 'presentation/screens/articles/sources_screen.dart';
import 'presentation/screens/body/body_screen.dart';
import 'presentation/screens/economy/economy_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/paywall/paywall_screen.dart';
import 'presentation/screens/plan/plan_switch_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/shell_screen.dart';
import 'presentation/screens/sos/breathing_screen.dart';
import 'presentation/screens/sos/ear_acupressure_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/timeline/health_timeline_screen.dart';
import 'presentation/screens/today/record_detail_screen.dart';
import 'presentation/screens/transparency/glossary_screen.dart';
import 'presentation/screens/transparency/how_calculated_screen.dart';
import 'presentation/screens/under18_screen.dart';

class HalenApp extends ConsumerWidget {
  const HalenApp({super.key, this.databaseFailed = false});

  final bool databaseFailed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOption = ref.watch(themeOptionProvider);
    return _LifecycleTracker(
      databaseFailed: databaseFailed,
      child: MaterialApp(
      title: 'Halen',
      debugShowCheckedModeBanner: false,
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
        Routes.settings: (_) => const SettingsScreen(),
        Routes.paywall: (_) => const PaywallScreen(),
        Routes.articles: (_) => const ArticlesScreen(),
        Routes.body: (_) => const BodyScreen(),
        Routes.economy: (_) => const EconomyScreen(),
        Routes.planSwitch: (_) => const PlanSwitchScreen(),
        Routes.sources: (_) => const SourcesScreen(),
        Routes.earAcupressure: (_) => const EarAcupressureScreen(),
        Routes.glossary: (_) => const GlossaryScreen(),
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
        if (settings.name == Routes.breathing) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const BreathingScreen(),
          );
        }
        if (settings.name == Routes.articleReader) {
          final articleId = settings.arguments! as String;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ArticleReaderScreen(articleId: articleId),
          );
        }
        return null;
      },
    ),
    );
  }
}

/// Watches app lifecycle: on every resume the quick-log queue (widget /
/// QS tile / control widget / notification taps) is drained into the
/// database and the widget surface is refreshed (report §13).
class _LifecycleTracker extends ConsumerStatefulWidget {
  const _LifecycleTracker({required this.child, this.databaseFailed = false});

  final Widget child;
  final bool databaseFailed;

  @override
  ConsumerState<_LifecycleTracker> createState() => _LifecycleTrackerState();
}

class _LifecycleTrackerState extends ConsumerState<_LifecycleTracker>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || widget.databaseFailed) {
      return;
    }
    final db = ref.read(databaseProvider);
    QuickLogController(db).drain().then((count) {
      if (count > 0) {
        ref.invalidate(todayStateProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
