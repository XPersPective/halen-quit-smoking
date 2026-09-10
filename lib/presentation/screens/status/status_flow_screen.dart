import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../application/record_providers.dart';
import '../../../core/dates.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/body_load_model.dart';
import '../../../domain/entities.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/charts/halen_line_chart.dart';
import '../../widgets/charts/load_curve_chart.dart';
import '../../widgets/design/halen_components.dart';

/// Every number, one per page, swipeable (premium brief §A.10).
///
/// The user asked for exactly this and it was the thing the app kept not
/// having: *"ya kaydıracak ya da bakacak"*. The numbers existed, but the
/// nicotine curve was on one screen, the indices on another, money on a
/// third and the organs on a fourth, so nobody ever saw their own state as
/// one thing.
///
/// Every page has the same anatomy, and it is the anatomy the report's chart
/// rules ask for: a name, one big number with its unit, one chart, and one
/// sentence saying what the chart means. A page with nothing honest to draw
/// yet says so rather than drawing a flat line through no data.
class StatusFlowScreen extends ConsumerStatefulWidget {
  const StatusFlowScreen({super.key, this.initialPage = 0});

  final int initialPage;

  @override
  ConsumerState<StatusFlowScreen> createState() => _StatusFlowScreenState();
}

class _StatusFlowScreenState extends ConsumerState<StatusFlowScreen> {
  late final PageController _controller =
      PageController(initialPage: widget.initialPage);
  late int _page = widget.initialPage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _pagesFor(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statusTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: _PageDots(count: pages.length, active: _page),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _page = index),
        itemBuilder: (context, index) => SingleChildScrollView(
          padding: HalenSpace.screen,
          child: pages[index],
        ),
      ),
    );
  }

  List<Widget> _pagesFor(AppLocalizations l10n) => const [
        _LoadPage(kind: LoadKind.nicotineAcute),
        _LoadPage(kind: LoadKind.carbonMonoxide),
        _LoadPage(kind: LoadKind.nicotineBaseline),
        _LoadPage(kind: LoadKind.tarCumulative),
        _IndexPage(harm: false),
        _IndexPage(harm: true),
      ];
}

/// The page indicator. Dots rather than a scrollbar because the count is
/// small and fixed, and because a dot row tells you there *is* more.
class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: HalenSpace.x3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: HalenDuration.respecting(context, HalenDuration.quick),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == active
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                borderRadius: HalenRadius.smallAll,
              ),
            ),
        ],
      ),
    );
  }
}

/// The shared page frame: name, headline number, chart, one sentence.
class _StatusPage extends StatelessWidget {
  const _StatusPage({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.meaning,
    required this.chart,
    this.footnote,
  });

  final String title;
  final String value;

  /// What the number is in. A quantity without a unit is a decoration.
  final String unit;

