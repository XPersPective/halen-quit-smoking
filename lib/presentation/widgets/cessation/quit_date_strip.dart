import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../domain/cessation.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../design/halen_components.dart';

/// The quit date on the home screen (premium brief §C.2).
///
/// It appears in three states and stays silent in a fourth:
///
///  * **no date** — one line inviting one, because reduction without a date
///    drifts into being its own destination;
///  * **counting down** — the number of days, which is the whole point of
///    having a date at all;
///  * **the day itself** — the loudest thing on the screen, opening the
///    quit-day screen;
///  * **long past** — nothing. A counter that says "day 214" every morning
///    stops being information.
class QuitDateStrip extends ConsumerWidget {
  const QuitDateStrip({super.key});

  /// After this many days the countdown has done its job and gets out of
  /// the way; the streak and the milestones carry it from there.
  static const int _fadeAfterDays = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(cessationStateProvider).value;
    final days = ref.watch(daysToQuitProvider);

    if (state == null) {
      return const SizedBox.shrink();
    }

    if (days == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: HalenSpace.x4),
        child: HalenCard(
          onTap: () => Navigator.of(context).pushNamed(Routes.quitPlan),
          child: Row(
            children: [
              Icon(
                Icons.event_outlined,
                color: DataRole.progress.of(context),
              ),
              const SizedBox(width: HalenSpace.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quitDateTitle,
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      l10n.quitDateWhy,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      );
    }

    if (days < -_fadeAfterDays) {
      return const SizedBox.shrink();
    }

    final isToday = days == 0;
    final label = switch (days) {
      0 => l10n.quitDayTitle,
      1 => l10n.quitDateTomorrow,
      _ when days > 0 => l10n.quitDateIn(days),
      _ => l10n.quitDatePassed(-days),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: HalenSpace.x4),
      child: HalenCard(
        emphasis: isToday ? CardEmphasis.raised : CardEmphasis.resting,
        onTap: () => Navigator.of(context).pushNamed(
          isToday ? Routes.quitDay : Routes.quitPlan,
        ),
        child: Row(
          children: [
            Expanded(
              child: HalenStat(
                label: l10n.quitDateTitle,
                value: label,
                color: DataRole.progress.of(context),
                large: isToday,
                caption: isToday ? l10n.quitDayLead : null,
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

/// Everything the strip needs from the domain, in one place, so the widget
/// stays a widget.
extension QuitDateStripState on CessationState {
  bool isCountingDown(DateTime now) =>
      quitDate != null && QuitDateGuidance.daysUntil(now, quitDate!) > 0;
}
