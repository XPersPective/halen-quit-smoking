import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings_screen_controller.dart';
import '../../core/design/tokens.dart';
import '../../l10n/generated/app_localizations.dart';

/// Honest notification status (brain T2): the card always shows what the OS
/// reports, on first open and on every resume from system settings — never
/// what we merely stored. Denial keeps the explanation and the settings
/// shortcut; nothing else in the app depends on the answer.
class NotificationPermissionCard extends ConsumerStatefulWidget {
  const NotificationPermissionCard({super.key});

  @override
  ConsumerState<NotificationPermissionCard> createState() =>
      _NotificationPermissionCardState();
}

class _NotificationPermissionCardState
    extends ConsumerState<NotificationPermissionCard>
    with WidgetsBindingObserver {
  bool? _granted;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _refresh() async {
    final granted =
        await ref.read(notificationServiceProvider).isPermissionGranted();
    if (mounted) {
      setState(() => _granted = granted);
    }
  }

  Future<void> _ask() async {
    final service = ref.read(notificationServiceProvider);
    final granted = await service.requestPermission();
    if (!mounted) {
      return;
    }
    setState(() => _granted = granted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_granted == true)
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: HalenSpace.x2),
                  Expanded(
                    child: Text(
                      l10n.notifPermissionOn,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            else ...[
              Text(l10n.splashNotificationRationale),
              const SizedBox(height: HalenSpace.x2),
              Text(l10n.notifPermissionOffExplainer,
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: HalenSpace.x3),
              FilledButton.icon(
                onPressed: _granted == null ? null : _ask,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: const Icon(Icons.notifications_outlined),
                label: Text(l10n.splashEnableNotifications),
              ),
              TextButton.icon(
                onPressed: () => ref
                    .read(notificationServiceProvider)
                    .openSystemSettings(),
                icon: const Icon(Icons.settings_outlined, size: 18),
                label: Text(l10n.notifOpenSystemSettings),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
