import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/cessation_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';
import '../../widgets/entrance.dart';
import 'quit_plan_screen.dart' show quitReasonLabel;

/// The quit date, when it arrives (premium brief §C.3).
///
/// Day one is mostly logistics, and the logistics are the part people have
/// not thought through: the cigarettes still in the drawer, the hour in the
/// evening when the hands have nothing to do. So this screen is three
/// concrete blocks in the order the day happens, and their own stated reason
/// at the top of it — the motivational-interviewing move, played back at the
/// moment it is worth the most.
class QuitDayScreen extends ConsumerWidget {
  const QuitDayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final reason = ref.watch(cessationStateProvider).value?.reason;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.quitDayTitle)),
      body: ListView(
        padding: HalenSpace.screen,
        children: [
          Text(l10n.quitDayLead, style: theme.textTheme.bodyLarge),
          if (reason != null) ...[
            const SizedBox(height: HalenSpace.x4),
            Entrance(
              child: HalenCard(
                emphasis: CardEmphasis.raised,
                child: Row(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: DataRole.progress.of(context),
                    ),
                    const SizedBox(width: HalenSpace.x3),
                    Expanded(
                      child: Text(
                        l10n.quitDayReasonReminder(
                          quitReasonLabel(reason, l10n).toLowerCase(),
                        ),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: HalenSpace.x6),

          Entrance(
            index: 1,
            child: _Hour(
              icon: Icons.wb_twilight_rounded,
              title: l10n.quitDayMorning,
              body: l10n.quitDayMorningBody,
            ),
          ),
          const SizedBox(height: HalenSpace.x4),
          Entrance(
            index: 2,
            child: _Hour(
              icon: Icons.light_mode_rounded,
              title: l10n.quitDayAfternoon,
              body: l10n.quitDayAfternoonBody,
            ),
          ),
          const SizedBox(height: HalenSpace.x4),
          Entrance(
            index: 3,
            child: _Hour(
              icon: Icons.nightlight_round,
              title: l10n.quitDayEvening,
              body: l10n.quitDayEveningBody,
            ),
          ),

          const SizedBox(height: HalenSpace.x6),
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.cravingSos),
            icon: const Icon(Icons.healing_outlined),
            label: Text(l10n.navSos),
          ),
          const SizedBox(height: HalenSpace.x3),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(Routes.medicines),
            icon: const Icon(Icons.medication_outlined),
            label: Text(l10n.medicinesTitle),
          ),
        ],
      ),
    );
  }
}

class _Hour extends StatelessWidget {
  const _Hour({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return HalenCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: DataRole.progress.of(context)),
          const SizedBox(width: HalenSpace.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: HalenSpace.x1),
                Text(body, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
