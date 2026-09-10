import 'package:flutter/material.dart';

import '../../../core/routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// Plain-language glossary (module report §16).
///
/// The formulas live one screen over in "How is this calculated?", which is
/// the right depth for someone checking the homework and the wrong depth for
/// someone who just wants to know what a word means. This screen is the
/// shallow half: one sentence per term, no maths, no sources — the report's
/// naming rule ("terms the simplest user can understand") given a home.
class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final entries = <({String term, String meaning})>[
      (term: l10n.progressScoreTitle, meaning: l10n.glossaryProgress),
      (term: l10n.harmLoadTitle, meaning: l10n.glossaryHarm),
      (term: l10n.bodyLoadTitle, meaning: l10n.glossaryBodyLoad),
      (term: l10n.loadCarbonMonoxide, meaning: l10n.glossaryCo),
      (term: l10n.loadTar, meaning: l10n.glossaryTarLoad),
      (term: l10n.cravingWindowTitle, meaning: l10n.glossaryCravingWindow),
      (term: l10n.mindPressureLabel, meaning: l10n.glossaryWithdrawalPressure),
      (term: l10n.glossaryTermSoftTaper, meaning: l10n.glossarySoftTaper),
      (term: l10n.planReportAdherence, meaning: l10n.glossaryAdherence),
      (term: l10n.glossaryTermPackYears, meaning: l10n.glossaryPackYears),
      (term: l10n.evidenceLabel, meaning: l10n.glossaryEvidence),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.glossaryTitle)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(HalenSpace.x6),
          itemCount: entries.length + 2,
          separatorBuilder: (_, _) => const SizedBox(height: HalenSpace.x5),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Text(
                l10n.glossaryIntro,
                style: theme.textTheme.bodyMedium,
              );
            }
            if (index == entries.length + 1) {
              // The deeper half is one tap away for whoever wants it.
              return OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.howCalculated),
                icon: const Icon(Icons.functions_rounded, size: 18),
                label: Text(l10n.commonHowCalculated),
              );
            }
            final entry = entries[index - 1];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.term, style: theme.textTheme.titleSmall),
                const SizedBox(height: HalenSpace.x1),
                Text(entry.meaning, style: theme.textTheme.bodyMedium),
              ],
            );
          },
        ),
      ),
    );
  }
}
