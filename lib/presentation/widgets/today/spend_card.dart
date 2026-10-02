import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/module_providers.dart';
import '../../../core/dates.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../design/halen_components.dart';

/// What smoking costs, near the top of the home screen.
///
/// Owner request (2026-10-02): "10 years at 20 a day — how much money is
/// that?" belongs where the user lands, not two screens deep. The big number
/// is the all-time total (declared history + everything logged since); the
/// row below it is today / 7 days / 30 days / 12 months of RECORDED spend.
/// When the user never said how long they have smoked, it asks instead of
/// inventing a number.
class SpendCard extends ConsumerWidget {
  const SpendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(spendSummaryProvider).value;
    if (summary == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final money = NumberFormat.currency(locale: locale, decimalDigits: 0);
    final cents = NumberFormat.currency(locale: locale, decimalDigits: 2);
    final lifetime = summary.lifetimeTotal;
    final time = summary.lifetimeTimeSmoking;
    final years = summary.declaredCigarettes == null
        ? null
        : summary.declaredCigarettes! / 365.25;

    return HalenCard(
      onTap: () => Navigator.pushNamed(context, Routes.economy),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.spendCardTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: HalenSpace.x3),
          if (lifetime != null) ...[
            Text(
              l10n.spendLifetimeLabel,
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            Text(
              money.format(lifetime),
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (time != null)
              Padding(
                padding: const EdgeInsets.only(top: HalenSpace.x1),
                child: Text(
                  l10n.spendTimeSmoking(formatShortDuration(
                    time,
                    Localizations.localeOf(context).languageCode,
                  )),
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ] else
            Text(l10n.spendAskYears, style: theme.textTheme.bodyMedium),
          const SizedBox(height: HalenSpace.x4),
          Row(
            children: [
              _Cell(l10n.spendToday, money.format(summary.today)),
              _Cell(l10n.spend7d, money.format(summary.week)),
              _Cell(l10n.spend30d, money.format(summary.month)),
              _Cell(l10n.spend12m, money.format(summary.year)),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(
            [
              l10n.spendTodayLine(
                summary.todayCount,
                money.format(summary.today),
              ),
              l10n.spendPerCigarette(cents.format(summary.perCigarette)),
              if (years != null)
                l10n.spendLifetimeBasis(
                  years.toStringAsFixed(years % 1 == 0 ? 0 : 1),
                  (summary.declaredCigarettes! / (years * 365.25)).round(),
                ),
            ].join(' · '),
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: HalenSpace.x1),
          Text(
            l10n.spendRecordedNote,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
