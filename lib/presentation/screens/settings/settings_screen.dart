import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/notification_texts.dart';
import 'package:halen/application/plan_controller.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/application/settings_controller.dart';
import 'package:halen/application/settings_screen_controller.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/data/db/app_database.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/model_settings_section.dart';
import 'package:halen/presentation/widgets/notification_permission_card.dart';
import 'package:halen/presentation/widgets/widget_settings_section.dart';
import 'package:halen/presentation/widgets/pack_settings_section.dart';
import 'package:halen/presentation/widgets/quitline_card.dart';
import '../../../core/design/tokens.dart';

/// Reads a JSON backup chosen by the user (file picker stays local-only).
Future<Map<String, dynamic>> _pickAndReadJson() async {
  const typeGroup = XTypeGroup(label: 'JSON', extensions: ['json']);
  final file = await openFile(acceptedTypeGroups: [typeGroup]);
  if (file == null) {
    throw const FormatException('No file selected');
  }
  final decoded = jsonDecode(await file.readAsString());
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Invalid backup');
  }
  return decoded;
}

/// Screen 14: Settings — notifications (density + types + exact opt-in),
/// appearance, data (phase 12), purchase (phase 10) and the mandatory
/// health/legal block (report §39).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final densityLabels = {
      NotificationDensity.calm: l10n.notifDensityCalm,
      NotificationDensity.standard: l10n.notifDensityStandard,
      NotificationDensity.intense: l10n.notifDensityIntense,
      NotificationDensity.off: l10n.notifDensityOff,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: settingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.commonErrorTitle)),
          data: (settings) => ListView(
            padding: const EdgeInsets.all(HalenSpace.x6),
            children: [
              Text(l10n.settingsNotifications,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: HalenSpace.x2),
              // OS truth first: granted/denied + settings shortcut, re-read
              // on every resume (brain T2).
              const NotificationPermissionCard(),
              const SizedBox(height: HalenSpace.x3),
              Wrap(
                spacing: HalenSpace.x2,
                runSpacing: HalenSpace.x2,
                children: [
                  for (final entry in densityLabels.entries)
                    ChoiceChip(
                      label: Text(entry.value),
                      selected: settings.notifLevel == entry.key,
                      onSelected: (selected) async {
                        if (!selected) return;
                        final density = entry.key;
                        final localeCode =
                            Localizations.localeOf(context).languageCode;
                        await updateSetting(
                          ref,
                          SettingsCompanion(notifLevel: Value(density)),
                        );
                        if (density != NotificationDensity.off) {
                          await ref
                              .read(notificationServiceProvider)
                              .requestPermission();
                        }
                        await ref
                            .read(notificationServiceProvider)
                            .applyDensity(
                              density,
                              texts: notificationTextsFor(localeCode),
                            );
                      },
                    ),
                ],
              ),
              // Planned-time reminders default OFF (report §20: spam risk).
              SwitchListTile(
                value: false,
                onChanged: null,
                title: Text(l10n.notifPlanReminder),
              ),
              // The trial nudge is a marketing reminder, so it has its own
              // preference — never implied by the density choice (brain T2).
              SwitchListTile(
                value: settings.trialNudge,
                title: Text(l10n.notifTrialNudge),
                subtitle: Text(l10n.notifTrialNudgeHint),
                onChanged: (on) async {
                  final service = ref.read(notificationServiceProvider);
                  final texts = notificationTextsFor(
                    Localizations.localeOf(context).languageCode,
                  );
                  await updateSetting(
                    ref,
                    SettingsCompanion(trialNudge: Value(on)),
                  );
                  final startedAt = settings.trialStartedAt;
                  if (on && startedAt != null) {
                    await service.scheduleTrialReminder(
                      trialStartedAt: startedAt,
                      texts: texts,
                    );
                  } else {
                    await service.cancelTrialReminder();
                  }
                },
              ),
              const SizedBox(height: HalenSpace.x4),
              Text(l10n.settingsAppearance,
                  style: theme.textTheme.titleMedium),
              SegmentedButton<ThemeOption>(
                segments: [
                  ButtonSegment(
                    value: ThemeOption.system,
                    label: Text(l10n.themeSystem),
                  ),
                  ButtonSegment(
                    value: ThemeOption.light,
                    label: Text(l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeOption.dark,
                    label: Text(l10n.themeDark),
                  ),
                ],
                selected: {settings.theme},
                onSelectionChanged: (selection) {
                  ref.read(themeOptionProvider.notifier).set(selection.first);
                  updateSetting(
                    ref,
                    SettingsCompanion(theme: Value(selection.first)),
                  );
                },
              ),
              const SizedBox(height: HalenSpace.x4),
              // UI language: system by default, with explicit overrides.
              // Labels are the native names, untranslated by design.
              Text(l10n.settingsLanguage, style: theme.textTheme.titleMedium),
              RadioGroup<String>(
                groupValue: settings.appLocale ?? 'system',
                onChanged: (value) => updateSetting(
                  ref,
                  SettingsCompanion(
                    appLocale:
                        value == null || value == 'system'
                            ? const Value(null)
                            : Value(value),
                  ),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      value: 'system',
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.languageSystem),
                    ),
                    RadioListTile<String>(
                      value: 'en',
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.languageEn),
                    ),
                    RadioListTile<String>(
                      value: 'tr',
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.languageTr),
                    ),
                    RadioListTile<String>(
                      value: 'de',
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.languageDe),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                value: settings.reduceMotion,
                onChanged: (v) => updateSetting(
                  ref,
                  SettingsCompanion(reduceMotion: Value(v)),
                ),
                title: Text(l10n.settingsReduceMotion),
              ),
              SwitchListTile(
                value: settings.haptics,
                onChanged: (v) => updateSetting(
                  ref,
                  SettingsCompanion(haptics: Value(v)),
                ),
                title: Text(l10n.settingsHaptics),
              ),
              const SizedBox(height: HalenSpace.x4),
              // Item 2: the pack is editable after onboarding at last, and
              // purchases are one tap away.
              const PackSettingsSection(),
              const SizedBox(height: HalenSpace.x4),
              // Module report §1/§12/§14 — the dials the models expose to the
              // user, each optional and each explained.
              ModelSettingsSection(
                preLogPauseSeconds: settings.preLogPauseSeconds,
                riskyWindowReminder: settings.riskyWindowReminder,
              ),
              const SizedBox(height: HalenSpace.x4),
              // Widget customisation is real: both choices land in the native
              // widget store, not just in the DB (brain T7).
              const WidgetSettingsSection(),
              const SizedBox(height: HalenSpace.x4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(l10n.glossaryOpen),
                onTap: () => Navigator.pushNamed(context, Routes.glossary),
              ),
              const SizedBox(height: HalenSpace.x2),
              Text(l10n.settingsData, style: theme.textTheme.titleMedium),
              ListTile(
                leading: const Icon(Icons.file_download_outlined),
                title: Text(l10n.settingsExport),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final path = await ref
                      .read(backupRepositoryProvider)
                      .exportToFile();
                  // No upload — the file simply lands in the user-visible
                  // documents folder (report §26).
                  messenger.showSnackBar(
                    SnackBar(content: Text(l10n.settingsExportDone(path))),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_upload_outlined),
                title: Text(l10n.settingsImport),
                onTap: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.settingsImport),
                      content: Text(l10n.deleteAllConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l10n.commonCancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(l10n.commonOk),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) {
                    return;
                  }
                  try {
                    final content = await _pickAndReadJson();
                    final events = await ref
                        .read(backupRepositoryProvider)
                        .importFromJson(content);
                    ref.invalidate(todayStateProvider);
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.settingsImportDone(events))),
                    );
                  } catch (_) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.commonErrorTitle)),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.settingsDeleteAll),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.settingsDeleteAll),
                      content: Text(l10n.deleteAllConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l10n.commonCancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(l10n.commonOk),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    await ref.read(backupRepositoryProvider).wipeAllUserData();
                    ref.invalidate(todayStateProvider);
                  }
                },
              ),
              const SizedBox(height: HalenSpace.x4),
              Text(l10n.settingsAbout, style: theme.textTheme.titleMedium),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(l10n.settingsPurchase),
                subtitle: Text(l10n.purchaseCopy),
                onTap: () => Navigator.pushNamed(context, Routes.paywall),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: Text(l10n.timelineTitle),
                onTap: () =>
                    Navigator.pushNamed(context, Routes.healthTimeline),
              ),
              const SizedBox(height: HalenSpace.x2),
              // Mandatory health notice + helplines (report §39).
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(HalenSpace.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.settingsDisclaimerTitle,
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: HalenSpace.x1),
                      Text(l10n.settingsDisclaimer),
                      const SizedBox(height: HalenSpace.x2),
                      const QuitlineCard(),
                      const SizedBox(height: HalenSpace.x1),
                      Text(l10n.settingsPrivacy),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: HalenSpace.x6),
            ],
          ),
        ),
      ),
    );
  }
}
