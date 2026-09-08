import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/plan_controller.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/application/record_providers.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/presentation/screens/shell_screen.dart';
import 'package:halen/presentation/widgets/today/today_log_sheet.dart';
import 'package:halen/presentation/widgets/today_widgets.dart';

/// Screen 9: BUGÜN — the main daily screen (report §12).
///
/// Primary action is one big CTA; a single tap logs a cigarette, the plan
/// recalculates and the optional detail sheet opens. The secondary "I
/// resisted" action is a positive record, never a test. No red, no penalty
/// UI — over-budget days say "Yeniden hesapladık." and move on.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final stateAsync = ref.watch(todayStateProvider);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorRetry(
        message: l10n.commonErrorTitle,
        onRetry: () => ref.invalidate(todayStateProvider),
      ),
      data: (state) => _TodayBody(
        state: state,
        l10n: l10n,
        theme: theme,
        ref: ref,
      ),
    );
  }
}

class _TodayBody extends StatelessWidget {
  const _TodayBody({
    required this.state,
    required this.l10n,
    required this.theme,
    required this.ref,
  });

  final TodayState state;
  final AppLocalizations l10n;
  final ThemeData theme;
  final WidgetRef ref;

  Future<void> _logCigarette(BuildContext context) async {
    final db = ref.read(databaseProvider);
    final controller = PlanController(db);
    final id = await ref.read(recordRepositoryProvider).logCigarette(
          source: RecordSource.app,
        );

    // Dynamic recalculation (report §14.4): after every record the rest of
    // the day is redistributed — no penalty, just "Yeniden hesapladık."
    final now = DateTime.now();
    final plan = await controller.ensureTodayPlan(now);
    final dayStart = now.dayStart;
    final events = await db.recordDao
        .getEventsBetween(dayStart, dayStart.add(const Duration(days: 1)));
    final redistribution = await controller.recalculateAfterRecord(
      now: now,
      todayEvents: events,
      plan: plan,
      wakingDayEndHour: 24,
    );

    ref.invalidate(todayStateProvider);

    if (!context.mounted) {
      return;
    }
    if (redistribution.messageKey == 'clustered') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.recalcBunched)),
      );
    } else if (redistribution.messageKey == 'recalculated') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.recalcTitle} ${l10n.recalcDistributed}')),
      );
    }
    await Navigator.of(context).pushNamed(
      Routes.recordDetail,
      arguments: id,
    );
  }

  Future<void> _logResisted() async {
    await ref.read(recordRepositoryProvider).logCraving(
          outcome: CravingOutcome.resisted,
        );
    ref.invalidate(todayStateProvider);
  }

  String _lastCigaretteText(DateTime? last) {
    if (last == null) {
      return l10n.lastCigaretteNone;
    }
    final delta = DateTime.now().difference(last);
    if (delta.inHours >= 1) {
      return l10n.lastCigaretteHours(delta.inHours, delta.inMinutes % 60);
    }
    return l10n.lastCigaretteMinutes(delta.inMinutes);
  }

  String _nextTargetText(DateTime? suggestion) {
    if (state.dayCompleted) {
      return l10n.nextTargetDayDone;
    }
    if (suggestion == null) {
      return l10n.nextTargetReady;
    }
    final delta = suggestion.difference(DateTime.now());
    if (delta.inHours >= 1) {
      return l10n.nextTargetHoursIn(delta.inHours, delta.inMinutes % 60);
    }
    return l10n.nextTargetIn(delta.inMinutes.clamp(0, 59));
  }

  @override
  Widget build(BuildContext context) {
    final currency = l10n.savingsStrip(
      state.savingsToday.toStringAsFixed(0),
      state.avoidedToday,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.todayTitle, style: theme.textTheme.headlineMedium),
              const ShellSettingsButton(),
            ],
          ),
          const SizedBox(height: 8),
          if (state.isFirstDay)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.todayEmptyFirstDay),
                ),
              ),
            ),
          Center(
            child: BudgetRing(
              smoked: state.smoked,
              target: state.target,
              semanticLabel: l10n.todayRingLabel(state.smoked, state.target),
            ),
          ),
          const SizedBox(height: 16),
          Text(_lastCigaretteText(state.lastCigarette),
              textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 4),
          Text(_nextTargetText(state.nextSuggestion),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          NicotineSparkline(
            curve: state.nicotineCurve,
            semanticLabel: l10n.a11yNicotineChart,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  l10n.nicotineMiniLabel,
                  style: theme.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: l10n.commonHowCalculated,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.help_outline, size: 18),
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.howCalculated),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // The single big CTA (amber reserved for exactly this button).
          FilledButton(
            onPressed: state.dayCompleted ? null : () => _logCigarette(context),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.tertiary,
              foregroundColor: theme.colorScheme.onTertiary,
              disabledBackgroundColor:
                  theme.colorScheme.tertiary.withValues(alpha: 0.4),
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
            onPressed: _logResisted,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
            ),
            child: Text(
              '${l10n.ctaResisted} · ${l10n.resistedTodayCount(state.resistedToday)}',
            ),
          ),
          const SizedBox(height: 20),
          const TodayLogCard(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: HalenColors.emerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      color: HalenColors.emerald,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      currency,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () =>
                  Navigator.pushNamed(context, Routes.healthTimeline),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: HalenColors.coral.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.favorite_outline,
                        color: HalenColors.coral,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.healthStrip(
                            l10n.daysSinceStart(state.daysSinceStart)),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
