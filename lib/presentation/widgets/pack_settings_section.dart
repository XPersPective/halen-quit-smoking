import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/module_providers.dart';
import '../../application/pack_providers.dart';
import '../../core/design/tokens.dart';
import '../../domain/input_bounds.dart';
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
    final saved = await showDialog<PackEditResult?>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return StatefulBuilder(
          builder: (context, setLocal) {
            // Blank optional chemistry reads as "unsure" (null is legal),
            // but typed garbage must disable Save — never silently vanish.
            double? numOrNull(String raw) => raw.trim().isEmpty
                ? null
                : double.tryParse(raw.trim().replaceAll(',', '.'));
            final p = numOrNull(price.text);
            final sz = int.tryParse(size.text.trim());
            final t = numOrNull(tar.text);
            final n = numOrNull(nicotine.text);
            bool typedBad(String raw) =>
                raw.trim().isNotEmpty && numOrNull(raw) == null;
            final b = InputBounds.name(brand.text);
            final ok = InputBounds.money(p) &&
                InputBounds.packSize(sz) &&
                InputBounds.tarMg(t) &&
                InputBounds.nicotineMg(n) &&
                !typedBad(price.text) &&
                !typedBad(tar.text) &&
                !typedBad(nicotine.text) &&
                RegExp(r'^[0-9]+$').hasMatch(size.text.trim());
            return AlertDialog(
              title: Text(l10n.packTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: brand,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: l10n.purchasesBrand,
                        counterText: '',
                      ),
                      onChanged: (_) => setLocal(() {}),
                    ),
                    const SizedBox(height: HalenSpace.x3),
                    _numField(price, l10n.purchasesPrice, setLocal),
                    const SizedBox(height: HalenSpace.x3),
                    _numField(size, l10n.purchasesPackSize, setLocal,
                        integer: true),
                    const SizedBox(height: HalenSpace.x3),
                    _numField(tar, l10n.packTar, setLocal,
                        hint: _fmt(LabelLimits.tarMg)),
                    const SizedBox(height: HalenSpace.x3),
                    _numField(nicotine, l10n.packNicotine, setLocal,
                        hint: _fmt(LabelLimits.nicotineMg)),
                    const SizedBox(height: HalenSpace.x3),
                    Text(l10n.packLabelHint),
                    if (!ok) ...[
                      const SizedBox(height: HalenSpace.x3),
                      Text(
                        l10n.commonErrorTitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(l10n.commonCancel),
                ),
                FilledButton(
                  onPressed: ok
                      ? () => Navigator.of(dialogContext).pop(
                            PackEditResult(
                              pricePerPack: p!,
                              packSize: sz!,
                              brand: b,
                              tarMgPerCigarette: t,
                              nicotineMgPerCigarette: n,
                            ),
                          )
                      : null,
                  child: Text(l10n.commonSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != null) {
      await ref.read(packControllerProvider).updatePack(
            pricePerPack: saved.pricePerPack,
            packSize: saved.packSize,
            brand: saved.brand,
            tarMgPerCigarette: saved.tarMgPerCigarette,
            nicotineMgPerCigarette: saved.nicotineMgPerCigarette,
          );
    }
    // Defer disposal until the dismissed dialog has fully left the tree:
    // its tap targets still rebuild during the exit animation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in [price, size, brand, tar, nicotine]) {
        c.dispose();
      }
    });
  }


  Widget _numField(
    TextEditingController c,
    String label,
    StateSetter setLocal, {
    bool integer = false,
    String? hint,
  }) {
    return TextField(
      controller: c,
      keyboardType: integer
          ? TextInputType.number
          : const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, hintText: hint),
      onChanged: (_) => setLocal(() {}),
    );
  }
}

/// What the pack-edit dialog returns once every field passes
/// [InputBounds]; the save path writes exactly these values, it never
/// re-parses text that could have shifted after the pop.
class PackEditResult {
  const PackEditResult({
    required this.pricePerPack,
    required this.packSize,
    required this.brand,
    required this.tarMgPerCigarette,
    required this.nicotineMgPerCigarette,
  });

  final double pricePerPack;
  final int packSize;
  final String? brand;
  final double? tarMgPerCigarette;
  final double? nicotineMgPerCigarette;
}
