/// S3-class craving-window model (module report §4).
///
/// The evidence this encodes: craving rises as nicotine FALLS (the trough),
/// not as it rises; heavier baseline exposure means deeper troughs; and
/// conditioned cues modulate urges independently of nicotine. So the risk
/// score mixes three signals with published, user-visible weights:
///
///   0.45 · trough depth (body-load model)
///   0.35 · the user's own hour-of-day pattern
///   0.20 · trigger context at that hour
///
/// Everything here is derived from the user's own records (S2) through a
/// transparent formula (S3). It is a forecast of *risk*, never a claim about
/// the body. Below [minEventsForWindows] records the model refuses to answer
/// rather than inventing a pattern (module report §15 rule 7).
library;

import 'dart:math' as math;

import 'body_load_model.dart';

/// Published component weights — the "How is this calculated?" screen reads
/// these directly so the screen can never drift from the formula.
abstract final class CravingRiskWeights {
  static const double trough = 0.45;
  static const double hourPattern = 0.35;
  static const double triggerContext = 0.20;
}

/// Minimum number of records before an hour-of-day pattern is meaningful.
const int minEventsForWindows = 21;

/// Minimum number of records before per-hour risk windows are offered.
const int minEventsForRiskCurve = 30;

/// Risk band shown to the user (never a bare number alone).
enum RiskBand { calm, watch, high }

RiskBand riskBandFor(int score) {
  if (score < 34) {
    return RiskBand.calm;
  }
  return score < 67 ? RiskBand.watch : RiskBand.high;
}

/// A high-risk stretch of the day.
class RiskWindow {
  const RiskWindow({
    required this.startHour,
    required this.endHour,
    required this.score,
  });

  /// Inclusive start hour, 0–23.
  final int startHour;

  /// Exclusive end hour, 1–24.
  final int endHour;

  /// Peak risk score inside the window (0–100).
  final int score;
}

/// Craving-risk forecaster built from the user's own history.
class CravingRiskModel {
  CravingRiskModel({
    required this.events,
    required this.hourlyHistogram,
    required this.triggerHourWeights,
    BodyLoadModel? loadModel,
  })  : assert(hourlyHistogram.length == 24, 'hourlyHistogram needs 24 values'),
        _load = loadModel ?? const BodyLoadModel();

  /// All cigarette timestamps (S2).
  final List<DateTime> events;

  /// Hour-of-day counts over the recent window, 24 entries.
  final List<int> hourlyHistogram;

  /// Per-hour share of records carrying a trigger label, 24 entries in 0..1.
  final List<double> triggerHourWeights;

  final BodyLoadModel _load;

  /// True when there is enough data for the hour-based signals to mean
  /// anything. Below this the UI must show an empty state, not a chart.
  bool get hasEnoughData => events.length >= minEventsForWindows;

  /// Median gap between consecutive cigarettes, in minutes; null when the
  /// user has fewer than two records.
  int? get medianGapMinutes {
    if (events.length < 2) {
      return null;
    }
    final sorted = [...events]..sort();
    final gaps = [
      for (var i = 1; i < sorted.length; i++)
        sorted[i].difference(sorted[i - 1]).inMinutes,
    ]..sort();
    final mid = gaps.length ~/ 2;
    return gaps.length.isOdd
        ? gaps[mid]
        : ((gaps[mid - 1] + gaps[mid]) / 2).round();
  }

  /// Trough component: how deep the nicotine dip is right now, 0..1.
  /// 0 = just smoked, 1 = far past the user's own usual interval.
  double troughSignal(DateTime at) {
    final past = events.where((e) => !e.isAfter(at)).toList()..sort();
    if (past.isEmpty) {
      return 0;
    }
    final sinceLast = at.difference(past.last).inMinutes;
    final median = medianGapMinutes;
    if (median == null || median <= 0) {
      // No rhythm yet — fall back to the modelled decay alone.
      return 1 - _load.normalizedNow(LoadKind.nicotineAcute, at, past) / 100;
    }
    return (sinceLast / median).clamp(0.0, 1.5) / 1.5;
  }

