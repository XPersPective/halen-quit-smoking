import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/providers.dart';
import '../../data/db/app_database.dart';
import '../../domain/body_load_model.dart';
import '../../domain/economy.dart';
import '../../domain/input_bounds.dart';
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
                min: InputBounds.heightMin,
                max: InputBounds.heightMax,
                onChanged: (v) =>
                    _updateProfile(SmokingProfileCompanion(heightCm: Value(v))),
              ),
            ),
            const SizedBox(width: HalenSpace.x3),
            Expanded(
              child: _NumberField(
                label: l10n.settingsWeight,
                value: profile?.weightKg,
                min: InputBounds.weightMin,
                max: InputBounds.weightMax,
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
          min: 0,
          max: InputBounds.smokingYearsMax,
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
    this.min,
    this.max,
  });

  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final double? min;
  final double? max;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value == null
        ? ''
        : (widget.value! == widget.value!.roundToDouble()
            ? widget.value!.toStringAsFixed(0)
            : widget.value!.toString()),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Honest propagation: blank means "not shared" (null outward), a bad
  /// or out-of-range value never reaches the profile. The inline error only
  /// helps fix it — the write is the source of truth.
  void _emit(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      widget.onChanged(null);
      setState(() {});
      return;
    }
    final v = double.tryParse(trimmed.replaceAll(',', '.'));
    final ok = v != null &&
        v.isFinite &&
        (widget.min == null || v >= widget.min!) &&
        (widget.max == null || v <= widget.max!);
    if (ok) {
      widget.onChanged(v);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text.trim();
    String? error;
    if (text.isNotEmpty) {
      final v = double.tryParse(text.replaceAll(',', '.'));
      if (v == null || !v.isFinite) {
        error = widget.label;
      } else if (widget.min != null && v < widget.min!) {
        error = '${widget.label}: ≥${widget.min!.toStringAsFixed(0)}';
      } else if (widget.max != null && v > widget.max!) {
        error = '${widget.label}: ≤${widget.max!.toStringAsFixed(0)}';
      }
    }
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: widget.label, errorText: error),
      onChanged: _emit,
      onSubmitted: _emit,
    );
  }
}