  final Color color;
  final String meaning;
  final Widget chart;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HalenCard(
          emphasis: CardEmphasis.raised,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HalenStat(
                label: title,
                value: value,
                caption: unit,
                color: color,
                large: true,
              ),
              const SizedBox(height: HalenSpace.x5),
              chart,
            ],
          ),
        ),
        const SizedBox(height: HalenSpace.x4),
        Text(meaning, style: theme.textTheme.bodyMedium),
        if (footnote != null) ...[
          const SizedBox(height: HalenSpace.x3),
          Text(footnote!, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: HalenSpace.x5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swipe_left_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: HalenSpace.x2),
            Text(l10n.statusSwipeHint, style: theme.textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}

/// One of the four modelled body loads.
class _LoadPage extends ConsumerWidget {
  const _LoadPage({required this.kind});

  final LoadKind kind;

  DataRole get _role => switch (kind) {
        LoadKind.nicotineAcute => DataRole.nicotine,
        LoadKind.carbonMonoxide => DataRole.oxygen,
        LoadKind.nicotineBaseline => DataRole.baseline,
        LoadKind.tarCumulative => DataRole.particle,
      };

  String _title(AppLocalizations l10n) => switch (kind) {
        LoadKind.nicotineAcute => l10n.statusPageNicotine,
        LoadKind.carbonMonoxide => l10n.statusPageOxygen,
        LoadKind.nicotineBaseline => l10n.statusPageBaseline,
        LoadKind.tarCumulative => l10n.statusPageParticles,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final samples = ref.watch(loadCurveProvider(kind)).value ?? const [];
    final events = ref.watch(eventTimestampsProvider).value ?? const [];
    final cravings = ref.watch(cravingEventsProvider).value ?? const [];

    final windowStart = DateTime.now().subtract(const Duration(hours: 24));
    final windowEvents =
        events.where((e) => e.isAfter(windowStart)).toList(growable: false);

    if (windowEvents.isEmpty || samples.length < 2) {
      return HalenCard(
        child: HalenEmptyState(
          icon: Icons.timeline_rounded,
          message: l10n.statusNeedsData,
        ),
      );
    }

    final now = samples.last.value;
    final band = switch (bandFor(now)) {
      LoadBand.low => l10n.loadBandLow,
      LoadBand.medium => l10n.loadBandMedium,
      LoadBand.high => l10n.loadBandHigh,
    };
    return _StatusPage(
      title: _title(l10n),
      value: formatPercent(now, locale),
      // The unit is stated once, on the axis where it belongs. Repeating it
      // under the number as well just read as a duplicated line, so the
      // headline carries the band instead — which adds something.
      unit: band,
      color: _role.of(context),
      meaning: l10n.bodyLoadMeaning,
      footnote: kind == LoadKind.tarCumulative
          ? l10n.bodyLoadTarNote
          : kind == LoadKind.carbonMonoxide
              ? l10n.bodyLoadCoNote
              : null,
      chart: LoadCurveChart(
        samples: samples,
        events: windowEvents,
        ghostEvents: [
          for (final c in cravings)
            if (c.outcome == CravingOutcome.resisted &&
                c.ts.isAfter(windowStart))
              c.ts,
        ],
        color: _role.of(context),
        axisCaption: l10n.loadAxisCaption,
        timeLabels: [
          l10n.loadAxisHoursAgo(24),
          l10n.loadAxisHoursAgo(12),
          l10n.loadAxisNow,
        ],
        locale: locale,
        semanticsLabel: '${_title(l10n)}: ${formatPercent(now, locale)}',
      ),
    );
  }
}

/// The progress score or the harm load, over thirty days.
class _IndexPage extends ConsumerWidget {
  const _IndexPage({required this.harm});

  final bool harm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final indices = ref.watch(indicesProvider).value;
    if (indices == null) {
      return HalenCard(
        child: HalenEmptyState(
          icon: Icons.insights_rounded,
          message: l10n.statusNeedsData,
        ),
      );
    }

    final history = harm ? indices.harmHistory : indices.progressHistory;
    if (history.length < 2) {
      return HalenCard(
        child: HalenEmptyState(
          icon: Icons.insights_rounded,
          message: l10n.statusNeedsData,
        ),
      );
    }

    final role = harm ? DataRole.particle : DataRole.progress;
    return _StatusPage(
      title: harm ? l10n.statusPageHarm : l10n.statusPageProgress,
      value: '${history.last}',
      unit: l10n.indicesAxisCaption,
      color: role.of(context),
      meaning: l10n.indicesMeaning,
      chart: HalenLineChart(
        meaning: l10n.chartLast30Days,
        axisCaption: l10n.indicesAxisCaption,
        minY: 0,
        maxY: 100,
        series: [
          ChartSeries(
            name: harm ? l10n.indicesHarmLegend : l10n.indicesProgressLegend,
            color: role.of(context),
            values: [for (final v in history) v.toDouble()],
            fill: true,
          ),
        ],
        xLabels: [
          l10n.chartDaysAgo(history.length - 1),
          l10n.chartDaysAgo((history.length - 1) ~/ 2),
          l10n.chartToday,
        ],
        semanticsLabel: '${harm ? l10n.statusPageHarm : l10n.statusPageProgress}'
            ': ${history.last}',
      ),
    );
  }
}
