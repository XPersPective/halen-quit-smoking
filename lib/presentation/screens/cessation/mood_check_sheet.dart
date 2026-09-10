import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/cessation.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';

/// The two-item mood screen, PHQ-2 (premium brief §C.5).
///
/// Included because stopping smoking can bring low mood to the surface in
/// people who are prone to it, and an app that asks how someone feels every
/// single day and never asks the obvious clinical question is negligent.
///
/// Three rules hold it in its lane:
///
///  * **it screens, it does not diagnose.** Above the validated cut-off the
///    app says one thing — this is worth taking to a doctor — and stops;
///  * **it never discourages quitting.** A positive screen is a reason to
///    get support, not a reason to keep smoking, and the copy says so;
///  * **nothing leaves the phone.** Like every other row in this app.
Future<void> showMoodCheckSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HalenRadius.large),
        ),
      ),
      builder: (_) => const _MoodCheckSheet(),
    );

class _MoodCheckSheet extends ConsumerStatefulWidget {
  const _MoodCheckSheet();

  @override
  ConsumerState<_MoodCheckSheet> createState() => _MoodCheckSheetState();
}

class _MoodCheckSheetState extends ConsumerState<_MoodCheckSheet> {
  int? _interest;
  int? _mood;
  int? _result;

  bool get _complete => _interest != null && _mood != null;

  Future<void> _submit() async {
    final score = Phq2.score(lowInterest: _interest!, lowMood: _mood!);
    await ref.read(cessationControllerProvider).recordMoodScreen(
          lowInterest: _interest!,
          lowMood: _mood!,
        );
    if (mounted) {
      setState(() => _result = score);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.72,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: HalenSpace.screen,
        children: [
          Text(l10n.moodCheckTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.moodCheckWhy, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x5),
          if (_result == null) ...[
            Text(l10n.moodCheckLead, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HalenSpace.x4),
            _Item(
              question: l10n.moodCheckQ1,
              value: _interest,
              onChanged: (v) => setState(() => _interest = v),
            ),
            const SizedBox(height: HalenSpace.x5),
            _Item(
              question: l10n.moodCheckQ2,
              value: _mood,
              onChanged: (v) => setState(() => _mood = v),
            ),
            const SizedBox(height: HalenSpace.x6),
            FilledButton(
              onPressed: _complete ? _submit : null,
              child: Text(l10n.commonSave),
            ),
          ] else
            _Result(score: _result!),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final String question;
  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final labels = [
      l10n.moodCheckNever,
      l10n.moodCheckSomeDays,
      l10n.moodCheckMostDays,
      l10n.moodCheckEveryDay,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: theme.textTheme.titleSmall),
        const SizedBox(height: HalenSpace.x3),
        Wrap(
          spacing: HalenSpace.x2,
          runSpacing: HalenSpace.x2,
          children: [
            for (var i = 0; i < labels.length; i++)
              ChoiceChip(
                label: Text(labels[i]),
                selected: value == i,
                onSelected: (_) => onChanged(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final positive = Phq2.isPositive(score);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HalenCard(
          emphasis: positive ? CardEmphasis.raised : CardEmphasis.quiet,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HalenStat(
                label: l10n.moodCheckTitle,
                value: '$score / ${Phq2.maxScore}',
                // Never red, even here. A screening result is information
                // about something treatable, not an alarm.
                color: positive
                    ? DataRole.nicotine.of(context)
                    : DataRole.progress.of(context),
                large: true,
              ),
              const SizedBox(height: HalenSpace.x3),
              Text(
                positive
                    ? l10n.moodCheckResultTalk
                    : l10n.moodCheckResultClear,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: HalenSpace.x5),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.moodCheckDone),
        ),
      ],
    );
  }
}
