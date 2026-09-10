import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/providers.dart';
import '../../data/db/app_database.dart';
import '../../domain/body_load_model.dart';
import '../../domain/economy.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../core/design/tokens.dart';

/// Model settings (module report §1.⑤, §12.③, §14.2).
///
/// Three user-owned dials, each with the same promise attached: nothing here
/// is a measurement and nothing here is required. Clearance pace only
/// calibrates a curve, the pre-log pause never blocks a record, and body data
/// is optional — the Harm Load renormalizes its weights without it rather
/// than penalizing anyone for leaving it blank.
class ModelSettingsSection extends ConsumerStatefulWidget {
  const ModelSettingsSection({
    super.key,
    required this.preLogPauseSeconds,
    required this.riskyWindowReminder,
  });

  final int preLogPauseSeconds;
  final bool riskyWindowReminder;

  @override
  ConsumerState<ModelSettingsSection> createState() =>
      _ModelSettingsSectionState();
}

class _ModelSettingsSectionState extends ConsumerState<ModelSettingsSection> {
  /// Writes just the touched fields — saveSmokingProfile updates in place, so
  /// a partial companion leaves everything else untouched.
  Future<void> _updateProfile(SmokingProfileCompanion companion) async {
    final db = ref.read(databaseProvider);
    if (await db.profileDao.getSmokingProfile() == null) {
      return;
    }
    await db.profileDao.saveSmokingProfile(companion);
    ref.invalidate(smokingProfileProvider);
    ref.invalidate(indicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final profile = ref.watch(smokingProfileProvider).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.settingsModelTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: HalenSpace.x2),

        // Clearance pace — a calibration dial, never a measurement.
        Text(l10n.metabolismTitle, style: theme.textTheme.labelLarge),
        const SizedBox(height: HalenSpace.x2),
        SegmentedButton<MetabolismSpeed>(
          segments: [
            ButtonSegment(
              value: MetabolismSpeed.slow,
              label: Text(l10n.metabolismSlow),
            ),
            ButtonSegment(
              value: MetabolismSpeed.normal,
              label: Text(l10n.metabolismNormal),
            ),
            ButtonSegment(
              value: MetabolismSpeed.fast,
              label: Text(l10n.metabolismFast),
            ),
          ],
          selected: {profile?.metabolism ?? MetabolismSpeed.normal},
          onSelectionChanged: (selection) => _updateProfile(
            SmokingProfileCompanion(metabolism: Value(selection.first)),
          ),
        ),
        const SizedBox(height: HalenSpace.x2),
        Text(l10n.metabolismNote, style: theme.textTheme.bodySmall),
        const SizedBox(height: HalenSpace.x4),

        // Pre-log pause — friction that never costs a record.
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: widget.preLogPauseSeconds > 0,
          onChanged: (on) async {
            final db = ref.read(databaseProvider);
            await db.settingsDao.updateSettings(
              SettingsCompanion(preLogPauseSeconds: Value(on ? 20 : 0)),
            );
          },
          title: Text(l10n.logPauseSettingTitle),
          subtitle: Text(l10n.settingsPrelogPauseNote),
        ),
        // The only push the modules add — and it stays off until asked for.
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: widget.riskyWindowReminder,
          onChanged: (on) async {
            await ref.read(databaseProvider).settingsDao.updateSettings(
                  SettingsCompanion(riskyWindowReminder: Value(on)),
                );
            await applyRiskyWindowReminder(ref, enabled: on);
          },
          title: Text(l10n.settingsRiskyWindowReminder),
          subtitle: Text(l10n.settingsRiskyWindowNote),
        ),
        const SizedBox(height: HalenSpace.x4),

        // Optional body data.
        Text(l10n.settingsBodyDataTitle, style: theme.textTheme.labelLarge),
        const SizedBox(height: HalenSpace.x1),
        Text(l10n.settingsBodyDataNote, style: theme.textTheme.bodySmall),
        const SizedBox(height: HalenSpace.x3),
        Row(
          children: [
            Expanded(
              child: _NumberField(
                label: l10n.settingsHeight,
                value: profile?.heightCm,
                onChanged: (v) =>
                    _updateProfile(SmokingProfileCompanion(heightCm: Value(v))),
              ),
            ),
            const SizedBox(width: HalenSpace.x3),
            Expanded(
              child: _NumberField(
                label: l10n.settingsWeight,
                value: profile?.weightKg,
                onChanged: (v) =>
                    _updateProfile(SmokingProfileCompanion(weightKg: Value(v))),
              ),
            ),
          ],
        ),
        const SizedBox(height: HalenSpace.x3),
        _NumberField(
          label: l10n.settingsSmokingYears,
          value: profile?.smokingYears,
          onChanged: (v) => _updateProfile(
            SmokingProfileCompanion(smokingYears: Value(v)),
          ),
        ),
        const SizedBox(height: HalenSpace.x3),
        Text(l10n.settingsSex, style: theme.textTheme.labelLarge),
        const SizedBox(height: HalenSpace.x2),
        SegmentedButton<SexOption>(
          segments: [
            ButtonSegment(
              value: SexOption.unspecified,
              label: Text(l10n.sexUnspecified),
            ),
            ButtonSegment(value: SexOption.male, label: Text(l10n.sexMale)),
            ButtonSegment(value: SexOption.female, label: Text(l10n.sexFemale)),
          ],
          selected: {profile?.sex ?? SexOption.unspecified},
          onSelectionChanged: (selection) => _updateProfile(
            SmokingProfileCompanion(sex: Value(selection.first)),
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value == null ? '' : widget.value!.toStringAsFixed(0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: widget.label),
      // Empty means "not shared" and is written back as null, so clearing a
      // value really does remove it from the index.
      onSubmitted: (text) => widget.onChanged(
        text.trim().isEmpty ? null : double.tryParse(text.replaceAll(',', '.')),
      ),
    );
  }
}
