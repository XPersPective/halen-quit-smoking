/// S3-class body-load model (module report §1).
///
/// Four exponential-decay curves fed by the user's own timestamped records.
/// Honesty rules baked into the shape of this file:
///  - every cigarette contributes a fixed 1.2 mg systemic-absorption
///    assumption (Benowitz: 1–1.5 mg);
///  - each curve is C(t) = Σ dose · 2^(−Δt / t½);
///  - the UI may only render curves NORMALIZED to 0–100 — absolute ng/mL,
///    mg of tar or COHb percentages are never produced for display (S5);
///  - the tar curve is explicitly representative (S4): particle load cannot
///    be measured, so it is always relative to the user's own baseline.
///
/// Half-lives:
///  - nicotine (acute) 2 h — plasma nicotine, inter-individual 1–4 h (CYP2A6)
///  - nicotine baseline 16 h — cotinine proxy, the "all-day floor"
///  - carbon monoxide 4.5 h — exhaled CO, mono-exponential decay
///  - tar 30 days — representative slow particle clearance (S4)
library;

import 'dart:math' as math;

/// The four modelled loads. Each is a separate curve over the same events.
enum LoadKind {
  /// Plasma nicotine proxy — drives the craving-window model.
  nicotineAcute(halfLifeHours: 2.0, isRepresentative: false),

  /// Cotinine proxy — the all-day floor that falls over the first days.
  nicotineBaseline(halfLifeHours: 16.0, isRepresentative: false),

  /// Exhaled carbon monoxide proxy — the hero of the first 24 hours.
  carbonMonoxide(halfLifeHours: 4.5, isRepresentative: false),

  /// Cumulative particle ("tar") load — representative only (S4).
  tarCumulative(halfLifeHours: 720.0, isRepresentative: true);

  const LoadKind({required this.halfLifeHours, required this.isRepresentative});

  /// Elimination half-life in hours used by the decay model.
  final double halfLifeHours;

  /// True when no measurable biological quantity backs this curve, so the
  /// UI must label it as representative rather than modelled-from-evidence.
  final bool isRepresentative;
}

/// Optional user calibration of nicotine clearance ("how fast do you feel it
/// leave?"). Never a measurement — the default is [normal] and the UI says so.
enum MetabolismSpeed {
  slow(3.0),
  normal(2.0),
  fast(1.3);

  const MetabolismSpeed(this.acuteHalfLifeHours);

  /// Replaces [LoadKind.nicotineAcute]'s half-life when set.
  final double acuteHalfLifeHours;
}

/// Load band shown instead of a raw number on axes and summaries.
enum LoadBand { low, medium, high }

LoadBand bandFor(int normalized) {
  if (normalized < 34) {
    return LoadBand.low;
  }
  return normalized < 67 ? LoadBand.medium : LoadBand.high;
}

/// One sample of a normalized curve.
class LoadSample {
  const LoadSample({required this.at, required this.value});

  /// Sample time.
  final DateTime at;

  /// Normalized 0–100 value.
  final int value;
}

/// Summary of "what is in me right now" for the top-of-screen sentence.
class BodyLoadSnapshot {
  const BodyLoadSnapshot({
    required this.sinceLast,
    required this.nicotinePercentOfPeak,
    required this.coPercentOfPeak,
    required this.values,
    this.tarMgToday = 0,
    this.tarDropsToday = 0.0,
    this.weightKg,
    this.tarPerCigarette = 10.0,
    this.nicotinePerCigarette = 0.8,
  });

  /// Time since the last recorded cigarette; null when there is none.
  final Duration? sinceLast;

  /// Current acute nicotine load as a percentage of the 24 h peak (0–100).
  final int nicotinePercentOfPeak;

  /// Current CO load as a percentage of the 24 h peak (0–100).
  final int coPercentOfPeak;

  /// Normalized current value per curve (0–100).
  final Map<LoadKind, int> values;

  /// Today's cumulative inhaled tar in milligrams.
  final int tarMgToday;

  /// Today's cumulative tar expressed in physical drops (~50 mg per drop).
  final double tarDropsToday;

  /// User's body weight in kg, if entered.
  final double? weightKg;

  /// Tar per cigarette from pack, or standard legal default (10 mg).
  final double tarPerCigarette;

  /// Nicotine per cigarette from pack, or standard default (0.8 mg).
  final double nicotinePerCigarette;

  /// How much the CO load has fallen from its 24 h peak (0–100).
  int get coDropPercent => 100 - coPercentOfPeak;
}

/// Exponential-decay load engine (module report §1.⑤).
class BodyLoadModel {
  const BodyLoadModel({
    this.absorptionPerCigarette = 1.2,
    this.metabolism = MetabolismSpeed.normal,
    this.weightKg,
    this.tarPerCigarette = 10.0,
    this.nicotinePerCigarette = 0.8,
  });

  /// Assumed systemic absorption per cigarette, in model units (mg).
  final double absorptionPerCigarette;

  /// User-chosen clearance calibration for the acute nicotine curve.
  final MetabolismSpeed metabolism;

  /// User body weight in kg for volume of distribution scaling (Vd ~ 2.6 L/kg).
  final double? weightKg;

  /// Yield of tar per cigarette in mg from pack (default 10 mg).
  final double tarPerCigarette;

  /// Yield of nicotine per cigarette in mg from pack (default 0.8 mg).
  final double nicotinePerCigarette;

