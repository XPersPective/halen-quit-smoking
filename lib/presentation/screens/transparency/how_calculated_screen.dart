import 'package:flutter/material.dart';

import 'package:halen/l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

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
          padding: const EdgeInsets.all(HalenSpace.x6),
          children: [
            _Section(
              title: l10n.howNicotineTitle,
              body: l10n.howNicotineBody,
              limits: l10n.howNicotineLimits,
              sources: l10n.howNicotineSources,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howWeeksTitle,
              body: l10n.howWeeksBody,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howSavingsTitle,
              body: l10n.howSavingsBody,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            // Module report §0.2 — publishing every formula is the product's
            // main differentiator, not a legal footnote. Each section below
            // states the exact weights the code uses.
            _Section(
              title: l10n.howBodyLoadTitle,
              body: l10n.howBodyLoadBody,
              limits: l10n.howBodyLoadLimits,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howCravingTitle,
              body: l10n.howCravingBody,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howMindTitle,
              body: l10n.howMindBody,
              limits: l10n.mindOnlyYouKnow,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howLungTitle,
              body: l10n.howLungBody,
              limits: l10n.lungsNotAScan,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howProgressTitle,
              body: l10n.howProgressBody,
              limits: l10n.progressBehaviourNote,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x4),
            _Section(
              title: l10n.howHarmTitle,
              body: l10n.howHarmBody,
              limits: l10n.harmNotRisk,
              theme: theme,
            ),
            const SizedBox(height: HalenSpace.x6),
            Text(
              l10n.commonModelTag,
              style: theme.textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HalenSpace.x6),
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
        padding: const EdgeInsets.all(HalenSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: HalenSpace.x2),
            Text(body),
            if (limits != null) ...[
              const SizedBox(height: HalenSpace.x2),
              Text(limits!, style: theme.textTheme.bodySmall),
            ],
            if (sources != null) ...[
              const SizedBox(height: HalenSpace.x2),
              Text(sources!, style: theme.textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
