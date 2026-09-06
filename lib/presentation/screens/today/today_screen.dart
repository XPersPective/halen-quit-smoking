import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';

/// Screen 9: BUGÜN — the main daily screen. Full build lands in phase 6;
/// until then it shows the honest first-day state.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.todayTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.todayEmptyFirstDay,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
