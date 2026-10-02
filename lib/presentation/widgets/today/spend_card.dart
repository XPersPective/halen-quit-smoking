import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../application/providers.dart';
import '../../../data/db/app_database.dart';
import '../../../core/dates.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../design/halen_components.dart';
import '../../../application/money.dart';

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

  /// Years smoked, typed inline: the lifetime total needs it, and sending
  /// people to Settings to find it meant most never would.
  Future<void> _askYears(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final years = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.spendYearsDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.settingsSmokingYears,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(
                controller.text.trim().replaceAll(',', '.'),
              );
              if (value != null && value >= 0 && value <= 80) {
                Navigator.of(ctx).pop(value);
              }
            },
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    controller.dispose();
    if (years == null) {
      return;
    }
    await ref.read(databaseProvider).profileDao.saveSmokingProfile(
          SmokingProfileCompanion(smokingYears: Value(years)),
        );
    ref.invalidate(smokingProfileProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(spendSummaryProvider).value;
    if (summary == null) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final formats = ref.watch(moneyFormatsProvider(locale));
    final money = formats.whole;
    final cents = formats.precise;
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
          ] else ...[
            Text(l10n.spendAskYears, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HalenSpace.x2),
            FilledButton.tonal(
              onPressed: () => _askYears(context, ref),
              child: Text(l10n.spendYearsAction),
            ),
          ],
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
