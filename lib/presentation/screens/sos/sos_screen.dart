import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';

/// Screen 13: Craving SOS (built in phase 8).
class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sosTitle)),
      body: Center(child: Text(l10n.sosIntro)),
    );
  }
}
