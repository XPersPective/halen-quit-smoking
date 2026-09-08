import 'package:flutter/material.dart';

import 'package:halen/core/routes.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/articles/articles_screen.dart';
import 'package:halen/presentation/screens/plan/plan_screen.dart';
import 'package:halen/presentation/screens/sos/sos_screen.dart';
import 'package:halen/presentation/screens/stats/stats_screen.dart';
import 'package:halen/presentation/screens/today/today_screen.dart';

/// The app shell: bottom navigation over the five core surfaces
/// (BUGÜN / Grafikler / Plan / Rehber / Kriz SOS).
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = [
      (Icons.today_outlined, Icons.today_rounded, l10n.navToday),
      (Icons.insights_outlined, Icons.insights_rounded, l10n.navStats),
      (Icons.track_changes_outlined, Icons.track_changes_rounded, l10n.navPlan),
      (Icons.menu_book_outlined, Icons.menu_book_rounded, l10n.navArticles),
      (Icons.healing_outlined, Icons.healing_rounded, l10n.navSos),
    ];

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: IndexedStack(
            index: _index,
            children: const [
              TodayScreen(),
              StatsScreen(),
              PlanScreen(),
              ArticlesScreen(),
              SosScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.$1),
              selectedIcon: Icon(d.$2),
              label: d.$3,
              tooltip: d.$3,
            ),
        ],
      ),
    );
  }
}

/// Settings entry used from each tab's app bar.
class ShellSettingsButton extends StatelessWidget {
  const ShellSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: l10n.settingsTitle,
      icon: const Icon(Icons.settings_outlined),
      onPressed: () => Navigator.pushNamed(context, Routes.settings),
    );
  }
}
