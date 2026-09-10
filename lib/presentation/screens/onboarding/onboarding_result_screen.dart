import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/module_providers.dart';
import '../../../core/dates.dart';
import '../../../core/design/data_palette.dart';
import '../../../core/design/tokens.dart';
import '../../../core/routes.dart';
import '../../../domain/craving_risk.dart';
import '../../../domain/economy.dart';
import '../../../domain/entities.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../widgets/design/halen_components.dart';
import '../../widgets/entrance.dart';

/// The first sixty seconds, paid off (premium brief §A.1).
///
/// Before this screen existed, onboarding ended by dropping the person onto
/// an empty Today: they had answered eight questions and received a blank
/// page. That is the single worst moment in the product, because it is
/// exactly where somebody decides whether this app is worth keeping.
///
/// Everything here is computed from the answers they just gave — packs a
/// year, money a year, time a year, how hard their body is leaning on it,
/// and what the first three days will actually be like. Nothing is
/// aspirational and nothing is invented.
class OnboardingResultScreen extends ConsumerWidget {
  const OnboardingResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final profile = ref.watch(smokingProfileProvider).value;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final cpd = profile.baselineCpd;
    final economy = Economy(
      pricePerPack: profile.pricePerPack,
      packSize: profile.packSize,
      sex: profile.sex ?? SexOption.unspecified,
    );

    final packsAYear = cpd * 365 / profile.packSize;
    final moneyAYear = economy.perCigarette * cpd * 365;
    final timeAYear = economy.timeLost(cpd * 365);

    final hsi = heavinessOfSmokingIndex(
      cigarettesPerDay: cpd,
      minutesToFirstCigarette: _minutesFor(profile.ttfcBand),
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: HalenSpace.screen,
          children: [
            Text(l10n.resultTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: HalenSpace.x2),
            Text(l10n.resultSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HalenSpace.x6),

            Entrance(
              child: HalenCard(
                emphasis: CardEmphasis.raised,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HalenStat(
                        label: l10n.resultPerYearPacks,
                        value: packsAYear.round().toString(),
                        color: DataRole.particle.of(context),
                      ),
                    ),
                    const SizedBox(width: HalenSpace.x3),
                    Expanded(
                      child: HalenStat(
                        label: l10n.resultPerYearMoney,
                        // Simple, not compactCurrency: the latter prints the
                        // ISO code ("USD36.5K"), which reads as a fault.
                        value: NumberFormat.compactSimpleCurrency(
                          locale: locale,
                          decimalDigits: 0,
                        ).format(moneyAYear),
                        color: DataRole.money.of(context),
                      ),
                    ),
                    const SizedBox(width: HalenSpace.x3),
                    Expanded(
                      child: HalenStat(
                        label: l10n.resultPerYearTime,
                        value: formatShortDuration(timeAYear, locale),
                        color: DataRole.time.of(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x4),

            // The dependence score was already computed and never shown. It
            // is the one number that explains why their plan starts the way
            // it does, so it belongs here rather than in a settings screen.
            Entrance(index: 1, child: _DependenceCard(hsi: hsi)),
            const SizedBox(height: HalenSpace.x4),

            Entrance(index: 2, child: _First72Card()),
            const SizedBox(height: HalenSpace.x6),

            FilledButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.today, (_) => false),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              child: Text(l10n.resultStart),
            ),
            const SizedBox(height: HalenSpace.x4),
            Text(l10n.resultSourceNote, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  /// Midpoint of the band, for the HSI item. The band is what onboarding
  /// asks for; the index needs minutes.
  int _minutesFor(TtfcBand band) => switch (band) {
        TtfcBand.under5 => 3,
        TtfcBand.five30 => 20,
        TtfcBand.thirtyOne60 => 45,
        TtfcBand.over60 => 90,
      };
}

class _DependenceCard extends StatelessWidget {
  const _DependenceCard({required this.hsi});

  final int hsi;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final band = hsi <= 2
        ? l10n.resultDependenceLow
        : hsi <= 4
            ? l10n.resultDependenceModerate
            : l10n.resultDependenceHigh;

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: l10n.resultDependenceTitle),
          const SizedBox(height: HalenSpace.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HalenStat(
                label: band,
                value: '$hsi / 6',
                color: DataRole.nicotine.of(context),
                large: true,
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(
            l10n.resultDependenceExplain,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _First72Card extends StatelessWidget {
  const _First72Card();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rows = [
      (l10n.resultFirst7220m, l10n.resultFirst7220mBody),
      (l10n.resultFirst7212h, l10n.resultFirst7212hBody),
      (l10n.resultFirst7248h, l10n.resultFirst7248hBody),
    ];

    return HalenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HalenSectionHeader(title: l10n.resultFirst72Title),
          const SizedBox(height: HalenSpace.x4),
          for (final (moment, what) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: HalenSpace.x4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 92,
                    child: Text(
                      moment,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: DataRole.progress.of(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(what, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
