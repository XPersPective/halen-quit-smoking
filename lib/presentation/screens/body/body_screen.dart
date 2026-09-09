import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/module_providers.dart';
import '../../../core/dates.dart';
import '../../../core/routes.dart';
import '../../../core/theme.dart';
import '../../../data/repositories/library_repository.dart';
import '../../../application/providers.dart';
import '../../../domain/health_timeline.dart';
import '../../../domain/lung_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/body_map_view.dart';
import '../../widgets/organ_shapes.dart';
import '../../widgets/charts/halen_line_chart.dart';
import '../../widgets/lung_view.dart';

/// The body screen: lungs (module report §6), the organ map (§7) and what is
/// actually in the smoke (§2).
///
/// The honesty spine of this screen: no personal percentages anywhere, every
/// scenario curve is labelled "typical for your age group", and every organ
/// card puts recovery next to harm — the negative half never ships alone.
class BodyScreen extends ConsumerWidget {
  const BodyScreen({super.key, this.initialTab = 0});

  /// Which tab opens first — used by the visual capture, and by any future
  /// deep link that wants to land on the body map directly.
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.organMapTitle),
          actions: [
            IconButton(
              tooltip: l10n.commonHowCalculated,
              icon: const Icon(Icons.help_outline_rounded),
              onPressed: () =>
                  Navigator.of(context).pushNamed(Routes.howCalculated),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l10n.lungsTitle),
              Tab(text: l10n.organMapTitle),
              Tab(text: l10n.toxicantsTitle),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_LungsTab(), _OrgansTab(), _ToxicantsTab()],
        ),
      ),
    );
  }
}

