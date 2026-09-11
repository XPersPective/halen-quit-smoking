import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/module_providers.dart';
import '../../../application/pack_providers.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../data/db/app_database.dart';
import '../../../data/db/daos/pack_purchase_dao.dart';
import '../../../domain/pack_purchases.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/charts/halen_bar_chart.dart';
import '../../widgets/design/halen_components.dart';

/// Pack purchase history (device feedback, item 3).
///
/// When was a pack bought, how often, and what it has cost — computed from
/// what was actually paid rather than from a price typed in once at
/// onboarding. Recording a purchase also makes it the current pack, so the
/// rest of the app's money figures follow real prices.
class PurchasesScreen extends ConsumerWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final money = NumberFormat.simpleCurrency(locale: locale, decimalDigits: 0);
    final compact =
        NumberFormat.compactSimpleCurrency(locale: locale, decimalDigits: 0);
    final summary = ref.watch(purchaseSummaryProvider).value;
    final rows = ref.watch(packPurchaseRowsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.purchasesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddPurchaseSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.purchasesAdd),
      ),
      body: ListView(
        padding: HalenSpace.screen.copyWith(bottom: 96),
        children: [
          if (summary == null || summary.isEmpty)
            HalenCard(
              child: HalenEmptyState(
                icon: Icons.receipt_long_rounded,
                message: l10n.purchasesEmpty,
              ),
            )
          else ...[
            HalenCard(
              emphasis: CardEmphasis.raised,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: HalenStat(
                          label: l10n.purchasesThisMonth,
                          value: money.format(summary.thisMonth),
                          color: DataRole.money.of(context),
                          large: true,
                        ),
                      ),
                      const SizedBox(width: HalenSpace.x3),
                      Expanded(
                        child: HalenStat(
                          label: l10n.purchasesLastMonth,
                          value: money.format(summary.lastMonth),
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: HalenSpace.x4),
                  if (summary.averageDaysBetween != null)
                    Text(
                      l10n.purchasesEvery(
                        summary.averageDaysBetween!.toStringAsFixed(1),
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                  if (summary.monthlyRate != null) ...[
                    const SizedBox(height: HalenSpace.x1),
                    Text(
                      l10n.purchasesMonthlyRate(
                        money.format(summary.monthlyRate),
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: HalenSpace.x4),
            HalenCard(
              child: HalenBarChart(
                values: [for (final m in summary.months) m.total],
                labels: [
                  for (final m in summary.months)
                    DateFormat.MMM(locale).format(m.month),
                ],
                meaning: l10n.purchasesChartMeaning,
                axisCaption: l10n.purchasesChartAxis,
                color: DataRole.money.of(context),
                yFormatter: compact.format,
                semanticsLabel: l10n.purchasesChartTitle,
              ),
            ),
            const SizedBox(height: HalenSpace.x6),
            HalenSectionHeader(title: l10n.purchasesHistory),
            const SizedBox(height: HalenSpace.x2),
            for (final row in rows) _PurchaseRow(row: row, money: money),
          ],
        ],
      ),
    );
  }
}

class _PurchaseRow extends ConsumerWidget {
  const _PurchaseRow({required this.row, required this.money});

  final PackPurchaseRow row;
  final NumberFormat money;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    final purchase = row.toDomain();
    return Dismissible(
      key: ValueKey(row.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: HalenSpace.x5),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onSurfaceVariant),
      ),
      onDismissed: (_) {
        ref.read(packControllerProvider).removePurchase(row.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.purchasesDeleted)),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.inventory_2_outlined),
        title: Text(
          '${purchase.packs} × ${money.format(purchase.pricePerPack)}'
          '${purchase.brand == null ? '' : ' · ${purchase.brand}'}',
        ),
        subtitle: Text(DateFormat.yMMMd(locale).add_Hm().format(purchase.at)),
        trailing: Text(
          money.format(purchase.total),
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }
}

/// The add-a-purchase sheet, prefilled from the current pack so the common
/// case — same pack as last time — is one tap.
Future<void> showAddPurchaseSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AddPurchaseSheet(),
    );

class _AddPurchaseSheet extends ConsumerStatefulWidget {
  const _AddPurchaseSheet();

  @override
  ConsumerState<_AddPurchaseSheet> createState() => _AddPurchaseSheetState();
}

class _AddPurchaseSheetState extends ConsumerState<_AddPurchaseSheet> {
  late final TextEditingController _price;
  late final TextEditingController _size;
  late final TextEditingController _brand;
  int _packs = 1;
  DateTime _at = DateTime.now();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(smokingProfileProvider).value;
    _price = TextEditingController(
      text: profile == null ? '' : _trim(profile.pricePerPack),
    );
    _size = TextEditingController(text: '${profile?.packSize ?? 20}');
    _brand = TextEditingController(text: profile?.brandName ?? '');
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  void dispose() {
    _price.dispose();
    _size.dispose();
    _brand.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _at,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (date != null) {
      setState(() => _at = DateTime(date.year, date.month, date.day, now.hour, now.minute));
    }
  }

  Future<void> _save() async {
    final price = double.tryParse(_price.text.replaceAll(',', '.'));
    final size = int.tryParse(_size.text);
    if (price == null || price <= 0 || size == null || size <= 0) {
      return;
    }
    await ref.read(packControllerProvider).addPurchase(
          at: _at,
          packs: _packs,
          pricePerPack: price,
          packSize: size,
          brand: _brand.text,
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        HalenSpace.x5,
        0,
        HalenSpace.x5,
        MediaQuery.of(context).viewInsets.bottom + HalenSpace.x6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.purchasesAdd, style: theme.textTheme.titleLarge),
          const SizedBox(height: HalenSpace.x4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.purchasesDate),
            subtitle: Text(DateFormat.yMMMd(locale).format(_at)),
            onTap: _pickDate,
          ),
          Row(
            children: [
              Expanded(child: Text(l10n.purchasesPacks)),
              IconButton(
                onPressed: _packs > 1 ? () => setState(() => _packs--) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_packs', style: theme.textTheme.titleMedium),
              IconButton(
                onPressed: () => setState(() => _packs++),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x2),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _price,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l10n.purchasesPrice),
                ),
              ),
              const SizedBox(width: HalenSpace.x3),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: _size,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: l10n.purchasesPackSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          TextField(
            controller: _brand,
            decoration: InputDecoration(labelText: l10n.purchasesBrand),
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(l10n.purchasesUpdatesPack, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x5),
          FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
  }
}

/// The summary maths lives in the domain; this is only a type alias so the
/// screen's imports stay one line.
typedef Summary = PurchaseSummary;
