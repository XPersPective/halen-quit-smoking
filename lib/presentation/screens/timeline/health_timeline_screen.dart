import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/providers.dart';
import 'package:halen/domain/health_timeline.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// Screen: WHO health-benefits timeline (report §17, S4 data).
///
/// Every card uses the population pattern ("In general, among people who
/// quit smoking…") and names its source. In reduce mode — before a quit day
/// is set — the list is a locked preview (report §17: "önizleme").
class HealthTimelineScreen extends ConsumerWidget {
  const HealthTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final stateAsync = ref.watch(timelineStateProvider);

    final bodies = <HealthMilestone, String>{
      HealthMilestone.twentyMinutes: l10n.timelineBody20min,
      HealthMilestone.twelveHours: l10n.timelineBody12h,
      HealthMilestone.twoToTwelveWeeks: l10n.timelineBody2to12w,
      HealthMilestone.oneToNineMonths: l10n.timelineBody1to9m,
      HealthMilestone.oneYear: l10n.timelineBody1y,
      HealthMilestone.strokeFiveTo15Years: l10n.timelineBody5to15y,
      HealthMilestone.tenYears: l10n.timelineBody10y,
      HealthMilestone.fifteenYears: l10n.timelineBody15y,
    };
    final titles = <HealthMilestone, String>{
      HealthMilestone.twentyMinutes: l10n.timelineMilestone20min,
      HealthMilestone.twelveHours: l10n.timelineMilestone12h,
      HealthMilestone.twoToTwelveWeeks: l10n.timelineMilestone2to12w,
      HealthMilestone.oneToNineMonths: l10n.timelineMilestone1to9m,
      HealthMilestone.oneYear: l10n.timelineMilestone1y,
      HealthMilestone.strokeFiveTo15Years: l10n.timelineMilestone5to15y,
      HealthMilestone.tenYears: l10n.timelineMilestone10y,
      HealthMilestone.fifteenYears: l10n.timelineMilestone15y,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.timelineTitle)),
      body: SafeArea(
        child: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.commonErrorTitle)),
          data: (quitTs) {
            final locked = timelinePreviewLocked(quitDate: quitTs);
            final days =
                quitTs == null ? 0 : daysSinceQuit(quitTs, DateTime.now());
            final current = currentMilestone(days);
            return ListView(
              padding: const EdgeInsets.all(HalenSpace.x6),
              children: [
                Text(l10n.timelineGeneralPattern,
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: HalenSpace.x2),
                if (locked)
                  Card(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(HalenSpace.x4),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_outline),
                          const SizedBox(width: HalenSpace.x3),
                          Expanded(child: Text(l10n.timelinePreviewLocked)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: HalenSpace.x2),
                for (final milestone in HealthMilestone.values)
                  _MilestoneCard(
                    title: titles[milestone]!,
                    body: bodies[milestone]!,
                    source: l10n.timelineSourceWho,
                    reached: !locked && days >= milestone.minQuitDays,
                    current: !locked && current == milestone,
                  ),
                const SizedBox(height: HalenSpace.x2),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(HalenSpace.x4),
                    child: Text(l10n.timelineCoCard),
                  ),
                ),
                const SizedBox(height: HalenSpace.x6),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.title,
    required this.body,
    required this.source,
    required this.reached,
    required this.current,
  });

  final String title;
  final String body;
  final String source;
  final bool reached;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          reached
              ? Icons.check_circle
              : (current ? Icons.radio_button_checked : Icons.circle_outlined),
          color: reached || current ? theme.colorScheme.primary : null,
        ),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text('$body\n$source'),
        isThreeLine: true,
      ),
    );
  }
}
