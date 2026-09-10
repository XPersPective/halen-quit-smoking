import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/module_providers.dart';
import '../../../application/providers.dart';
import '../../../application/stats_providers.dart';
import '../../../core/dates.dart';
import '../../../core/theme.dart';
import '../../../domain/economy.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/charts/halen_line_chart.dart';
import '../../../core/design/tokens.dart';

/// Money and time (module report §3).
///
/// This is the one screen in the app where nothing is modelled: it is the
/// user's own price, their own records and arithmetic — and it says so. The
/// only estimate on it is the time ledger, which carries the word "average"
/// because 20 minutes per cigarette is a population figure, not a promise.
///
/// It also shows the half nobody else dares to: money still being spent.
/// Neutral grey, same type size, no commentary.
class EconomyScreen extends ConsumerWidget {
  const EconomyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final money = NumberFormat.currency(locale: locale, decimalDigits: 0);
    // Axis ticks get the compact form: a full currency string wraps inside
    // the gutter and collides with the line above it.
    final compactMoney =
        NumberFormat.compactCurrency(locale: locale, decimalDigits: 0);

    final economy = ref.watch(economyProvider).value;
    final profile = ref.watch(smokingProfileProvider).value;
    final baseline = ref.watch(measuredBaselineProvider).value ?? 0;
    final stats = ref.watch(dailyStatsProvider(90)).value ?? const [];
    final goal = ref.watch(savingsGoalProvider).value;

