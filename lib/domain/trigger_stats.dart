/// S3-class trigger pattern statistics (report §19).
///
/// Safety rules enforced here:
///  - silent below n ≥ 10 observations (the UI shows nothing);
///  - output is a conditional probability observation ("görünüyor"),
///    never a causal claim.
library;

import 'entities.dart';

class TriggerStats {
  const TriggerStats({this.minObservations = 10, this.windowMinutes = 15});

  /// Minimum labeled observations before any pattern is reported.
  final int minObservations;

  /// Post-trigger risk window ("sonraki 15 dk").
  final int windowMinutes;

  /// For each trigger label with enough observations, the share of its
  /// occurrences followed by a cigarette inside [windowMinutes].
  /// Labels below [minObservations] are absent — silence is the contract.
  Map<TriggerLabel, double> riskShares({
    required List<TriggerObservation> observations,
  }) {
    final counts = <TriggerLabel, int>{};
    final followed = <TriggerLabel, int>{};
    for (final obs in observations) {
      counts[obs.label] = (counts[obs.label] ?? 0) + 1;
      if (obs.followedByCigaretteWithin(Duration(minutes: windowMinutes))) {
        followed[obs.label] = (followed[obs.label] ?? 0) + 1;
      }
    }
    return {
      for (final entry in counts.entries)
        if (entry.value >= minObservations)
          entry.key: (followed[entry.key] ?? 0) / entry.value,
    };
  }
}

/// One labeled moment (a craving record or a cigarette with a tag).
class TriggerObservation {
  const TriggerObservation({
    required this.label,
    required this.at,
    this.nextCigaretteAt,
  });

  final TriggerLabel label;
  final DateTime at;
  final DateTime? nextCigaretteAt;

  bool followedByCigaretteWithin(Duration window) {
    final next = nextCigaretteAt;
    if (next == null) {
      return false;
    }
    final delta = next.difference(at);
    return !delta.isNegative && delta <= window;
  }
}
