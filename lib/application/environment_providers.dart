import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/environment_impact.dart';
import 'module_providers.dart';
import 'stats_providers.dart';

/// Cigarettes not smoked and money not spent, for the environment card.
class EnvironmentView {
  const EnvironmentView({required this.impact, required this.saved});

  final EnvironmentImpact impact;
  final double saved;
}

/// Counts avoided cigarettes exactly the way the economy screen does — the
/// user's measured baseline minus each day's count, over the last 90 days —
/// so the tree figure and the money figure can never disagree.
final environmentProvider = Provider<AsyncValue<EnvironmentView>>((ref) {
  final economy = ref.watch(economyProvider).value;
  final baseline = ref.watch(measuredBaselineProvider).value;
  return ref.watch(dailyStatsProvider(90)).whenData((stats) {
    final base = baseline ?? 0;
    final avoided = stats.fold<int>(
      0,
      (sum, d) => sum + math.max(0, (base - d.count).round()),
    );
    return EnvironmentView(
      impact: EnvironmentImpact(cigarettesAvoided: avoided),
      saved: economy?.saved(avoided) ?? 0,
    );
  });
});
