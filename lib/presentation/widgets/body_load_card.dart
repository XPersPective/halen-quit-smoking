import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../application/record_providers.dart';
import '../../core/dates.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/body_load_model.dart';
import '../../domain/entities.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/load_band_chart.dart';
import 'charts/load_curve_chart.dart';

/// The Body Load card (module report §1.③): one sentence that answers "what
/// is in me right now", the signature 24-hour sawtooth, and four normalized
/// load readouts.
///
/// Every number here is S3 — modelled from the user's own timestamps — and
/// the card says so, links to the formula, and never prints ng/mL or mg.
class BodyLoadCard extends ConsumerStatefulWidget {
  const BodyLoadCard({super.key});

  @override
  ConsumerState<BodyLoadCard> createState() => _BodyLoadCardState();
}

class _BodyLoadCardState extends ConsumerState<BodyLoadCard> {
  LoadKind _selected = LoadKind.nicotineAcute;
  int _bandDays = 7;

  Color _colorFor(LoadKind kind) => switch (kind) {
        LoadKind.nicotineAcute => HalenColors.amberCta,
        LoadKind.nicotineBaseline => HalenColors.coral,
        LoadKind.carbonMonoxide => HalenColors.skyBlue,
        LoadKind.tarCumulative => HalenColors.textSecondaryLight,
      };

  String _labelFor(LoadKind kind, AppLocalizations l10n) => switch (kind) {
        LoadKind.nicotineAcute => l10n.loadNicotineAcute,
        LoadKind.nicotineBaseline => l10n.loadNicotineBaseline,
        LoadKind.carbonMonoxide => l10n.loadCarbonMonoxide,
        LoadKind.tarCumulative => l10n.loadTar,
      };

  String _bandLabel(int value, AppLocalizations l10n) =>
      switch (bandFor(value)) {
        LoadBand.low => l10n.loadBandLow,
        LoadBand.medium => l10n.loadBandMedium,
        LoadBand.high => l10n.loadBandHigh,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final snapshot = ref.watch(bodyLoadSnapshotProvider).value;
    final samples = ref.watch(loadCurveProvider(_selected)).value ?? const [];
    final tarLoad = ref.watch(tarLoadProvider).value ?? 0;
    final events = ref.watch(eventTimestampsProvider).value ?? const [];
    final cravings = ref.watch(cravingEventsProvider).value ?? const [];

    final windowStart = DateTime.now().subtract(const Duration(hours: 24));
    final windowEvents =
        events.where((e) => e.isAfter(windowStart)).toList(growable: false);
    final ghosts = [
      for (final c in cravings)
        if (c.outcome == CravingOutcome.resisted && c.ts.isAfter(windowStart))
          c.ts,
    ];

    final hasData = windowEvents.isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.bodyLoadTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l10n.commonHowCalculated,
                  icon: const Icon(Icons.help_outline_rounded, size: 20),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.glossary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (!hasData)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.bodyLoadEmpty,
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else ...[
              // The one sentence that answers the user's actual question.
              if (snapshot?.sinceLast != null)
                Text(
                  l10n.bodyLoadSinceLast(
                    formatShortDuration(snapshot!.sinceLast!, locale),
                  ),
                  style: theme.textTheme.titleLarge,
                ),
              const SizedBox(height: 6),
              if (snapshot != null) ...[
                Text(
                  l10n.bodyLoadNicotineNow(snapshot.nicotinePercentOfPeak),
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  l10n.bodyLoadCoDrop(snapshot.coDropPercent),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              LoadCurveChart(
                samples: samples,
                events: windowEvents,
                ghostEvents: ghosts,
                color: _colorFor(_selected),
                axisCaption: l10n.loadAxisCaption,
                locale: locale,
                timeLabels: [
                  l10n.loadAxisHoursAgo(24),
                  l10n.loadAxisHoursAgo(12),
                  l10n.loadAxisNow,
                ],
                semanticsLabel: samples.isEmpty
                    ? l10n.bodyLoadEmpty
                    : '${_labelFor(_selected, l10n)}: '
                        '${_bandLabel(samples.last.value, l10n)}',
              ),
              if (ghosts.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 2,
                      color: HalenColors.emerald,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.ghostPeakLabel,
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final kind in LoadKind.values)
                    _LoadChip(
                      label: _labelFor(kind, l10n),
                      band: _bandLabel(
                        kind == LoadKind.tarCumulative
                            ? tarLoad
                            : snapshot?.values[kind] ?? 0,
                        l10n,
                      ),
                      color: _colorFor(kind),
                      selected: _selected == kind,
                      onTap: () => setState(() => _selected = kind),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _LoadBandSection(days: _bandDays, onDaysChanged: (d) {
                setState(() => _bandDays = d);
              }),
              const SizedBox(height: 12),
              Text(
                switch (_selected) {
                  LoadKind.tarCumulative => l10n.bodyLoadTarNote,
                  LoadKind.carbonMonoxide => l10n.bodyLoadCoNote,
                  _ => l10n.moduleModelTag,
                },
                style: theme.textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LoadChip extends StatelessWidget {
  const _LoadChip({
    required this.label,
    required this.band,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String band;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: '$label: $band',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: selected ? 0.18 : 0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: theme.textTheme.labelSmall),
              const SizedBox(height: 2),
              Text(
                band,
                style: theme.textTheme.titleSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/// "Is the whole week coming down?" — the daily band under the sawtooth
/// (module report §1.④). Trend first, bars second.
class _LoadBandSection extends ConsumerWidget {
  const _LoadBandSection({required this.days, required this.onDaysChanged});

  final int days;
  final ValueChanged<int> onDaysChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final band = ref.watch(loadBandProvider(days)).value;
    if (band == null || band.means.isEmpty) {
      return const SizedBox.shrink();
    }
    final trend = band.trendPercent;
    final trendLabel = trend < -2
        ? l10n.loadBandTrendDown(-trend)
        : trend > 2
            ? l10n.loadBandTrendUp(trend)
            : l10n.loadBandTrendFlat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and range selector stack instead of sharing a row: at large
        // text scales on a 320 dp screen the two cannot fit side by side.
        Text(l10n.loadBandTitle, style: theme.textTheme.labelLarge),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentedButton<int>(
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
            segments: [
              ButtonSegment(value: 7, label: Text(l10n.loadBandWeek)),
              ButtonSegment(value: 30, label: Text(l10n.loadBandMonth)),
            ],
            selected: {days},
            showSelectedIcon: false,
            onSelectionChanged: (s) => onDaysChanged(s.first),
          ),
        ),
        const SizedBox(height: 4),
        // Trend before the bars (chart rule 3).
        Text(trendLabel, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        LoadBandChart(
          means: band.means,
          peaks: band.peaks,
          color: HalenColors.amberCta,
          semanticsLabel: '${l10n.loadBandTitle}: $trendLabel',
        ),
      ],
    );
  }
}
