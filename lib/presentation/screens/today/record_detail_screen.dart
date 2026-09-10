import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/record_providers.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// Screen 10: optional follow-up detail for a just-logged cigarette.
/// One tap logged the cigarette already — this only adds an optional tag.
class RecordDetailScreen extends ConsumerStatefulWidget {
  const RecordDetailScreen({super.key, required this.eventId});

  final int eventId;

  @override
  ConsumerState<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends ConsumerState<RecordDetailScreen> {
  TriggerLabel? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final labels = {
      TriggerLabel.coffee: l10n.triggerCoffee,
      TriggerLabel.afterMeal: l10n.triggerAfterMeal,
      TriggerLabel.stress: l10n.triggerStress,
      TriggerLabel.alcohol: l10n.triggerAlcohol,
      TriggerLabel.car: l10n.triggerCar,
      TriggerLabel.social: l10n.triggerSocial,
      TriggerLabel.workBreak: l10n.triggerWorkBreak,
      TriggerLabel.beforeSleep: l10n.triggerBeforeSleep,
      TriggerLabel.wakeUp: l10n.triggerWakeUp,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recordDetailTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HalenSpace.x6),
          children: [
            Text(l10n.recordDetailHint, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HalenSpace.x4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in labels.entries)
                  FilterChip(
                    label: Text(entry.value),
                    selected: _selected == entry.key,
                    onSelected: (selected) {
                      setState(() {
                        _selected = selected ? entry.key : null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: HalenSpace.x6),
            FilledButton(
              onPressed: () async {
                await ref
                    .read(recordRepositoryProvider)
                    .updateEventTrigger(widget.eventId, _selected);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size.fromHeight(56),
              ),
              child: Text(l10n.commonDone),
            ),
          ],
        ),
      ),
    );
  }
}
