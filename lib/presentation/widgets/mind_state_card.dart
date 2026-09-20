import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../domain/withdrawal_model.dart';
import '../../l10n/generated/app_localizations.dart';
import 'charts/halen_line_chart.dart';
import '../../core/design/tokens.dart';

/// Mind state (module report §8).
///
/// The product decision this card encodes: never print "you are 38% more
/// irritable". That is not measurable. It prints a BAND, says out loud that
/// it is a guess, and then asks the user — which is both the honest move and
/// the mechanism that teaches the model its personal offset.
///
/// It also carries the counter-narrative the evidence supports and users
/// rarely hear: quitting lowers anxiety and depression on average.
class MindStateCard extends ConsumerWidget {
  const MindStateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(mindStateProvider).value;
    // T12: with zero self-reports the band is a population guess, not the
    // user's state — say so instead of printing "calm" as if measured.
    final hasReports =
        (ref.watch(mindHistoryProvider).value ?? const []).isNotEmpty;

    final band = state?.band ?? PressureBand.calm;
    final label = !hasReports
        ? l10n.mindNoDataYet
        : switch (band) {
            PressureBand.calm => l10n.mindBandCalm,
            PressureBand.underPressure => l10n.mindBandUnderPressure,
            PressureBand.tough => l10n.mindBandTough,
          };
    final color = !hasReports
        ? theme.colorScheme.onSurfaceVariant
        : switch (band) {
            PressureBand.calm => HalenColors.emerald,
            PressureBand.underPressure => HalenColors.amberCta,
            PressureBand.tough => HalenColors.coral,
          };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.mindTitle,
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
            const SizedBox(height: HalenSpace.x1),
            Text(l10n.mindPressureLabel, style: theme.textTheme.labelMedium),
            const SizedBox(height: HalenSpace.x2),
            Text(
              label,
              style: theme.textTheme.headlineSmall?.copyWith(color: color),
            ),
            const SizedBox(height: HalenSpace.x2),
            Text(
              l10n.mindPressureExplainer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x3),

            // The typical 28-day course, with the user's own position on it.
            _PressureCurve(color: color, position: state?.value ?? 0),
            const SizedBox(height: HalenSpace.x2),
            Text(l10n.mindPeakNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: HalenSpace.x4),

            Text(l10n.mindOnlyYouKnow, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HalenSpace.x3),
            Text(l10n.mindHowDoYouFeel, style: theme.textTheme.labelLarge),
            const SizedBox(height: HalenSpace.x2),
            Wrap(
              spacing: 8,
              children: [
                for (final entry in [
                  (0, l10n.mindBandCalm),
                  (1, l10n.mindBandUnderPressure),
                  (2, l10n.mindBandTough),
                ])
                  OutlinedButton(
                    onPressed: () {
                      ref.read(moodReportProvider)(
                        entry.$1,
                        state?.value ?? 0,
                      );
                      // T12: the record is confirmed out loud — and the
                      // card flips from "no data" to the personal band.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.moodSaved)),
                      );
                    },
                    child: Text(entry.$2),
                  ),
              ],
            ),
            if (state?.accuracy != null) ...[
              const SizedBox(height: HalenSpace.x4),
              Text(
                l10n.mindAccuracyChartTitle,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: HalenSpace.x2),
              const _AccuracyChart(),
              const SizedBox(height: HalenSpace.x2),
              Text(
                l10n.mindAccuracy((state!.accuracy! * 100).round()),
                style: theme.textTheme.labelSmall,
              ),
            ],
            const SizedBox(height: HalenSpace.x4),
            Container(
              padding: const EdgeInsets.all(HalenSpace.x4),
              decoration: BoxDecoration(
                color: HalenColors.emerald.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.mindQuitLowersAnxiety,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PressureCurve extends StatelessWidget {
  const _PressureCurve({required this.color, required this.position});

  final Color color;

  /// The user's current estimate, 0..1 — drawn as a marker on the curve.
  final double position;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.mindTypicalCurve,
      excludeSemantics: true,
      child: SizedBox(
        height: 72,
        child: CustomPaint(
          painter: _PressurePainter(
            curve: typicalPressureCurve(),
            color: color,
            position: position,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _PressurePainter extends CustomPainter {
  _PressurePainter({
    required this.curve,
    required this.color,
    required this.position,
  });

  final List<double> curve;
  final Color color;
  final double position;

  @override
  void paint(Canvas canvas, Size size) {
    if (curve.length < 2) {
      return;
    }
    final path = Path()..moveTo(0, size.height * (1 - curve.first));
    for (var i = 1; i < curve.length; i++) {
      path.lineTo(
        size.width * i / (curve.length - 1),
        size.height * (1 - curve[i]),
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    // Where the user sits on that curve right now.
    final y = size.height * (1 - position.clamp(0.0, 1.0));
    canvas.drawCircle(Offset(size.width * 0.08, y), 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_PressurePainter old) =>
      old.curve != curve || old.color != color || old.position != position;
}

/// Guessed against felt (module report §8.④): two lines, no scores. Showing
/// where the model was wrong is the point — it is what earns the right to
/// show an estimate at all.
class _AccuracyChart extends ConsumerWidget {
  const _AccuracyChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(mindHistoryProvider).value ?? const [];
    if (history.length < 2) {
      return const SizedBox.shrink();
    }
    return HalenLineChart(
      meaning: l10n.mindMeaning,
      minY: 0,
      maxY: 100,
      height: 150,
      yFormatter: (v) => v <= 33
          ? l10n.mindBandCalm
          : v <= 66
          ? l10n.mindBandUnderPressure
          : l10n.mindBandTough,
      series: [
        ChartSeries(
          name: l10n.mindLegendGuess,
          color: HalenColors.skyBlue,
          dashed: true,
          values: [for (final h in history) h.estimated * 100],
        ),
        ChartSeries(
          name: l10n.mindLegendFelt,
          color: HalenColors.petrol,
          values: [for (final h in history) h.reported * 100],
        ),
      ],
      xLabels: const [],
      semanticsLabel: l10n.mindAccuracyChartTitle,
    );
  }
}
