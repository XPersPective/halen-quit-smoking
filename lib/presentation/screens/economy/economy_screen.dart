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
import '../../../domain/input_bounds.dart';
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
enum EconomyTimeFilter { oneMonth, oneYear, allTime, lifetime }

/// Money and time (module report §3).
///
/// This is the one screen in the app where nothing is modelled: it is the
/// user's own price, their own records and arithmetic — and it says so. The
/// only estimate on it is the time ledger, which carries the word "average"
/// because 20 minutes per cigarette is a population figure, not a promise.
class EconomyScreen extends ConsumerStatefulWidget {
  const EconomyScreen({super.key});

  @override
  ConsumerState<EconomyScreen> createState() => _EconomyScreenState();
}

class _EconomyScreenState extends ConsumerState<EconomyScreen> {
  EconomyTimeFilter _filter = EconomyTimeFilter.allTime;

  @override
  Widget build(BuildContext context) {
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
    final goal = ref.watch(savingsGoalProvider).value;

    if (economy == null || profile == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.economyTitle)),
        body: Center(child: Text(l10n.commonLoading)),
      );
    }

    final now = DateTime.now();
    final daysSinceStart = now.difference(profile.startedAt).inDays + 1;
    final queryDays = switch (_filter) {
      EconomyTimeFilter.oneMonth => 30,
      EconomyTimeFilter.oneYear => 365,
      EconomyTimeFilter.allTime => math.max(30, daysSinceStart + 2),
      EconomyTimeFilter.lifetime => 30,
    };

    final stats = ref.watch(dailyStatsProvider(queryDays)).value ?? const [];

    final startKey = dayKey(profile.startedAt);
    final todayKey = dayKey(now);
    final filterMinKey = switch (_filter) {
      EconomyTimeFilter.oneMonth => dayKey(dayStartMinusDays(now, 29)),
      EconomyTimeFilter.oneYear => dayKey(dayStartMinusDays(now, 364)),
      _ => startKey,
    };

    // Only count days between startedAt (or filter bound) and today.
    // Prevents phantom pre-install empty days from being counted as avoided!
    final trackedStats = stats.where((d) {
      final afterMin = d.dateKey.compareTo(filterMinKey) >= 0;
      final afterStart = d.dateKey.compareTo(startKey) >= 0;
      final beforeToday = d.dateKey.compareTo(todayKey) <= 0;
      return afterMin && afterStart && beforeToday;
    }).toList();

    final smokedTotal = trackedStats.fold<int>(0, (sum, d) => sum + d.count);
    final avoidedTotal = trackedStats.fold<int>(
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

    // Lifetime historical calculation
    final smokingYears = (profile.smokingYears ?? 10.0).clamp(0.5, 70.0);
    final lifetimeCigarettes = (smokingYears * 365.25 * profile.baselineCpd).round();
    final lifetimeSpent = (lifetimeCigarettes / profile.packSize) * profile.pricePerPack;
    final lifetimeTimeLost = economy.timeLost(lifetimeCigarettes);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.economyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(HalenSpace.x5),
        children: [
          // Filter switcher
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<EconomyTimeFilter>(
              segments: [
                ButtonSegment(
                  value: EconomyTimeFilter.oneMonth,
                  label: Text(l10n.economyTimeFilter1m),
                ),
                ButtonSegment(
                  value: EconomyTimeFilter.oneYear,
                  label: Text(l10n.economyTimeFilter1y),
                ),
                ButtonSegment(
                  value: EconomyTimeFilter.allTime,
                  label: Text(l10n.economyTimeFilterAll),
                ),
                ButtonSegment(
                  value: EconomyTimeFilter.lifetime,
                  label: Text(l10n.economyTimeFilterLifetime),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) =>
                  setState(() => _filter = selection.first),
            ),
          ),
          const SizedBox(height: HalenSpace.x4),

          if (_filter == EconomyTimeFilter.lifetime) ...[
            Text(
              l10n.economyHistoricalTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: HalenSpace.x1),
            Text(
              l10n.economyHistoricalSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x4),
            _Amount(
              label: l10n.economySpent,
              value: money.format(lifetimeSpent),
              color: HalenColors.coral,
              emphasize: true,
            ),
            const SizedBox(height: HalenSpace.x3),
            Row(
              children: [
                Expanded(
                  child: _Amount(
                    label: l10n.economyYearsLabel(
                      smokingYears.toStringAsFixed(
                        smokingYears % 1 == 0 ? 0 : 1,
                      ),
                    ),
                    value: l10n.economyCigaretteCount(
                      NumberFormat.decimalPattern(locale)
                          .format(lifetimeCigarettes),
                    ),
                    color: HalenColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(width: HalenSpace.x3),
                Expanded(
                  child: _Amount(
                    label: l10n.economyTimeLost,
                    value: formatShortDuration(lifetimeTimeLost, locale),
                    color: HalenColors.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x4),
            _Equivalent(saved: lifetimeSpent),
            const SizedBox(height: HalenSpace.x4),
            Container(
              padding: const EdgeInsets.all(HalenSpace.x4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.economyPastSpentNote,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ] else ...[
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
          ],
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
    final picked = await showEconomyGoalDialog(
      context,
      l10n,
      initialLabel: widget.goal?.label,
      initialAmount: widget.goal?.amount,
    );
    if (picked == null) {
      return;
    }
    final (label, amount) = picked;
    await ref.read(databaseProvider).moduleDao.setSavingsGoal(
          label: label,
          amount: amount,
        );
  }
}

/// Validated savings-goal dialog (brain T6): keeps the dialog open with an
/// error hint until label is non-blank (≤100 chars) and amount is a finite,
/// positive number within the money bound. Never partial-writes.
Future<(String, double)?> showEconomyGoalDialog(
  BuildContext context,
  AppLocalizations l10n, {
  String? initialLabel,
  double? initialAmount,
}) async {
  final labelController =
      TextEditingController(text: initialLabel ?? '');
  final amountController = TextEditingController(
    text: initialAmount == null ? '' : initialAmount.toStringAsFixed(0),
  );
  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setLocal) {
        final label = InputBounds.name(labelController.text);
        final amount = double.tryParse(
          amountController.text.trim().replaceAll(',', '.'),
        );
        final ok = label != null && InputBounds.money(amount);
        final touched = labelController.text.isNotEmpty ||
            amountController.text.isNotEmpty;
        return AlertDialog(
          title: Text(l10n.economyGoalTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelController,
                maxLength: 100,
                decoration: InputDecoration(
                  labelText: l10n.economyGoalLabel,
                  counterText: '',
                ),
                textInputAction: TextInputAction.next,
                onChanged: (_) => setLocal(() {}),
              ),
              const SizedBox(height: HalenSpace.x3),
              TextField(
                controller: amountController,
                decoration:
                    InputDecoration(labelText: l10n.economyGoalAmount),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setLocal(() {}),
              ),
              if (touched && !ok) ...[
                const SizedBox(height: HalenSpace.x3),
                Text(
                  l10n.commonErrorTitle,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            FilledButton(
              onPressed:
                  ok ? () => Navigator.of(dialogContext).pop(true) : null,
              child: Text(l10n.commonSave),
            ),
          ],
        );
      },
    ),
  );
  final label = InputBounds.name(labelController.text);
  final amount =
      double.tryParse(amountController.text.trim().replaceAll(',', '.'));
  // Keep the controllers alive until the dialog has fully left the tree, then
  // dispose — matches the pack-edit dialog's lifecycle.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    labelController.dispose();
    amountController.dispose();
  });
  if (saved != true) {
    return null;
  }
  if (label == null || !InputBounds.money(amount)) {
    return null; // never write what the guard rejected
  }
  return (label, amount!);
}

