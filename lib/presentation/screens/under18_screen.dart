import 'package:flutter/material.dart';

import 'package:halen/core/routes.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import '../../core/design/tokens.dart';

/// Under-18 destination (report §39): no plan is created; youth-appropriate
/// support and quitline resources are shown instead.
class Under18Screen extends StatelessWidget {
  const Under18Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.under18YouthTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(HalenSpace.x6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(HalenSpace.x4),
                  child: Text(l10n.under18YouthBody),
                ),
              ),
              const SizedBox(height: HalenSpace.x4),
              Text(l10n.obUnder18Notice, style: theme.textTheme.bodyMedium),
              const Spacer(),
              Text(l10n.settingsHelplines, style: theme.textTheme.bodySmall),
              const SizedBox(height: HalenSpace.x4),
              FilledButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.today),
                child: Text(l10n.commonDone),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
