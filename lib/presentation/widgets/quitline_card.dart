import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/country_providers.dart';
import '../../core/design/tokens.dart';
import '../../data/quitline_directory.dart';
import '../../l10n/generated/app_localizations.dart';
import 'country_picker.dart';

/// Regional support, not emergency services.
///
/// The user picks their country from a searchable list of every country; the
/// choice is saved and shared with currency and donations. The phone's region
/// is only ever a one-tap suggestion — nothing is assumed (owner, 2026-10-02:
/// the card kept showing Türkiye after switching the language). Numbers come
/// from [quitlinesByCountry] (WHO list + national services); a country
/// without a verified line says so and points to the WHO directory.
class QuitlineCard extends ConsumerWidget {
  const QuitlineCard({super.key});

  Future<void> _call(
    BuildContext context,
    String number,
    String unavailable,
  ) async {
    try {
      if (await launchUrl(Uri(scheme: 'tel', path: number))) return;
    } catch (_) {
      // A tablet/emulator may not have a dialer; keep the number accessible.
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$unavailable $number')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final directory = ref.watch(countryDirectoryProvider).value;
    final selected = ref.watch(countryCodeProvider);
    final detected = ref.watch(detectedCountryProvider);
    final chain = countryNameChain(context);

    String nameOf(String code) => directory?.nameOf(code, chain) ?? code;

    Future<void> choose() async {
      final code = await pickCountry(context);
      if (code != null) {
        await ref.read(setCountryProvider)(code);
      }
    }

    final lines = selected == null
        ? const <QuitLine>[]
        : (quitlinesByCountry[selected] ?? const <QuitLine>[]);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.helplineTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: HalenSpace.x2),
            Text(l10n.quitlineHint),
            const SizedBox(height: HalenSpace.x3),
            OutlinedButton.icon(
              onPressed: choose,
              icon: const Icon(Icons.public_rounded),
              label: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  selected == null
                      ? l10n.quitlineChooseCountry
                      : nameOf(selected),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            if (selected == null && detected != null) ...[
              const SizedBox(height: HalenSpace.x2),
              TextButton(
                onPressed: () => ref.read(setCountryProvider)(detected),
                child: Text(l10n.quitlineUseDetected(nameOf(detected))),
              ),
            ],
            if (selected != null && lines.isEmpty) ...[
              const SizedBox(height: HalenSpace.x3),
              Text(l10n.quitlineNoneForCountry(nameOf(selected))),
              TextButton.icon(
                onPressed: () => launchUrl(
                  Uri.parse(whoQuitlineDirectoryUrl),
                  mode: LaunchMode.externalApplication,
                ),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(l10n.quitlineWhoDirectory),
              ),
            ],
            for (final line in lines) ...[
              const SizedBox(height: HalenSpace.x3),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () =>
                    _call(context, line.number, l10n.quitlineUnavailable),
                icon: const Icon(Icons.call),
                label: Text(
                  '${line.label ?? l10n.quitlineGeneric} · ${line.display}',
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: line.number)),
                icon: const Icon(Icons.copy, size: 18),
                label: Text(l10n.quitlineCopy),
              ),
            ],
            if (lines.isNotEmpty) ...[
              const SizedBox(height: HalenSpace.x2),
              Text(
                l10n.quitlineSourceNote,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
