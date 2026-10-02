import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/design/tokens.dart';
import '../../../data/other_apps_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';
import '../shell_screen.dart';

/// Halen's own Android package; the catalogue never lists the app itself.
const String halenPackage = 'com.crazypenguin.halenquitsmoking';

/// "Discover our other apps": the family catalogue from GitHub
/// (napp_apps/apps.json), cached for a day, with an embedded fallback.
///
/// Promotion only: opening a store page earns nothing, and nothing here is
/// fetched until the person opens this tab.
class OtherAppsScreen extends StatefulWidget {
  const OtherAppsScreen({
    super.key,
    this.embedded = true,
    this.repository,
  });

  /// True inside the bottom-navigation shell (shows the settings shortcut).
  final bool embedded;

  /// Injectable for tests; defaults to the live catalogue.
  final OtherAppsRepository? repository;

  @override
  State<OtherAppsScreen> createState() => _OtherAppsScreenState();
}

class _OtherAppsScreenState extends State<OtherAppsScreen> {
  late final Future<List<OtherApp>> _apps =
      (widget.repository ?? OtherAppsRepository()).load(
    ownPackage: halenPackage,
  );

  Future<void> _open(OtherApp app, String failed) async {
    var ok = false;
    try {
      ok = await launchUrl(app.storeUri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.otherAppsTitle),
        actions: widget.embedded ? const [ShellSettingsButton()] : null,
      ),
      body: SafeArea(
        child: FutureBuilder<List<OtherApp>>(
          future: _apps,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final apps = snapshot.data ?? const <OtherApp>[];
            return ListView(
              padding: const EdgeInsets.all(HalenSpace.x5),
              children: [
                Text(l10n.otherAppsIntro, style: theme.textTheme.bodyMedium),
                const SizedBox(height: HalenSpace.x4),
                if (apps.isEmpty)
                  HalenEmptyState(
                    icon: Icons.apps_rounded,
                    message: l10n.otherAppsEmpty,
                  ),
                for (final app in apps) ...[
                  HalenCard(
                    onTap: () => _open(app, l10n.otherAppsOpenFailed),
                    child: Row(
                      children: [
                        _Icon(url: app.iconUrl),
                        const SizedBox(width: HalenSpace.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                OtherApp.pick(app.name, lang),
                                style: theme.textTheme.titleMedium,
                              ),
                              if (OtherApp.pick(app.description, lang)
                                  .isNotEmpty) ...[
                                const SizedBox(height: HalenSpace.x1),
                                Text(
                                  OtherApp.pick(app.description, lang),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                              const SizedBox(height: HalenSpace.x2),
                              Text(
                                l10n.otherAppsOpenStore,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new_rounded, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: HalenSpace.x3),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.apps_rounded),
    );
    if (url == null) {
      return fallback;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url!,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
      ),
    );
  }
}
