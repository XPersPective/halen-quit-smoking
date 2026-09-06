import 'package:flutter/material.dart';

import 'package:halen/core/routes.dart';
import 'package:halen/l10n/generated/app_localizations.dart';

/// The app shell: bottom navigation over the four daily-use screens
/// (BUGÜN / Plan / Statistics / SOS) with Settings reachable from the app bar.
/// All other screens are pushed on top.
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  static const _tabCount = 4;

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
        children: List.generate(_tabCount, _placeholderTab),
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
              // 44pt+ touch targets come from NavigationBar defaults.
              tooltip: d.$3,
            ),
        ],
      ),
    );
  }

  Widget _placeholderTab(int index) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (index) {
          0 => l10n.todayTitle,
          1 => l10n.planTitle,
          2 => l10n.statsTitle,
          _ => l10n.sosTitle,
        }),
        actions: [
          IconButton(
            tooltip: l10n.settingsTitle,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: Center(child: Text(l10n.emptyGeneric)),
    );
  }
}
