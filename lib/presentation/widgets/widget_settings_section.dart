import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../application/providers.dart';
import '../../application/quick_log_controller.dart';
import '../../application/settings_screen_controller.dart';
import '../../core/design/tokens.dart';
import '../../data/db/app_database.dart';
import '../../l10n/generated/app_localizations.dart';

/// Home-screen widget customisation (brain T7): add-instructions, a live
/// preview of the chosen look, and two real preferences that are pushed to
/// the native widget stores immediately.
class WidgetSettingsSection extends ConsumerWidget {
  const WidgetSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).value;
    if (settings == null) {
      return const SizedBox.shrink();
    }

    final themeChoice = settings.widgetTheme;
    final darkPreview = switch (themeChoice) {
      'dark' => true,
      'light' => false,
      _ => theme.brightness == Brightness.dark,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.settingsWidget, style: theme.textTheme.titleMedium),
        const SizedBox(height: HalenSpace.x2),
        Text(l10n.widgetHowToAdd, style: theme.textTheme.bodySmall),
        const SizedBox(height: HalenSpace.x3),

        // Live preview: same colours the native surface will paint.
        Semantics(
          label: l10n.settingsWidget,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: HalenSpace.x4,
              vertical: HalenSpace.x3,
            ),
            decoration: BoxDecoration(
              color: darkPreview
                  ? const Color(0xFF1E4D45)
                  : const Color(0xFFF6F4EE),
              borderRadius: BorderRadius.circular(HalenRadius.medium),
            ),
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(
                color: darkPreview
                    ? Colors.white
                    : const Color(0xFF1C1B16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halen',
                      style: TextStyle(
                        fontSize: 12,
                        color: darkPreview
                            ? Colors.white.withValues(alpha: 0.8)
                            : const Color(0x99000000),
                      )),
                  const SizedBox(height: HalenSpace.x1),
                  Text('4/8', style: theme.textTheme.titleLarge?.copyWith(
                    color: darkPreview
                        ? Colors.white
                        : const Color(0xFF1C1B16),
                    fontWeight: FontWeight.w700,
                  )),
                  if (settings.widgetShowLastCigarette)
                    Text('· 1h 12m',
                        style: TextStyle(
                          fontSize: 13,
                          color: darkPreview
                              ? Colors.white.withValues(alpha: 0.8)
                              : const Color(0x99000000),
                        )),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: HalenSpace.x2),

        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: settings.widgetShowLastCigarette,
          title: Text(l10n.widgetShowLast),
          onChanged: (on) async {
            await ref.read(databaseProvider).settingsDao.updateSettings(
                  SettingsCompanion(widgetShowLastCigarette: Value(on)),
                );
            await ref.read(widgetServiceProvider).applyWidgetPrefs();
          },
        ),
        InputDecorator(
          decoration: InputDecoration(
            labelText: l10n.widgetTheme,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(
                value: 'system',
                label: Text(l10n.themeSystem),
              ),
              ButtonSegment(value: 'light', label: Text(l10n.themeLight)),
              ButtonSegment(value: 'dark', label: Text(l10n.themeDark)),
            ],
            selected: {themeChoice},
            onSelectionChanged: (s) async {
              await ref.read(databaseProvider).settingsDao.updateSettings(
                    SettingsCompanion(widgetTheme: Value(s.first)),
                  );
              await ref.read(widgetServiceProvider).applyWidgetPrefs();
            },
          ),
        ),
      ],
    );
  }
}
