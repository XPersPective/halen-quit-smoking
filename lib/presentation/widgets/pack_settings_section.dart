import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/module_providers.dart';
import '../../application/pack_providers.dart';
import '../../core/design/tokens.dart';
import '../../domain/tar_intake.dart';
import '../../l10n/generated/app_localizations.dart';
import '../screens/purchases/purchases_screen.dart';
import 'design/halen_components.dart';

/// "My pack", in Settings (device feedback, item 2).
///
/// Price, pack size and brand were asked once at onboarding and could never
/// be reached again. A person who bought a different pack today had no way
/// to tell the app. This section shows the current pack, edits it in place,
/// and adds the two label values the tar figures are computed from.
class PackSettingsSection extends ConsumerWidget {
  const PackSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final money = NumberFormat.simpleCurrency(locale: locale);
    final profile = ref.watch(smokingProfileProvider).value;
    if (profile == null) {
      return const SizedBox.shrink();
    }
    final intake = ref.watch(tarIntakeProvider);

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(
            title: l10n.packTitle,
            trailing: TextButton(
              onPressed: () => _edit(context, ref),
              child: Text(l10n.commonEdit),
            ),
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(
            [
              if (profile.brandName != null) profile.brandName!,
              '${money.format(profile.pricePerPack)} / ${profile.packSize}',
            ].join(' · '),
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: HalenSpace.x1),
          Text(
            l10n.packLabelLine(
              _fmt(intake.tarMgPerCigarette),
              _fmt(intake.nicotineMgPerCigarette),
            ),
            style: theme.textTheme.bodySmall,
          ),
          if (intake.usesLegalMaximum) ...[
            const SizedBox(height: HalenSpace.x1),
            Text(l10n.packLabelDefaulted, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: HalenSpace.x2),
          // Its own transparent Material: HalenCard paints a coloured
          // DecoratedBox, and a ListTile inside one draws its ink splash
          // underneath it, where nobody can see the tap land.
          Material(
            type: MaterialType.transparency,
            child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(l10n.purchasesTitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const PurchasesScreen()),
            ),
          ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.read(smokingProfileProvider).value;
    if (profile == null) {
      return;
    }
    final price = TextEditingController(text: _fmt(profile.pricePerPack));
    final size = TextEditingController(text: '${profile.packSize}');
    final brand = TextEditingController(text: profile.brandName ?? '');
    final tar = TextEditingController(
      text: profile.tarMgPerCigarette == null ? '' : _fmt(profile.tarMgPerCigarette!),
    );
    final nicotine = TextEditingController(
      text: profile.nicotineMgPerCigarette == null
          ? ''
          : _fmt(profile.nicotineMgPerCigarette!),
    );
    double? parse(TextEditingController c) =>
        double.tryParse(c.text.trim().replaceAll(',', '.'));

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.packTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: brand,
                decoration: InputDecoration(labelText: l10n.purchasesBrand),
              ),
              const SizedBox(height: HalenSpace.x3),
              TextField(
                controller: price,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.purchasesPrice),
              ),
              const SizedBox(height: HalenSpace.x3),
              TextField(
                controller: size,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.purchasesPackSize),
              ),
              const SizedBox(height: HalenSpace.x3),
              TextField(
                controller: tar,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.packTar,
                  hintText: _fmt(LabelLimits.tarMg),
                ),
              ),
              const SizedBox(height: HalenSpace.x3),
              TextField(
                controller: nicotine,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.packNicotine,
                  hintText: _fmt(LabelLimits.nicotineMg),
                ),
              ),
              const SizedBox(height: HalenSpace.x3),
              Text(l10n.packLabelHint),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );

    if (saved == true) {
      final newPrice = parse(price);
      final newSize = int.tryParse(size.text.trim());
      if (newPrice != null && newPrice > 0 && newSize != null && newSize > 0) {
        await ref.read(packControllerProvider).updatePack(
              pricePerPack: newPrice,
              packSize: newSize,
              brand: brand.text,
              tarMgPerCigarette: parse(tar),
              nicotineMgPerCigarette: parse(nicotine),
            );
      }
    }
    for (final c in [price, size, brand, tar, nicotine]) {
      c.dispose();
    }
  }
}
