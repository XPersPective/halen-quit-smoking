import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/design/tokens.dart';
import '../../l10n/generated/app_localizations.dart';

/// Regional support, not emergency services. Sources checked 2026-09-16:
/// alo171.saglik.gov.tr, yedam.org.tr, cdc.gov (1-800-784-8669),
/// rauchfrei-info.de, nhs.uk (England 0300 123 1044, Scotland 0800 84 84 84,
/// Wales 0800 085 2219). Old "Yeşilay 176" lines are removed.
class QuitlineCard extends StatefulWidget {
  const QuitlineCard({super.key});

  @override
  State<QuitlineCard> createState() => _QuitlineCardState();
}

class _QuitlineCardState extends State<QuitlineCard> {
  static const _key = 'quitlineRegion';
  static const _lines = {
    'TR': [('ALO 171', '171'), ('YEDAM', '115')],
    'US': [('1-800-QUIT-NOW', '18007848669')],
    'DE': [('BIÖG rauchfrei', '08008313131')],
    'GB-ENG': [('NHS Smokefree', '03001231044')],
    'GB-SCT': [('Quit Your Way', '0800848484')],
    'GB-WLS': [('Help Me Quit', '08000852219')],
    'other': <(String, String)>[],
  };
  String? _region;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    String? saved;
    try {
      saved = (await SharedPreferences.getInstance()).getString(_key);
    } catch (_) {
      // Preference storage is optional; never block access to support.
    }
    if (!mounted) return;
    final country =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode;
    setState(() {
      _region = _lines.containsKey(saved)
          ? saved
          : (_lines.containsKey(country) ? country : null);
      _ready = true;
    });
  }

  Future<void> _choose(String? value) async {
    setState(() => _region = value);
    try {
      await (await SharedPreferences.getInstance()).setString(_key, value!);
    } catch (_) {
      // The selection still works for this screen when storage is unavailable.
    }
  }

  Future<void> _call(String number, String unavailable) async {
    try {
      if (await launchUrl(Uri(scheme: 'tel', path: number))) return;
    } catch (_) {
      // A tablet/emulator may not have a dialer; keep the number accessible.
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$unavailable $number')));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countries = [
      l10n.quitlineTR,
      l10n.quitlineUS,
      l10n.quitlineDE,
      l10n.quitlineEngland,
      l10n.quitlineScotland,
      l10n.quitlineWales,
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.helplineTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: HalenSpace.x2),
            Text(l10n.quitlineHint),
            const SizedBox(height: HalenSpace.x3),
            if (_ready)
              DropdownButtonFormField<String>(
                key: ValueKey(_region),
                initialValue: _region,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.quitlineRegion),
                items: [
                  for (final entry in _lines.keys.indexed)
                    DropdownMenuItem(
                      value: entry.$2,
                      child: Text(
                        entry.$2 == 'other'
                            ? l10n.quitlineOther
                            : countries[entry.$1],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: _choose,
              ),
            for (final line in _lines[_region] ?? <(String, String)>[]) ...[
              const SizedBox(height: HalenSpace.x3),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => _call(line.$2, l10n.quitlineUnavailable),
                icon: const Icon(Icons.call),
                label: Text('${line.$1} · ${line.$2}'),
              ),
              TextButton.icon(
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: line.$2)),
                icon: const Icon(Icons.copy, size: 18),
                label: Text(l10n.quitlineCopy),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
