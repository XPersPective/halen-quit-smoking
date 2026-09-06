import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';

/// Screen 12: Statistics — charts and trigger patterns (built in phase 6).
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle)),
      body: Center(child: Text(l10n.emptyNoRecords)),
    );
  }
}
