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
import '../../widgets/charts/two_line_area_chart.dart';
import '../../widgets/lung_view.dart';

/// The body screen: lungs (module report §6), the organ map (§7) and what is
/// actually in the smoke (§2).
///
/// The honesty spine of this screen: no personal percentages anywhere, every
/// scenario curve is labelled "typical for your age group", and every organ
/// card puts recovery next to harm — the negative half never ships alone.
class BodyScreen extends ConsumerWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
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
    final justReached = quitTs != null &&
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
                  TwoLineAreaChart(
                    // The better scenario sits on top here: lung function is
                    // a "higher is better" axis.
                    upper: [for (final p in quit) p.percentOfPeak],
                    lower: [for (final p in keep) p.percentOfPeak],
                    reference: [for (final p in never) p.percentOfPeak],
                    upperColor: HalenColors.emerald,
                    lowerColor: HalenColors.amberCta,
                    referenceColor: HalenColors.textSecondaryLight,
                    axisLabels: keep.isEmpty
                        ? const []
                        : [
                            '${l10n.lungsAxisAge} ${keep.first.age}',
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
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _Legend(
                        color: HalenColors.emerald,
                        label: l10n.lungsScenarioQuit,
                      ),
                      _Legend(
                        color: HalenColors.amberCta,
                        label: l10n.lungsScenarioKeep,
                      ),
                      _Legend(
                        color: HalenColors.textSecondaryLight,
                        label: l10n.lungsScenarioNever,
                      ),
                    ],
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

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 3, color: color),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class _OrgansTab extends ConsumerWidget {
  const _OrgansTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
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

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(l10n.organPopulationNote, style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        for (final organ in organs)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organ.name(locale),
                      style: theme.textTheme.titleMedium,
                    ),
                    if (organ.relativeRisk != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        organ.relativeRisk!,
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      l10n.organHarmTitle,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      organ.harm(locale),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 14),
                    // Recovery is always present and always the louder half.
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: HalenColors.emerald.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
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
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.moduleSourceLabel}: ${organ.sourceUrl}',
                      style: theme.textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
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
                  color: HalenColors.textSecondaryLight
                      .withValues(alpha: i < toxicants.length ? 0.9 : 0.35),
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
