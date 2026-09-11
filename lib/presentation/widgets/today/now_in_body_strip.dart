import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../application/record_providers.dart';
import '../../../core/dates.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../domain/body_load_model.dart';
import '../../../domain/entities.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../charts/load_curve_chart.dart';
import '../design/halen_components.dart';

/// "What is in me right now", on the home screen (module report §1.③).
///
/// The body-load model already existed, but it lived two taps away on the
/// Grafikler tab. The first question a person actually opens this app with is
/// *how much of it is still in me* — so the answer belongs where they land.
///
/// Three readouts and one curve, all in the only unit the model can honestly
/// produce: percent of the user's own 24-hour peak. It re-reads the clock
/// every thirty seconds, because a number that answers "right now" and then
/// sits frozen is worse than no number at all.
class NowInBodyStrip extends ConsumerStatefulWidget {
  const NowInBodyStrip({super.key});

  @override
  ConsumerState<NowInBodyStrip> createState() => _NowInBodyStripState();
}

class _NowInBodyStripState extends ConsumerState<NowInBodyStrip> {
  Timer? _tick;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final model = ref.watch(bodyLoadModelProvider);
    final events = ref.watch(eventTimestampsProvider).value ?? const [];
    final cravings = ref.watch(cravingEventsProvider).value ?? const [];

    // Recomputed here rather than read from a provider, so the ticking clock
    // is what moves the numbers — the providers only change when a record does.
    final windowStart = _now.subtract(const Duration(hours: 24));
    final past = events.where((e) => !e.isAfter(_now)).toList()..sort();
    final windowEvents =
        past.where((e) => e.isAfter(windowStart)).toList(growable: false);

    if (windowEvents.isEmpty) {
      return _Shell(
        title: l10n.nowInBodyTitle,
        child: HalenEmptyState(
          icon: Icons.timeline_rounded,
          message: l10n.nowInBodyEmpty,
        ),
      );
    }

    final snapshot = model.snapshot(_now, past);
    final samples = model.normalizedCurve(
      LoadKind.nicotineAcute,
      windowStart,
      _now,
      past,
    );
    // Item 12: the nicotine axis in milligrams. The model's raw curve is in
    // mg of absorbed nicotine still in the body, so the peak of this window
    // gives the axis its real scale.
    final rawNicotine = model.rawCurve(
      LoadKind.nicotineAcute,
      windowStart,
      _now,
      past,
    );
    final peakMg = rawNicotine.isEmpty ? 0.0 : rawNicotine.reduce(math.max);
    final nowMg = model.rawAt(LoadKind.nicotineAcute, _now, past);
    String mg(double v) =>
        l10n.mgValue(v < 10 ? v.toStringAsFixed(1) : v.toStringAsFixed(0));

    final ghosts = [
      for (final c in cravings)
        if (c.outcome == CravingOutcome.resisted && c.ts.isAfter(windowStart))
          c.ts,
    ];

    String band(int value) => switch (bandFor(value)) {
          LoadBand.low => l10n.loadBandLow,
          LoadBand.medium => l10n.loadBandMedium,
          LoadBand.high => l10n.loadBandHigh,
        };

    return _Shell(
      title: l10n.nowInBodyTitle,
      // Every metric now lives in one swipeable flow, so the card's own
      // exit goes there rather than to a single screen.
      onOpen: () => Navigator.of(context).pushNamed(Routes.status),
      openLabel: l10n.statusOpen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HalenStat(
                  label: l10n.loadNicotineAcute,
                  value: mg(nowMg),
                  caption: band(snapshot.nicotinePercentOfPeak),
                  color: DataRole.nicotine.of(context),
                ),
              ),
              Expanded(
                child: HalenStat(
                  label: l10n.loadCarbonMonoxide,
                  value: formatPercent(snapshot.coPercentOfPeak, locale),
                  caption: band(snapshot.coPercentOfPeak),
                  color: DataRole.oxygen.of(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: HalenStat(
                  label: '${l10n.loadTar} (Bugün)',
                  value: '${snapshot.tarMgToday} mg',
                  caption: '≈ ${snapshot.tarDropsToday.toStringAsFixed(1)} damla',
                  color: const Color(0xFF8D6E63),
                ),
              ),
              Expanded(
                child: HalenStat(
                  label: l10n.nowInBodyLast,
                  value: snapshot.sinceLast == null
                      ? l10n.nowInBodyNever
                      : formatShortDuration(snapshot.sinceLast!, locale),
                  caption: 'Temizlenme sürüyor',
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x4),
          LoadCurveChart(
            samples: samples,
            events: windowEvents,
            ghostEvents: ghosts,
            color: DataRole.nicotine.of(context),
            axisCaption: l10n.nicotineMgAxis,
            peakValue: peakMg,
            unitFormatter: mg,
            timeLabels: [
              l10n.loadAxisHoursAgo(24),
              l10n.loadAxisHoursAgo(18),
              l10n.loadAxisHoursAgo(12),
              l10n.loadAxisHoursAgo(6),
              l10n.loadAxisNow,
            ],
            height: 150,
            locale: locale,
            semanticsLabel: '${l10n.loadNicotineAcute}: '
                '${formatPercent(snapshot.nicotinePercentOfPeak, locale)} — '
                '${band(snapshot.nicotinePercentOfPeak)}',
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(l10n.bodyLoadMeaning, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x1),
          Text(
            '${l10n.nicotineMgBasis} · ${snapshot.weightKg != null ? '${snapshot.weightKg!.round()} kg ağırlık · ' : ''}Paket: ${snapshot.tarPerCigarette.toStringAsFixed(0)} mg katran, ${snapshot.nicotinePerCigarette.toStringAsFixed(1)} mg nikotin.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({
    required this.title,
    required this.child,
    this.onOpen,
    this.openLabel,
  });

  final String title;
  final Widget child;
  final VoidCallback? onOpen;
  final String? openLabel;

  @override
  Widget build(BuildContext context) {
    return HalenCard(
      emphasis: CardEmphasis.raised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: title),
          const SizedBox(height: HalenSpace.x3),
          child,
          if (onOpen != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                iconAlignment: IconAlignment.end,
                label: Text(openLabel!),
              ),
            ),
        ],
      ),
    );
  }
}
