import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';

/// Screen 11: Plan — hosts the adaptive taper engine UI (built in phase 5).
class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.planTitle)),
      body: Center(child: Text(l10n.emptyGeneric)),
    );
  }
}
