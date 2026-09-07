import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/record_providers.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/screens/shell_screen.dart';

/// Screen 9: BUGÜN — the main daily screen.
///
/// Primary action is one big CTA (report §12): a single tap logs a cigarette
/// and opens the optional detail sheet. The secondary "I resisted" action is
/// a positive record, never a test.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final now = DateTime.now();

    final eventsAsync = ref.watch(cigaretteEventsProvider);
    final cravingsAsync = ref.watch(cravingEventsProvider);
    final todayCount = eventsAsync.maybeWhen(
      data: (events) => eventsOnDay(events, now).length,
      orElse: () => 0,
    );
    final resistedToday = cravingsAsync.maybeWhen(
      data: (cravings) => cravings
          .where((c) => c.ts.isSameLocalDayAs(now))
          .where((c) => c.outcome == CravingOutcome.resisted)
          .length,
      orElse: () => 0,
    );

    Future<void> logCigarette() async {
      final id = await ref.read(recordRepositoryProvider).logCigarette(
            source: RecordSource.app,
          );
      if (context.mounted) {
        await Navigator.of(context).pushNamed(
          Routes.recordDetail,
          arguments: id,
        );
      }
    }

    Future<void> logResisted() async {
      await ref.read(recordRepositoryProvider).logCraving(
            outcome: CravingOutcome.resisted,
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todayTitle),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // The single big CTA (amber reserved for exactly this button).
            FilledButton(
              onPressed: logCigarette,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary,
                foregroundColor: theme.colorScheme.onTertiary,
                minimumSize: const Size.fromHeight(96),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                l10n.ctaSmoked,
                style: theme.textTheme.headlineSmall,
                semanticsLabel: l10n.ctaSmoked,
              ),
            ),
            const SizedBox(height: 12),
            // Secondary positive action.
            OutlinedButton(
              onPressed: logResisted,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: Text(
                '${l10n.ctaResisted} · ${l10n.resistedTodayCount(resistedToday)}',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                l10n.todayRingLabel(todayCount, todayCount),
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