    if (economy == null || profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.economyTitle)),
        body: Center(child: Text(l10n.commonLoading)),
      );
    }

    final smokedTotal = stats.fold<int>(0, (sum, d) => sum + d.count);
    final avoidedTotal = stats.fold<int>(
      0,
      (sum, d) => sum + math.max(0, (baseline - d.count).round()),
    );
    final recentCounts = stats.length <= 7
        ? stats
        : stats.sublist(stats.length - 7);
    final currentCpd = recentCounts.isEmpty
        ? baseline
        : recentCounts.fold<int>(0, (s, d) => s + d.count) /
              recentCounts.length;

    // The plan path: the pace's weekly reduction rate applied from today.
    final planPath = <double>[];
    var planCpd = currentCpd;
    for (var day = 0; day < 365; day++) {
      if (day % 7 == 0 && day > 0) {
        planCpd = math.max(0, planCpd * (1 - profile.pace.weeklyRate));
      }
      planPath.add(planCpd);
    }
    final projection = economy.projection(
      currentCpd: currentCpd,
      planCpd: planPath,
    );
    final gap = projection.last.difference;

    final saved = economy.saved(avoidedTotal);
    final spent = economy.spent(smokedTotal);
    final dailySaving = economy.saved(
      math.max(0, (baseline - currentCpd).round()),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.economyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(HalenSpace.x5),
        children: [
          Text(l10n.economyExactNote, style: theme.textTheme.bodyMedium),
          const SizedBox(height: HalenSpace.x4),
          Row(
            children: [
              Expanded(
                child: _Amount(
                  label: l10n.economySaved,
                  value: money.format(saved),
                  color: HalenColors.emerald,
                  emphasize: true,
                ),
              ),
              const SizedBox(width: HalenSpace.x3),
              Expanded(
                child: _Amount(
                  label: l10n.economySpent,
                  value: money.format(spent),
                  color: HalenColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x4),
          _Equivalent(saved: saved),
          const SizedBox(height: HalenSpace.x8),

          ChartCard(
            title: l10n.economyProjectionTitle,
            trailing: Text(
              money.format(gap),
              style: theme.textTheme.titleLarge?.copyWith(
                color: HalenColors.emerald,
              ),
            ),
            footnote: l10n.economyShadedArea,
            child: HalenLineChart(
              meaning: l10n.economyMeaning,
              shadeBetween: true,
              minY: 0,
              yFormatter: compactMoney.format,
              tooltipFormatter: money.format,
              yLabelWidth: 72,
              series: [
                ChartSeries(
                  name: l10n.economyKeepPace,
                  color: HalenColors.textSecondaryLight,
                  values: [for (final p in projection) p.keepThisPace],
                ),
                ChartSeries(
                  name: l10n.economyFinishPlan,
                  color: HalenColors.emerald,
                  values: [for (final p in projection) p.finishThePlan],
                ),
              ],
              xLabels: const ['0', '6', '12'],
              semanticsLabel:
                  '${l10n.economyProjectionTitle}: ${money.format(gap)}',
            ),
          ),
          const SizedBox(height: HalenSpace.x8),

          Text(l10n.economyTimeLedger, style: theme.textTheme.titleMedium),
          const SizedBox(height: HalenSpace.x3),
          Row(
            children: [
              Expanded(
                child: _Amount(
                  label: l10n.economyTimeRegained,
                  value: formatShortDuration(
                    economy.timeRegained(avoidedTotal),
                    locale,
                  ),
                  color: HalenColors.emerald,
                ),
              ),
              const SizedBox(width: HalenSpace.x3),
              Expanded(
                child: _Amount(
                  label: l10n.economyTimeLost,
                  value: formatShortDuration(
                    economy.timeLost(smokedTotal),
                    locale,
                  ),
                  color: HalenColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.economyLifeAverageNote, style: theme.textTheme.labelSmall),
          const SizedBox(height: HalenSpace.x8),

          _GoalSection(
            goal: goal == null
                ? null
                : SavingsGoal(label: goal.label, amount: goal.amount),
            saved: saved,
            dailySaving: dailySaving,
            money: money,
          ),
          const SizedBox(height: HalenSpace.x6),
        ],
      ),
    );
  }
}

/// "That is about 2x a month at the gym" — the equivalent engine
/// (module report §3.③). Silent until the saving is worth picturing.
class _Equivalent extends StatelessWidget {
  const _Equivalent({required this.saved});

  final double saved;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final best = bestEquivalent(amount: saved, locale: locale);
    if (best == null) {
      return const SizedBox.shrink();
    }
    final item = switch (best.key) {
      EquivalentKey.groceries => l10n.equivalentGroceries,
      EquivalentKey.fuelTank => l10n.equivalentFuelTank,
      EquivalentKey.gymMonth => l10n.equivalentGymMonth,
      EquivalentKey.flightTicket => l10n.equivalentFlightTicket,
      EquivalentKey.phone => l10n.equivalentPhone,
    };
    return Row(
      children: [
        const Icon(Icons.swap_horiz_rounded, size: 18),
        const SizedBox(width: HalenSpace.x2),
        Expanded(
          child: Text(
            '${l10n.economyEquivalentTitle}: '
            '${l10n.economyEquivalentCount(best.count, item)}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _Amount extends StatelessWidget {
  const _Amount({
    required this.label,
    required this.value,
    required this.color,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final Color color;

  /// Exactly one big number per card (chart rule 2) — the saved side wins.
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(HalenSpace.x4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: HalenSpace.x2),
          Text(
            value,
            style:
                (emphasize
                        ? theme.textTheme.headlineMedium
                        : theme.textTheme.titleMedium)
                    ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _GoalSection extends ConsumerStatefulWidget {
  const _GoalSection({
    required this.goal,
    required this.saved,
    required this.dailySaving,
    required this.money,
  });

  final SavingsGoal? goal;
  final double saved;
  final double dailySaving;
  final NumberFormat money;

  @override
  ConsumerState<_GoalSection> createState() => _GoalSectionState();
}

class _GoalSectionState extends ConsumerState<_GoalSection> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final goal = widget.goal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.economyGoalTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: HalenSpace.x2),
            if (goal == null) ...[
              Text(l10n.economyGoalHint, style: theme.textTheme.bodyMedium),
              const SizedBox(height: HalenSpace.x3),
              FilledButton(onPressed: _editGoal, child: Text(l10n.commonEdit)),
            ] else ...[
              Text(goal.label, style: theme.textTheme.titleLarge),
              const SizedBox(height: HalenSpace.x3),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: goal.progress(widget.saved),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: HalenSpace.x2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.money.format(widget.saved)} / '
                      '${widget.money.format(goal.amount)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: _editGoal,
                    child: Text(l10n.commonEdit),
                  ),
                ],
              ),
              Builder(
                builder: (context) {
                  final days = goal.daysRemaining(
                    widget.saved,
                    widget.dailySaving,
                  );
                  if (days == null) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    l10n.economyGoalRemaining(days),
                    style: theme.textTheme.labelMedium,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editGoal() async {
    final l10n = AppLocalizations.of(context)!;
    final labelController = TextEditingController(
      text: widget.goal?.label ?? '',
    );
    final amountController = TextEditingController(
      text: widget.goal?.amount.toStringAsFixed(0) ?? '',
    );
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.economyGoalTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: InputDecoration(labelText: l10n.economyGoalLabel),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: HalenSpace.x3),
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: l10n.economyGoalAmount),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (saved != true) {
      return;
    }
    final amount = double.tryParse(amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0 || labelController.text.trim().isEmpty) {
      return;
    }
    await ref
        .read(databaseProvider)
        .moduleDao
        .setSavingsGoal(label: labelController.text.trim(), amount: amount);
  }
}
