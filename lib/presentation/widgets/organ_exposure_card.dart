import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/module_providers.dart';
import '../../core/dates.dart';
import '../../core/design/tokens.dart';
import '../../core/theme.dart';
import '../../data/repositories/library_repository.dart';
import '../../domain/body_load_model.dart';
import '../../domain/organ_exposure.dart';
import '../../l10n/generated/app_localizations.dart';
import 'body_map_view.dart';
import 'charts/load_curve_chart.dart';
import 'design/halen_components.dart';

/// One organ, as this person's smoking reaches it (device feedback, item 5).
class OrganExposureCard extends ConsumerWidget {
  const OrganExposureCard({
    super.key,
    required this.organKey,
    this.organ,
  });

  final String organKey;
  final OrganEntry? organ;

  static const _rest = HalenColors.emerald;
  static const _heavy = Color(0xFF6B4A2B);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final model = ref.watch(bodyLoadModelProvider);
    final events = ref.watch(eventTimestampsProvider).value ?? const [];

    final now = DateTime.now();
    final start = now.subtract(const Duration(hours: 24));
    final windowEvents =
        events.where((e) => e.isAfter(start) && !e.isAfter(now)).toList();
    if (windowEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    final past = events.where((e) => !e.isAfter(now)).toList()..sort();
    final curve = organCurve(
      model: model,
      organKey: organKey,
      start: start,
      end: now,
      events: past,
    );
    if (curve.length < 2) {
      return const SizedBox.shrink();
    }

    final current = curve.last.value;
    final tint = Color.lerp(_rest, _heavy, current / 100)!;
    final sinceLast = now.difference(past.last);
    final loads = [
      for (final kind in mixFor(organKey).kinds) _loadName(kind, l10n),
    ].join(', ');

    return HalenCard(
      emphasis: CardEmphasis.raised,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OrganGlyph(
                organKey: organKey,
                color: tint,
                size: const Size(64, 64),
                glow: current > 50,
              ),
              const SizedBox(width: HalenSpace.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organ?.name(locale) ?? l10n.organExposureTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: HalenSpace.x1),
                    Text(
                      l10n.organExposureNow(current),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: tint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      l10n.organSinceLast(
                        formatShortDuration(sinceLast, locale),
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: HalenSpace.x4),
          LoadCurveChart(
            samples: curve,
            events: windowEvents,
            ghostEvents: const [],
            color: tint,
            axisCaption: l10n.loadAxisCaption,
            timeLabels: [
              l10n.loadAxisHoursAgo(24),
              l10n.loadAxisHoursAgo(12),
              l10n.loadAxisNow,
            ],
            locale: locale,
            height: 140,
            semanticsLabel: l10n.organExposureNow(current),
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(l10n.organExposureMeaning, style: theme.textTheme.bodySmall),
          const SizedBox(height: HalenSpace.x3),
          Text(
            _acute(organKey, l10n),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: HalenSpace.x2),
          Text(
            l10n.organExposureLoads(loads),
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  static String _loadName(LoadKind kind, AppLocalizations l10n) =>
      switch (kind) {
        LoadKind.nicotineAcute => l10n.loadNicotineAcute,
        LoadKind.nicotineBaseline => l10n.loadNicotineBaseline,
        LoadKind.carbonMonoxide => l10n.loadCarbonMonoxide,
        LoadKind.tarCumulative => l10n.loadTar,
      };

  static String _acute(String organKey, AppLocalizations l10n) =>
      switch (organKey) {
        'heart' => l10n.organAcuteHeart,
        'bloodVessels' => l10n.organAcuteVessels,
        'lungs' || 'mouth' => l10n.organAcuteLungs,
        'brain' => l10n.organAcuteBrain,
        'skin' => l10n.organAcuteBlood,
        _ => l10n.organAcuteGeneral,
      };
}
