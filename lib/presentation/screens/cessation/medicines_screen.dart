import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../data/repositories/medicine_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';
import '../../widgets/entrance.dart';

/// Stop-smoking medicines (premium brief §C.1).
///
/// This screen closes the largest single gap in the product. Nicotine
/// replacement raises the quit rate by about half again; varenicline more
/// than doubles it. The app had never mentioned any of it, which meant the
/// most effective help available to its users was the one thing it withheld.
///
/// What this screen is not: a shop, a prescriber, or a dose chart. Every
/// entry names how it works, how it is used, the mistake that most often
/// wastes it, and its published effect size *with its comparator*. Then it
/// stops, and points at a pharmacist or a doctor.
class MedicinesScreen extends ConsumerWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final repo = ref.watch(medicineRepositoryProvider);
    final suggestsCombination = ref.watch(suggestsCombinationProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicinesTitle)),
      body: ListView(
        padding: HalenSpace.screen,
        children: [
          Text(l10n.medicinesLead, style: theme.textTheme.bodyLarge),
          const SizedBox(height: HalenSpace.x5),

          if (suggestsCombination) ...[
            Entrance(
              child: HalenCard(
                emphasis: CardEmphasis.raised,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: DataRole.nicotine.of(context),
                    ),
                    const SizedBox(width: HalenSpace.x3),
                    Expanded(
                      child: Text(
                        l10n.medicinesCombinationSuggestion,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x6),
          ],

          HalenSectionHeader(title: l10n.medicinesOtc),
          const SizedBox(height: HalenSpace.x3),
          for (final entry in repo.overTheCounter())
            Padding(
              padding: const EdgeInsets.only(bottom: HalenSpace.x3),
              child: _MedicineTile(entry: entry, locale: locale),
            ),

          const SizedBox(height: HalenSpace.x6),
          HalenSectionHeader(title: l10n.medicinesPrescription),
          const SizedBox(height: HalenSpace.x3),
          for (final entry in repo.prescriptionOnly())
            Padding(
              padding: const EdgeInsets.only(bottom: HalenSpace.x3),
              child: _MedicineTile(entry: entry, locale: locale),
            ),

          const SizedBox(height: HalenSpace.x6),
          HalenCard(
            emphasis: CardEmphasis.quiet,
            child: Text(
              l10n.medicinesDisclaimer,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineTile extends StatefulWidget {
  const _MedicineTile({required this.entry, required this.locale});

  final MedicineEntry entry;
  final String locale;

  @override
  State<_MedicineTile> createState() => _MedicineTileState();
}

class _MedicineTileState extends State<_MedicineTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final entry = widget.entry;
    final locale = widget.locale;

    // The comparator travels with the number. A risk ratio on its own is a
    // marketing figure; "compared to a dummy treatment" is a finding.
    final ratio = entry.riskRatio.toStringAsFixed(2);
    final ratioLine = entry.comparesToSingleNrt
        ? l10n.medicinesRatioSingle(ratio)
        : l10n.medicinesRatioPlacebo(ratio);

    return HalenCard(
      onTap: () => setState(() => _open = !_open),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.name(locale),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              AnimatedRotation(
                turns: _open ? 0.5 : 0,
                duration: HalenDuration.respecting(
                  context,
                  HalenDuration.quick,
                ),
                child: const Icon(Icons.expand_more_rounded),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x2),
          HalenPill(
            label: ratioLine,
            color: DataRole.progress.of(context),
            icon: Icons.science_outlined,
          ),
          AnimatedSize(
            duration: HalenDuration.respecting(context, HalenDuration.standard),
            curve: HalenCurves.enter,
            alignment: Alignment.topCenter,
            child: _open
                ? Padding(
                    padding: const EdgeInsets.only(top: HalenSpace.x4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Block(
                          title: l10n.medicinesHowItWorks,
                          body: entry.howItWorks(locale),
                        ),
                        _Block(
                          title: l10n.medicinesTypicalUse,
                          body: entry.typicalUse(locale),
                        ),
                        _Block(
                          title: l10n.medicinesCommonMistake,
                          body: entry.commonMistake(locale),
                        ),
                        Text(
                          'Source: ${entry.source}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: HalenSpace.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelLarge),
          const SizedBox(height: HalenSpace.x1),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
