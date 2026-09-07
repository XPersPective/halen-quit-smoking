import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';

/// Screen: "Bu tahmin nasıl hesaplandı?" (report §6/§18).
///
/// The honesty layer: every S3 estimate links here from its "?" button and
/// explains the model, the assumption, the limitations and the sources.
/// No absolute values, no measurement claims.
class HowCalculatedScreen extends StatelessWidget {
  const HowCalculatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.howTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _Section(
              title: l10n.howNicotineTitle,
              body: l10n.howNicotineBody,
              limits: l10n.howNicotineLimits,
              sources: l10n.howNicotineSources,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _Section(
              title: l10n.howWeeksTitle,
              body: l10n.howWeeksBody,
              theme: theme,
            ),
            const SizedBox(height: 16),
            _Section(
              title: l10n.howSavingsTitle,
              body: l10n.howSavingsBody,
              theme: theme,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.commonModelTag,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
    required this.theme,
    this.limits,
    this.sources,
  });

  final String title;
  final String body;
  final ThemeData theme;
  final String? limits;
  final String? sources;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body),
            if (limits != null) ...[
              const SizedBox(height: 8),
              Text(limits!, style: theme.textTheme.bodySmall),
            ],
            if (sources != null) ...[
              const SizedBox(height: 8),
              Text(sources!, style: theme.textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
