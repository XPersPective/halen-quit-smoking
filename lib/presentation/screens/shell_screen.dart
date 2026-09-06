import 'package:flutter/material.dart';

import 'package:halen/core/routes.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/plan/plan_screen.dart';
import 'package:halen/presentation/screens/sos/sos_screen.dart';
import 'package:halen/presentation/screens/stats/stats_screen.dart';
import 'package:halen/presentation/screens/today/today_screen.dart';

/// The app shell: bottom navigation over the four daily-use screens
/// (BUGÜN / Plan / Statistics / SOS) with Settings reachable from the app bar.
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
      (Icons.today_outlined, Icons.today, l10n.todayTitle),
      (Icons.route_outlined, Icons.route, l10n.planTitle),
      (Icons.insights_outlined, Icons.insights, l10n.statsTitle),
      (Icons.waves_outlined, Icons.waves, l10n.sosTitle),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          TodayScreen(),
          PlanScreen(),
          StatsScreen(),
          SosScreen(),
        ],
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

/// Settings entry used from each tab's app bar until phase 13 polishes the
/// shared shell chrome.
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
