import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/record_providers.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/entities.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../design/halen_components.dart';

/// The cigarette that was just logged and may still get a trigger tag.
class FollowUp {
  const FollowUp(this.eventId, this.at);

  final int eventId;
  final DateTime at;
}

class FollowUpNotifier extends Notifier<FollowUp?> {
  @override
  FollowUp? build() => null;

  void offer(int eventId) => state = FollowUp(eventId, DateTime.now());

  void clear() => state = null;
}

final followUpProvider =
    NotifierProvider<FollowUpNotifier, FollowUp?>(FollowUpNotifier.new);

String triggerLabelText(AppLocalizations l10n, TriggerLabel label) =>
    switch (label) {
      TriggerLabel.coffee => l10n.triggerCoffee,
      TriggerLabel.afterMeal => l10n.triggerAfterMeal,
      TriggerLabel.stress => l10n.triggerStress,
      TriggerLabel.alcohol => l10n.triggerAlcohol,
      TriggerLabel.car => l10n.triggerCar,
      TriggerLabel.social => l10n.triggerSocial,
      TriggerLabel.workBreak => l10n.triggerWorkBreak,
      TriggerLabel.beforeSleep => l10n.triggerBeforeSleep,
      TriggerLabel.wakeUp => l10n.triggerWakeUp,
    };

/// "What set it off?" — right under the button, one tap, then it goes away.
///
/// Owner feedback (2026-10-02): the follow-up to "I smoked" must appear where
/// the person just tapped, not inside another page. It is optional, never
/// blocks anything, and quietly disappears after [_visibleFor].
class QuickFollowUp extends ConsumerStatefulWidget {
  const QuickFollowUp({super.key});

  static const _visibleFor = Duration(seconds: 45);

  @override
  ConsumerState<QuickFollowUp> createState() => _QuickFollowUpState();
}

class _QuickFollowUpState extends ConsumerState<QuickFollowUp> {
  Timer? _expiry;
  int? _armedFor;

  @override
  void dispose() {
    _expiry?.cancel();
    super.dispose();
  }

  void _arm(FollowUp followUp) {
    if (_armedFor == followUp.eventId) {
      return;
    }
    _armedFor = followUp.eventId;
    _expiry?.cancel();
    _expiry = Timer(QuickFollowUp._visibleFor, () {
      if (mounted && ref.read(followUpProvider)?.eventId == followUp.eventId) {
        ref.read(followUpProvider.notifier).clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final followUp = ref.watch(followUpProvider);
    if (followUp == null) {
      return const SizedBox.shrink();
    }
    _arm(followUp);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: HalenSpace.x3),
      child: HalenCard(
        emphasis: CardEmphasis.quiet,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.followUpTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                TextButton(
                  onPressed: () => ref.read(followUpProvider.notifier).clear(),
                  child: Text(l10n.followUpSkip),
                ),
              ],
            ),
            Wrap(
              spacing: HalenSpace.x2,
              runSpacing: HalenSpace.x2,
              children: [
                for (final label in TriggerLabel.values)
                  ActionChip(
                    label: Text(triggerLabelText(l10n, label)),
                    onPressed: () async {
                      await ref
                          .read(recordRepositoryProvider)
                          .updateEventTrigger(followUp.eventId, label);
                      ref.read(followUpProvider.notifier).clear();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