  /// Effective absorption scaled by body weight distribution volume and pack yields.
  double get effectiveAbsorption {
    final weightScale = weightKg != null && weightKg! > 30 ? (70.0 / weightKg!) : 1.0;
    final packScale = (nicotinePerCigarette / 0.8).clamp(0.4, 2.0);
    return (absorptionPerCigarette * packScale * weightScale).clamp(0.4, 2.5);
  }

  double halfLifeHoursFor(LoadKind kind) => kind == LoadKind.nicotineAcute
      ? metabolism.acuteHalfLifeHours
      : kind.halfLifeHours;

  /// Raw proxy concentration at [at] from cigarettes smoked at [events].
  /// Arbitrary units proportional to the absorbed dose — never displayed.
  double rawAt(LoadKind kind, DateTime at, List<DateTime> events) {
    final halfLife = halfLifeHoursFor(kind);
    final dose = kind == LoadKind.nicotineAcute
        ? effectiveAbsorption
        : kind == LoadKind.tarCumulative
            ? tarPerCigarette
            : absorptionPerCigarette;
    var c = 0.0;
    for (final ts in events) {
      final deltaHours = at.difference(ts).inMicroseconds / 3.6e9;
      if (deltaHours < 0) {
        continue; // Future dose — not yet in the body.
      }
      c += dose * math.pow(0.5, deltaHours / halfLife);
    }
    return c;
  }

  /// Raw curve from [start] to [end] inclusive, sampled every [stepMinutes].
  List<double> rawCurve(
    LoadKind kind,
    DateTime start,
    DateTime end,
    List<DateTime> events, {
    int stepMinutes = 15,
  }) {
    final curve = <double>[];
    var t = start;
    while (!t.isAfter(end)) {
      curve.add(rawAt(kind, t, events));
      t = t.add(Duration(minutes: stepMinutes));
    }
    return curve;
  }

  /// The only curve the UI may render: normalized to 0–100 against the peak
  /// of the same window. An all-zero window stays all-zero.
  List<LoadSample> normalizedCurve(
    LoadKind kind,
    DateTime start,
    DateTime end,
    List<DateTime> events, {
    int stepMinutes = 15,
  }) {
    final raw = rawCurve(kind, start, end, events, stepMinutes: stepMinutes);
    final peak = raw.fold<double>(0, math.max);
    return [
      for (var i = 0; i < raw.length; i++)
        LoadSample(
          at: start.add(Duration(minutes: i * stepMinutes)),
          value: peak <= 0 ? 0 : (raw[i] / peak * 100).round().clamp(0, 100),
        ),
    ];
  }

  /// Current value normalized against the peak of the trailing [window].
  int normalizedNow(
    LoadKind kind,
    DateTime now,
    List<DateTime> events, {
    Duration window = const Duration(hours: 24),
  }) {
    final samples = normalizedCurve(kind, now.subtract(window), now, events);
    return samples.isEmpty ? 0 : samples.last.value;
  }

  /// "What is in me right now" summary for the Body Load card header.
  BodyLoadSnapshot snapshot(DateTime now, List<DateTime> events) {
    final past = events.where((e) => !e.isAfter(now)).toList()..sort();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayCount = past.where((e) => !e.isBefore(todayStart)).length;
    final tarMg = (todayCount * tarPerCigarette).round();
    final tarDrops = tarMg / 50.0; // ~50 mg tar condensate per standard drop

    return BodyLoadSnapshot(
      sinceLast: past.isEmpty ? null : now.difference(past.last),
      nicotinePercentOfPeak: normalizedNow(LoadKind.nicotineAcute, now, past),
      coPercentOfPeak: normalizedNow(LoadKind.carbonMonoxide, now, past),
      tarMgToday: tarMg,
      tarDropsToday: tarDrops,
      weightKg: weightKg,
      tarPerCigarette: tarPerCigarette,
      nicotinePerCigarette: nicotinePerCigarette,
      values: {
        for (final kind in LoadKind.values) kind: normalizedNow(kind, now, past),
      },
    );
  }

  /// Representative post-quit decay for a curve (S3/S4 display only):
  /// normalized 0–100 falling from a steady state after the last cigarette.
  /// Used on quit-day cards — never as a personal measurement.
  List<int> quitDecayCurve(
    LoadKind kind, {
    int hours = 48,
    int stepMinutes = 60,
  }) {
    final halfLife = halfLifeHoursFor(kind);
    return [
      for (var m = 0; m <= hours * 60; m += stepMinutes)
        (math.pow(0.5, m / 60.0 / halfLife) * 100).round().clamp(0, 100),
    ];
  }

  /// Relative particle ("tar") load against the user's own baseline intake:
  /// 100 = the load a user smoking [baselineCpd] per day would carry at
  /// steady state. Always S4 — never a milligram, never a percentage cleaned.
  int tarLoadVsBaseline({
    required DateTime now,
    required List<DateTime> events,
    required double baselineCpd,
  }) {
    if (baselineCpd <= 0) {
      return 0;
    }
    final actual = rawAt(LoadKind.tarCumulative, now, events);
    // Steady-state load for a constant daily rate r with half-life T:
    // Σ r·2^(−k·24/T) over k = 0..∞ = r / (1 − 2^(−24/T)).
    final decayPerDay = math.pow(
      0.5,
      24 / LoadKind.tarCumulative.halfLifeHours,
    ).toDouble();
    final steadyState =
        baselineCpd * absorptionPerCigarette / (1 - decayPerDay);
    if (steadyState <= 0) {
      return 0;
    }
    return (actual / steadyState * 100).round().clamp(0, 100);
  }
}