  /// Hour-pattern component: how heavy this hour is in the user's own
  /// histogram, 0..1 against the busiest hour.
  double hourSignal(DateTime at) {
    if (!hasEnoughData) {
      return 0;
    }
    final peak = hourlyHistogram.fold<int>(0, math.max);
    if (peak <= 0) {
      return 0;
    }
    return hourlyHistogram[at.hour] / peak;
  }

  /// Trigger-context component: share of this hour's records that carried a
  /// trigger label, 0..1.
  double triggerSignal(DateTime at) {
    if (!hasEnoughData || triggerHourWeights.length != 24) {
      return 0;
    }
    return triggerHourWeights[at.hour].clamp(0.0, 1.0);
  }

  /// Composite risk score 0–100 at [at].
  int riskAt(DateTime at) {
    final score = CravingRiskWeights.trough * troughSignal(at) +
        CravingRiskWeights.hourPattern * hourSignal(at) +
        CravingRiskWeights.triggerContext * triggerSignal(at);
    return (score * 100).round().clamp(0, 100);
  }

  /// Risk for every hour of the local day containing [day], 24 entries.
  List<int> riskCurveForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    return [
      for (var h = 0; h < 24; h++)
        riskAt(start.add(Duration(hours: h, minutes: 30))),
    ];
  }

  /// The [count] riskiest contiguous stretches of the day, highest first.
  /// Empty until [minEventsForRiskCurve] records exist.
  List<RiskWindow> topRiskWindows(DateTime day, {int count = 2}) {
    if (events.length < minEventsForRiskCurve) {
      return const [];
    }
    final curve = riskCurveForDay(day);
    final peak = curve.fold<int>(0, math.max);
    if (peak <= 0) {
      return const [];
    }
    final threshold = peak * 0.7;
    final windows = <RiskWindow>[];
    var start = -1;
    var best = 0;
    for (var h = 0; h < 24; h++) {
      final above = curve[h] >= threshold;
      if (above && start < 0) {
        start = h;
        best = curve[h];
      } else if (above) {
        best = math.max(best, curve[h]);
      } else if (start >= 0) {
        windows.add(RiskWindow(startHour: start, endHour: h, score: best));
        start = -1;
      }
    }
    if (start >= 0) {
      windows.add(RiskWindow(startHour: start, endHour: 24, score: best));
    }
    windows.sort((a, b) => b.score.compareTo(a.score));
    return windows.take(count).toList();
  }
}

/// Share of cravings that arrived while the acute nicotine load sat in its
/// lowest third — the single sentence that makes this module land:
/// "71% of your cravings came when your load was in the lowest third."
/// Null when there are too few craving records to say anything.
double? cravingsInLowestThird({
  required List<DateTime> cravings,
  required List<DateTime> events,
  BodyLoadModel model = const BodyLoadModel(),
  int minCravings = 10,
}) {
  if (cravings.length < minCravings) {
    return null;
  }
  var inLowest = 0;
  for (final craving in cravings) {
    final value = model.normalizedNow(LoadKind.nicotineAcute, craving, events);
    if (value < 34) {
      inLowest++;
    }
  }
  return inLowest / cravings.length;
}

/// Two-item Heaviness of Smoking Index (HSI, 0–6): cigarettes per day and
/// time to first cigarette. The only validated psychometric instrument in
/// the product; always cited where it is shown.
int heavinessOfSmokingIndex({
  required int cigarettesPerDay,
  required int minutesToFirstCigarette,
}) {
  final cpdPoints = cigarettesPerDay <= 10
      ? 0
      : cigarettesPerDay <= 20
          ? 1
          : cigarettesPerDay <= 30
              ? 2
              : 3;
  final ttfcPoints = minutesToFirstCigarette <= 5
      ? 3
      : minutesToFirstCigarette <= 30
          ? 2
          : minutesToFirstCigarette <= 60
              ? 1
              : 0;
  return cpdPoints + ttfcPoints;
}
