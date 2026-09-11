import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/plan_controller.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/application/record_providers.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/application/module_providers.dart';
import 'package:halen/core/theme.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/daily_card_tile.dart';
import 'package:halen/presentation/widgets/design/halen_components.dart';
import 'package:halen/presentation/widgets/entrance.dart';
import 'package:halen/presentation/widgets/milestone_watcher.dart';
import 'package:halen/presentation/widgets/mind_state_card.dart';
import 'package:halen/presentation/widgets/quit_day_co_card.dart';
import 'package:halen/presentation/widgets/support_card_tile.dart';
import 'package:halen/core/design/tokens.dart';
import 'package:halen/core/haptics.dart';
import 'package:halen/domain/plan_kinds.dart';
import 'package:halen/presentation/widgets/cessation/quit_date_strip.dart';
import 'package:halen/presentation/widgets/cessation/slip_coach_card.dart';
import 'package:halen/presentation/widgets/today/log_feedback.dart';
import 'package:halen/presentation/widgets/today/mini_organ_cockpit.dart';
import 'package:halen/presentation/widgets/today/now_in_body_strip.dart';
import 'package:halen/presentation/widgets/today/progress_score_tile.dart';
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
    final stateAsync = ref.watch(todayStateProvider);

    return stateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorRetry(
        message: l10n.commonErrorTitle,
        onRetry: () => ref.invalidate(todayStateProvider),
      ),
      data: (state) => _TodayBody(state: state),
    );
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.state});

  final TodayState state;

  Future<void> _logCigarette(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final db = ref.read(databaseProvider);
    final controller = PlanController(db);
    // The lightest touch in the app: a record is a neutral data point, and
    // a heavy buzz here would be a scolding by another means.
    HalenHaptics.logged(context);
    final id = await ref
        .read(recordRepositoryProvider)
        .logCigarette(source: RecordSource.app);

    // Dynamic recalculation (report §14.4): after every record the rest of
    // the day is redistributed — no penalty, just "Yeniden hesapladık."
    final now = DateTime.now();
    final plan = await controller.ensureTodayPlan(now);
    final dayStart = now.dayStart;
    final events = await db.recordDao.getEventsBetween(
      dayStart,
      dayStart.add(const Duration(days: 1)),
    );
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.recalcBunched)));
    } else if (redistribution.messageKey == 'recalculated') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.recalcTitle} ${l10n.recalcDistributed}'),
        ),
      );
    }
    // The record is already saved; this is feedback, never a gate
    // (module report §12: "I smoked" is a quietening, not a punishment).
    final baseline = await ref.read(measuredBaselineProvider.future);
    if (!context.mounted) {
      return;
    }
    final settings = await db.settingsDao.getSettings();
    if (!context.mounted) {
      return;
    }
    await showLogFeedback(
      context,
      kind: LogFeedbackKind.smoked,
      pauseSeconds: settings.preLogPauseSeconds,
      // Item 9: sad, then hope, then one concrete thing to do. The line
      // rotates so the same sentence is not read ten times a day; the plain
      // count moves to the footnote rather than leading.
      headline: _smokedHeadline(l10n, events.length),
      detail: _smokedAdvice(l10n, events.length),
      footnote: [
        l10n.logSmokedNeutral(
          events.length,
          baseline.toStringAsFixed(baseline % 1 == 0 ? 0 : 1),
        ),
        if (state.nextSuggestion != null)
          l10n.logNextTarget(
            TimeOfDay.fromDateTime(state.nextSuggestion!).format(context),
          ),
      ].join('  ·  '),
      onUndo: () async {
        await db.recordDao.deleteEvent(id);
        await ref.read(recordRepositoryProvider).recomputeDailySummary(now);
        ref.invalidate(todayStateProvider);
      },
    );
    if (!context.mounted) {
      return;
    }
    await Navigator.of(context).pushNamed(Routes.recordDetail, arguments: id);
  }

  Future<void> _logResisted(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    HalenHaptics.resisted(context);
    await ref
        .read(recordRepositoryProvider)
        .logCraving(outcome: CravingOutcome.resisted);
    ref.invalidate(todayStateProvider);

    // The reward is real data, not confetti: the peak that never happened.
    final monthStart = DateTime(DateTime.now().year, DateTime.now().month);
    final resisted = await ref
        .read(databaseProvider)
        .cravingDao
        .countResistedBetween(monthStart, DateTime.now());
    if (!context.mounted) {
      return;
    }
    await showLogFeedback(
      context,
      kind: LogFeedbackKind.skipped,
      headline: l10n.logSkippedTitle,
      detail: l10n.logSkippedCount(resisted),
      celebrate: resisted % 10 == 0,
    );
  }

  String _smokedHeadline(AppLocalizations l10n, int count) =>
      switch (count % 4) {
        0 => l10n.smokedHeadline0,
        1 => l10n.smokedHeadline1,
        2 => l10n.smokedHeadline2,
        _ => l10n.smokedHeadline3,
      };

  String _smokedAdvice(AppLocalizations l10n, int count) =>
      switch (count % 4) {
        0 => l10n.smokedAdvice0,
        1 => l10n.smokedAdvice1,
        2 => l10n.smokedAdvice2,
        _ => l10n.smokedAdvice3,
      };

  String _lastCigaretteText(AppLocalizations l10n, DateTime? last) {
    if (last == null) {
      return l10n.lastCigaretteNone;
    }
    final delta = DateTime.now().difference(last);
    if (delta.inHours >= 1) {
      return l10n.lastCigaretteHours(delta.inHours, delta.inMinutes % 60);
    }
    return l10n.lastCigaretteMinutes(delta.inMinutes);
  }

  String _nextTargetText(AppLocalizations l10n, DateTime? suggestion) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final planRow = ref.watch(planStateProvider).value;
    final planKind = planRow?.kind ?? PlanKind.gradualTaper;
    final planName = switch (planKind) {
      PlanKind.gradualTaper => l10n.planKindGradual,
      PlanKind.dailyQuota => l10n.planKindQuota,
      PlanKind.quitDay => l10n.planKindQuitDay,
      PlanKind.trackOnly => l10n.planKindTrackOnly,
    };
    final planWeek = planRow == null
        ? 1
        : DateTime.now().difference(planRow.startedAt).inDays ~/ 7 + 1;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appName.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 3,
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: HalenSpace.x1),
                    Text(l10n.todayTitle, style: theme.textTheme.headlineMedium),
                  ],
                ),
              ),
              const ShellSettingsButton(),
            ],
          ),
          const SizedBox(height: HalenSpace.x5),

          // ——— Focus hero: Active Plan & Rhythm ———
          Container(
            decoration: HalenSurface.hero(),
            child: Stack(
              children: [
                // Soft radial highlight for depth.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: RadialGradient(
                        center: const Alignment(-0.6, -1.0),
                        radius: 1.4,
                        colors: [
                          Colors.white.withValues(alpha: 0.10),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(HalenSpace.x6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: HalenSpace.x2,
                        runSpacing: HalenSpace.x2,
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.spa_rounded,
                                  color: HalenColors.mint,
                                  size: 13,
                                ),
                                const SizedBox(width: HalenSpace.x1),
                                Flexible(
                                  child: Text(
                                    l10n.daysSinceStart(state.daysSinceStart),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: HalenColors.mint,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.planSwitch,
                              ),
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.swap_horiz_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: HalenSpace.x1),
                                    Flexible(
                                      child: Text(
                                        l10n.planCardSwitch,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: HalenSpace.x5),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final copy = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.planStripLabel(planName, planWeek),
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                  height: 1.2,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: HalenSpace.x2),
                              Text(
                                l10n.planCardTarget(state.target),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFFD6E8DB),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: HalenSpace.x1),
                              Text(
                                state.smoked <= state.target
                                    ? l10n.recalcDistributed
                                    : l10n.recalcWeekSoftened,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.75),
                                ),
                              ),
                            ],
                          );
                          final ring = BudgetRing(
                            smoked: state.smoked,
                            target: state.target,
                            semanticLabel: l10n.todayRingLabel(
                              state.smoked,
                              state.target,
                            ),
                          );
                          if (constraints.maxWidth < 280 ||
                              MediaQuery.textScalerOf(context).scale(1) > 1.3) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                copy,
                                const SizedBox(height: HalenSpace.x4),
                                Center(child: ring),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: copy),
                              const SizedBox(width: HalenSpace.x2),
                              ring,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: HalenSpace.x5),
                      _HeroStatRow(
                        icon: Icons.history_rounded,
                        label: _lastCigaretteText(l10n, state.lastCigarette),
                      ),
                      const SizedBox(height: HalenSpace.x3),
                      _HeroStatRow(
                        icon: Icons.flag_rounded,
                        label: _nextTargetText(l10n, state.nextSuggestion),
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: HalenSpace.x4),

          // ——— The two actions ———
          // Item 8, the psychology of the pair. The win comes first: filled,
          // in the primary colour, with a growing-leaf icon. The cigarette is
          // still one tap — a log that is hard to make is a log people stop
          // making — but it is quiet: outlined, desaturated, a smoke icon,
          // and never the brightest thing on the screen. It used to be the
          // amber all-caps "I SMOKED", which made it the most inviting
          // control in the app.
          FilledButton.icon(
            onPressed: () => _logResisted(context, ref),
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              minimumSize: const Size.fromHeight(60),
              shape: const RoundedRectangleBorder(
                borderRadius: HalenRadius.mediumAll,
              ),
            ),
            icon: const Icon(Icons.spa_rounded, size: 24),
            label: Text(
              '${l10n.ctaResisted} · ${l10n.resistedTodayCount(state.resistedToday)}',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: HalenSpace.x3),
          OutlinedButton.icon(
            // Never locked. This used to disable itself once the day's target
            // was reached, so every cigarette over budget went unrecorded —
            // and the nicotine, tar, organ and cost figures all undercounted
            // on exactly the days that mattered most. Over budget is a
            // recalculation, not a closed door.
            onPressed: () => _logCigarette(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
              backgroundColor:
                  colors.surfaceContainerHighest.withValues(alpha: 0.6),
              side: BorderSide(color: colors.outline),
              minimumSize: const Size.fromHeight(52),
              shape: const RoundedRectangleBorder(
                borderRadius: HalenRadius.mediumAll,
              ),
            ),
            icon: const Icon(Icons.smoking_rooms_rounded, size: 20),
            label: Text(l10n.ctaSmoked),
          ),
          const SizedBox(height: HalenSpace.x4),

          // ——— Smoking diary right below action buttons (road-tested visibility) ———
          const TodayLogCard(),
          const SizedBox(height: HalenSpace.x6),

          // ——— Overview ———
          // The quit attempt comes first when there is something to say
          // about it: a slip that needs naming, or a date that is close.
          // Neither appears when there is nothing to report.
          const MilestoneWatcher(),
          const SlipCoachCard(),
          const QuitDateStrip(),

          // Two named groups rather than one undifferentiated stack. Eight
          // cards in a row with no headings reads as a wall: every card looks
          // equally important, which means none of them do.
          HalenSectionHeader(title: l10n.todaySectionState),
          const SizedBox(height: HalenSpace.x3),
          // Item 14: the one number that answers "am I getting better?"
          // leads the section instead of living below the fold on Grafikler.
          const Entrance(child: ProgressScoreTile()),
          const SizedBox(height: HalenSpace.x4),
          const Entrance(child: MiniOrganCockpit()),
          const SizedBox(height: HalenSpace.x4),
          // §1 — the question people open the app with, answered before
          // anything else: how much is still in me, and how long has it been.
          const Entrance(child: NowInBodyStrip()),
          const SizedBox(height: HalenSpace.x4),
          const Entrance(index: 1, child: QuitDayCoCard()),
          const SizedBox(height: HalenSpace.x8),

          // Module report §8 and §10 — the daily pair: an honest guess at how
          // today is likely to feel, and one small thing to do about it.
          HalenSectionHeader(title: l10n.todaySectionSupport),
          const SizedBox(height: HalenSpace.x3),
          const Entrance(index: 2, child: MindStateCard()),
          const SizedBox(height: HalenSpace.x4),
          const Entrance(index: 3, child: SupportCardTile()),
          const SizedBox(height: HalenSpace.x4),
          // §11 — one card a day, phase-aware, and never a hard-truth card
          // during the withdrawal peak.
          const Entrance(index: 4, child: DailyCardTile()),
          const SizedBox(height: HalenSpace.x8),

          Text(l10n.todayOverview, style: theme.textTheme.titleMedium),
          const SizedBox(height: HalenSpace.x3),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(HalenSpace.x5),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(HalenSpace.x3),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.savings_rounded,
                      color: colors.onPrimaryContainer,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: HalenSpace.x4),
                  Expanded(
                    child: Text(
                      l10n.savingsStrip(
                        state.savingsToday.toStringAsFixed(0),
                        state.avoidedToday,
                      ),
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: HalenSpace.x3),
          Card(
            color: colors.primaryContainer,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              leading: Container(
                padding: const EdgeInsets.all(HalenSpace.x3),
                decoration: BoxDecoration(
                  color: colors.onPrimaryContainer.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.air_rounded,
                  color: colors.onPrimaryContainer,
                  size: 22,
                ),
              ),
              title: Text(
                l10n.todaySupportTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
              subtitle: Text(
                l10n.todaySupportNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: colors.onPrimaryContainer,
              ),
              onTap: () => Navigator.pushNamed(context, Routes.breathing),
            ),
          ),
          const SizedBox(height: HalenSpace.x4),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 4,
              ),
              shape: const Border(),
              collapsedShape: const Border(),
              leading: Container(
                padding: const EdgeInsets.all(HalenSpace.x3),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: colors.primary,
                  size: 22,
                ),
              ),
              title: Text(
                l10n.nicotineMiniLabel,
                style: theme.textTheme.titleSmall,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              children: [
                NicotineSparkline(
                  curve: state.nicotineCurve,
                  semanticLabel: l10n.a11yNicotineChart,
                ),
                const SizedBox(height: HalenSpace.x3),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.howCalculated),
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: Text(l10n.commonHowCalculated),
                ),
              ],
            ),
          ),
          const SizedBox(height: HalenSpace.x3),
          Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(HalenSpace.x3),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.favorite_border_rounded,
                  color: colors.primary,
                  size: 22,
                ),
              ),
              title: Text(
                l10n.timelineTitle,
                style: theme.textTheme.titleSmall,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.pushNamed(context, Routes.healthTimeline),
            ),
          ),
          if (state.isFirstDay) ...[
            const SizedBox(height: HalenSpace.x4),
            Text(
              l10n.todayEmptyFirstDay,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// One compact stat line inside the hero card.
class _HeroStatRow extends StatelessWidget {
  const _HeroStatRow({
    required this.icon,
    required this.label,
    this.emphasize = false,
  });

  final IconData icon;
  final String label;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: emphasize ? HalenColors.mint : const Color(0xFF9FC4AF),
          ),
          const SizedBox(width: HalenSpace.x3),
          Expanded(
            child: Text(
              label,
              style: emphasize
                  ? theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    )
                  : theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFD6E8DB),
                    ),
            ),
          ),
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
          const SizedBox(height: HalenSpace.x3),
          OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
        ],
      ),
    );
  }
}