class _LungsTab extends ConsumerWidget {
  const _LungsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tarLoad = ref.watch(tarLoadProvider).value ?? 0;
    final scenarios = ref.watch(lungScenariosProvider).value;
    final quitTs = ref.watch(timelineStateProvider).value;
    // A milestone reached within the last day earns one glow.
    final justReached =
        quitTs != null &&
        HealthMilestone.values.any((m) {
          final days = daysSinceQuit(quitTs, DateTime.now());
          return m.minQuitDays == days && days > 0;
        });

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LungView(
          celebrate: justReached,
          mist: mistLevel(tarLoadVsBaseline: tarLoad),
          semanticsLabel: '${l10n.lungsMistLabel}: $tarLoad / 100',
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            l10n.lungsNotAScan,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Text(l10n.lungsSlowsLine, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(l10n.lungsTypicalLabel, style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        if (scenarios != null && scenarios[LungScenario.keepThisPace] != null)
          Builder(
            builder: (context) {
              final keep = scenarios[LungScenario.keepThisPace]!;
              final quit = scenarios[LungScenario.quitToday]!;
              final never = scenarios[LungScenario.neverSmoked]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HalenLineChart(
                    meaning: l10n.lungsMeaning,
                    // The better future sits on top: lung function is a
                    // "higher is better" axis, and the shaded gap between
                    // quitting and carrying on is the whole argument.
                    shadeBetween: true,
                    maxY: 100,
                    yFormatter: (v) => '${v.round()}%',
                    series: [
                      ChartSeries(
                        name: l10n.lungsScenarioQuit,
                        color: HalenColors.emerald,
                        values: [for (final p in quit) p.percentOfPeak],
                      ),
                      ChartSeries(
                        name: l10n.lungsScenarioKeep,
                        color: HalenColors.amberCta,
                        values: [for (final p in keep) p.percentOfPeak],
                      ),
                      ChartSeries(
                        name: l10n.lungsScenarioNever,
                        color: HalenColors.textSecondaryLight,
                        dashed: true,
                        values: [for (final p in never) p.percentOfPeak],
                      ),
                    ],
                    xLabels: keep.isEmpty
                        ? const []
                        : [
                            '${l10n.lungsAxisAge} ${keep.first.age}',
                            '${keep[keep.length ~/ 2].age}',
                            '${keep.last.age}',
                          ],
                    semanticsLabel:
                        '${l10n.lungsScenarioQuit} vs ${l10n.lungsScenarioKeep}',
                  ),
                  const SizedBox(height: 10),
                  // What the shaded area is worth, in one sentence.
                  Builder(
                    builder: (context) {
                      final gap = scenarioGapAt(
                        fromAge: keep.first.age,
                        atAge: 70,
                        cigarettesPerDay:
                            ref.watch(measuredBaselineProvider).value ?? 15,
                      );
                      if (gap <= 0.5) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        l10n.lungsGapAt(70, gap.toStringAsFixed(0)),
                        style: theme.textTheme.titleSmall,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 16),
        Text(l10n.moduleModelTag, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

class _OrgansTab extends ConsumerStatefulWidget {
  const _OrgansTab();

  @override
  ConsumerState<_OrgansTab> createState() => _OrgansTabState();
}

class _OrgansTabState extends ConsumerState<_OrgansTab> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final user = ref.watch(userProfileProvider).value;
    final age = midpointAge(user?.ageBand);
    final organs = [...ref.watch(libraryRepositoryProvider).organs()]
      // Ordering — and ONLY ordering — is personalized: past 45 the
      // cardiovascular entries come first. No number ever changes.
      ..sort((a, b) {
        if (age < 45) {
          return 0;
        }
        return (b.cardiovascular ? 1 : 0).compareTo(a.cardiovascular ? 1 : 0);
      });
    final selected = _selected == null
        ? null
        : organs.firstWhere((o) => o.key == _selected);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        BodyMapView(
          organs: organs,
          selectedKey: _selected,
          locale: locale,
          onSelected: (key) =>
              setState(() => _selected = _selected == key ? null : key),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            selected == null ? l10n.organTapHint : l10n.organNotYou,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // The detail slides in under the figure rather than replacing it, so
        // the body stays in view and the tap reads as an expansion.
        AnimatedSize(
          duration: reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: selected == null
              ? const SizedBox(width: double.infinity)
              : _OrganDetail(
                  key: ValueKey(selected.key),
                  organ: selected,
                  locale: locale,
                ),
        ),

        // Whole-body systems have no organ to point at, so they get a row of
        // their own instead of a meaningless dot somewhere on the figure.
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final key in BodyMapView.diffuse)
              for (final organ in organs.where((o) => o.key == key))
                ActionChip(
                  avatar: Icon(
                    Icons.blur_on_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  label: Text(organ.name(locale)),
                  onPressed: () => setState(
                    () => _selected = _selected == organ.key ? null : organ.key,
                  ),
                ),
          ],
        ),
        const SizedBox(height: 16),
        if (selected == null)
          Text(l10n.organPopulationNote, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

/// One organ, opened from the map: what it does, what recovery looks like,
/// and the population figure behind it — in that order, with recovery given
/// the louder container (module report §7.③).
class _OrganDetail extends StatelessWidget {
  const _OrganDetail({super.key, required this.organ, required this.locale});

  final OrganEntry organ;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final impact = organ.impact;
    final caption = impact.attributable != null
        ? l10n.organImpactAttributable((impact.attributable! * 100).round())
        : impact.relativeRisk != null
        ? l10n.organImpactRelative(impact.relativeRisk!.toStringAsFixed(1))
        : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The organ at a size where the drawing actually reads as
                // one. On the map it is a marker; here it is the subject.
                OrganGlyph(
                  organKey: organ.key,
                  color: HalenColors.amberCta,
                  size: const Size(96, 96),
                ),
                if (OrganShapes.drawn.contains(organ.key))
                  const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    organ.name(locale),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (!impact.isEmpty) ...[
              OrganImpactBar(
                impact: impact,
                caption: caption,
                color: HalenColors.amberCta,
              ),
              const SizedBox(height: 16),
            ],
            Text(l10n.organHarmTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(organ.harm(locale), style: theme.textTheme.bodyMedium),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: HalenColors.emerald.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.organRecoveryTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: HalenColors.petrol,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    organ.recovery(locale),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // The same recovery line, structured in time — where the
            // literature gives a timeframe worth placing.
            if (organ.recoveryTimeline.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(l10n.organTimelineTitle, style: theme.textTheme.labelLarge),
              const SizedBox(height: 2),
              Text(
                l10n.organTimelineCaption,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              OrganRecoveryTimeline(
                anchors: organ.recoveryTimeline,
                locale: locale,
              ),
            ],
            const SizedBox(height: 10),
            Text(
              '${l10n.moduleSourceLabel}: ${organ.sourceUrl}',
              style: theme.textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToxicantsTab extends ConsumerWidget {
  const _ToxicantsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final library = ref.watch(libraryRepositoryProvider);
    final toxicants = library.toxicants();
    final now = DateTime.now();
    final todayCount = (ref.watch(eventTimestampsProvider).value ?? const [])
        .where((e) => e.isSameLocalDayAs(now))
        .length;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (todayCount > 0) ...[
          // The library only lands when it is attached to today's own record
          // (module report §2.③) — no dose claim, just the count and the
          // names it puts you in contact with.
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5,
            runSpacing: 5,
            children: [
              for (var i = 0; i < todayCount.clamp(0, 20); i++)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: HalenColors.amberCta,
                  ),
                ),
              Text(
                l10n.toxicantsToday(todayCount),
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Text(
          l10n.toxicantsSubtitle(
            LibraryRepository.knownChemicals,
            LibraryRepository.knownCarcinogens,
          ),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        // 70 dots: the scale of the carcinogen count, without a wall of text.
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var i = 0; i < LibraryRepository.knownCarcinogens; i++)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HalenColors.textSecondaryLight.withValues(
                    alpha: i < toxicants.length ? 0.9 : 0.35,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        for (final toxicant in toxicants)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            toxicant.name(locale),
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        if (toxicant.iarcGroup != null)
                          Text(
                            l10n.toxicantIarcLabel(toxicant.iarcGroup!),
                            style: theme.textTheme.labelSmall,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.toxicantAnalogyLabel,
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(
                      toxicant.everydayAnalogy(locale),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.toxicantMechanismLabel,
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(
                      toxicant.mechanism(locale),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        Text(l10n.toxicantNoDose, style: theme.textTheme.labelSmall),
        const SizedBox(height: 24),
      ],
    );
  }
}
