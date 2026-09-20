import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers.dart';
import 'application/plan_controller.dart';
import 'application/quick_log_controller.dart';
import 'application/settings_controller.dart';
import 'application/settings_screen_controller.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'domain/entities.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/screens/articles/article_reader_screen.dart';
import 'presentation/screens/articles/articles_screen.dart';
import 'presentation/screens/articles/sources_screen.dart';
import 'presentation/screens/about/about_screen.dart';
import 'presentation/screens/body/body_screen.dart';
import 'presentation/screens/cessation/medicines_screen.dart';
import 'presentation/screens/cessation/quit_day_screen.dart';
import 'presentation/screens/cessation/quit_plan_screen.dart';
import 'presentation/screens/economy/economy_screen.dart';
import 'presentation/screens/onboarding/onboarding_result_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/paywall/paywall_screen.dart';
import 'presentation/screens/plan/plan_switch_screen.dart';
import 'presentation/screens/settings/settings_screen.dart';
import 'presentation/screens/shell_screen.dart';
import 'presentation/screens/sos/breathing_screen.dart';
import 'presentation/screens/sos/ear_acupressure_screen.dart';
import 'presentation/screens/sos/nutrition_guide_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/startup_failure_screen.dart';
import 'presentation/screens/status/status_flow_screen.dart';
import 'presentation/screens/timeline/health_timeline_screen.dart';
import 'presentation/screens/today/record_detail_screen.dart';
import 'presentation/screens/transparency/glossary_screen.dart';
import 'presentation/screens/transparency/how_calculated_screen.dart';
import 'presentation/screens/under18_screen.dart';
import 'presentation/widgets/design/body_clock.dart';

class HalenApp extends ConsumerWidget {
  const HalenApp({super.key, this.startupError});

  /// Non-null when the database could not be opened at launch. The app then
  /// shows [StartupFailureScreen] and nothing else — every other screen
  /// reads the database, so routing into them is what killed the app before
  /// its first frame.
  final Object? startupError;

  bool get databaseFailed => startupError != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeOption = databaseFailed
        ? ThemeOption.system
        : ref.watch(themeOptionProvider);
    final localeOverride = databaseFailed ? null : ref.watch(storedLocaleProvider);
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
      // Null = follow the system language; otherwise the user's explicit
      // Settings choice.
      locale: localeOverride == null ? null : Locale(localeOverride),
      localeResolutionCallback: (deviceLocale, supported) {
        // Flutter's default resolution falls back to supportedLocales.first —
        // German, because gen-l10n sorts alphabetically. An unsupported
        // system language (e.g. French) must land on English, the template
        // language, instead.
        if (deviceLocale != null) {
          for (final supportedLocale in supported) {
            if (supportedLocale.languageCode == deviceLocale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return const Locale('en');
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: databaseFailed
          ? StartupFailureScreen(
              error: startupError,
              // A cold restart is the only honest retry: the database is
              // opened before the app exists, so there is nothing here that
              // could reopen it in place.
              onRetry: () => SystemNavigator.pop(),
            )
          : null,
      initialRoute: databaseFailed ? null : Routes.splash,
      routes: databaseFailed ? const {} : {
        Routes.splash: (_) => const SplashScreen(),
        Routes.onboarding: (_) => const OnboardingScreen(),
        Routes.onboardingResult: (_) => const OnboardingResultScreen(),
        Routes.under18: (_) => const Under18Screen(),
        Routes.today: (_) => const ShellScreen(),
        Routes.settings: (_) => const SettingsScreen(),
        Routes.about: (_) => const AboutScreen(),
        Routes.paywall: (_) => const PaywallScreen(),
        Routes.articles: (_) => const ArticlesScreen(),
        Routes.economy: (_) => const EconomyScreen(),
        Routes.planSwitch: (_) => const PlanSwitchScreen(),
        Routes.sources: (_) => const SourcesScreen(),
        Routes.earAcupressure: (_) => const EarAcupressureScreen(),
        Routes.glossary: (_) => const GlossaryScreen(),
        Routes.nutritionGuide: (_) => const NutritionGuideScreen(),
        Routes.quitPlan: (_) => const QuitPlanScreen(),
        Routes.medicines: (_) => const MedicinesScreen(),
        Routes.quitDay: (_) => const QuitDayScreen(),
        Routes.status: (_) => const StatusFlowScreen(),
      },
      // One clock above every route: everything that breathes on screen —
      // the lung, the body map, an organ glyph — derives its phase from the
      // same time value, so two living elements on one screen read as one
      // body rather than as two animations (premium brief §B.8).
      builder: (context, child) => BodyClock(child: child ?? const SizedBox()),
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
        if (settings.name == Routes.body) {
          final organKey = settings.arguments as String?;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => BodyScreen(initialOrganKey: organKey),
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
