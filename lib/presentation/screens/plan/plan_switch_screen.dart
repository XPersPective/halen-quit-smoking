import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../core/theme.dart';
import '../../../domain/plan_kinds.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Changing plans (module report §13).
///
/// Deliberate but never locked: the user sees their OWN report card first,
/// gets a data-backed suggestion (a suggestion, not an imposition), and is
/// told plainly that nothing in their history is lost. The only real gate is
/// the seven-day minimum — and Track Only is exempt from it, because the
/// no-pressure option must never become a trap.
class PlanSwitchScreen extends ConsumerStatefulWidget {
  const PlanSwitchScreen({super.key});

  @override
  ConsumerState<PlanSwitchScreen> createState() => _PlanSwitchScreenState();
}

class _PlanSwitchScreenState extends ConsumerState<PlanSwitchScreen> {
  PlanReportCard? _report;
  SwitchVerdict? _verdict;
  PlanKind? _suggestion;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final controller = ref.read(planKindControllerProvider);
    final report = await controller.reportCard();
    final verdict = await controller.verdict();
    final suggestion = await controller.suggestion();
    if (!mounted) {
      return;
    }
    setState(() {
      _report = report;
      _verdict = verdict;
      _suggestion = suggestion;
      _loading = false;
    });
  }

  String _planName(PlanKind kind, AppLocalizations l10n) => switch (kind) {
        PlanKind.gradualTaper => l10n.planKindGradual,
        PlanKind.dailyQuota => l10n.planKindQuota,
        PlanKind.quitDay => l10n.planKindQuitDay,
        PlanKind.trackOnly => l10n.planKindTrackOnly,
      };

  String _planNote(PlanKind kind, AppLocalizations l10n) => switch (kind) {
        PlanKind.gradualTaper => l10n.planKindGradualNote,
        PlanKind.dailyQuota => l10n.planKindQuotaNote,
        PlanKind.quitDay => l10n.planKindQuitDayNote,
        PlanKind.trackOnly => l10n.planKindTrackOnlyNote,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final current = ref.watch(planStateProvider).value?.kind;
    final report = _report;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.planSwitchTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (report != null) ...[
                  Text(
                    l10n.planReportCardTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _ReportRow(
                            label: l10n.planReportDays,
                            value: '${report.daysInPlan}',
                          ),
                          _ReportRow(
                            label: l10n.planReportAdherence,
                            value: '${(report.adherence * 100).round()}%',
                          ),
                          _ReportRow(
                            label: l10n.planReportHardestHour,
                            value: report.hardestHour == null
                                ? '—'
                                : '${report.hardestHour}:00',
                          ),
                          _ReportRow(
                            label: l10n.planReportResisted,
                            value: '${report.cravingsResisted}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (_verdict == SwitchVerdict.tooSoon && report != null)
                  _Note(
                    text: l10n.planTooSoon(minDaysInPlan - report.daysInPlan),
                    color: HalenColors.amberCta,
                  ),
                if (_verdict == SwitchVerdict.allowedWithNote)
                  _Note(
                    text: l10n.planFrequentSwitchNote,
                    color: HalenColors.skyBlue,
                  ),
                const SizedBox(height: 8),
                for (final kind in PlanKind.values)
                  _PlanOption(
                    title: _planName(kind, l10n),
                    note: _planNote(kind, l10n),
                    selected: kind == current,
                    suggested: kind == _suggestion,
                    suggestedLabel: l10n.planSuggestionLabel,
                    // Track Only is always reachable; other switches wait out
                    // the seven days.
                    enabled: kind != current &&
                        (kind == PlanKind.trackOnly ||
                            _verdict != SwitchVerdict.tooSoon),
                    onTap: () => _switchTo(kind),
                  ),
                const SizedBox(height: 12),
                Text(
                  l10n.planHistoryKept,
                  style: theme.textTheme.labelSmall,
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Future<void> _switchTo(PlanKind kind) async {
    final done = await ref.read(planKindControllerProvider).switchTo(kind);
    if (!mounted || !done) {
      return;
    }
    Navigator.of(context).pop();
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.title,
    required this.note,
    required this.selected,
    required this.suggested,
    required this.suggestedLabel,
    required this.enabled,
    required this.onTap,
  });

  final String title;
  final String note;
  final bool selected;
  final bool suggested;
  final String suggestedLabel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: enabled || selected ? 1 : 0.5,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? HalenColors.petrol : theme.dividerColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          if (suggested) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: HalenColors.emerald
                                    .withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                suggestedLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: HalenColors.petrol,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(note, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
