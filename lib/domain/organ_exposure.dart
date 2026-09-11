/// Which modelled loads reach which organ (device feedback, item 5).
///
/// The body map had one population figure per organ and nothing that moved
/// with the person's own smoking. This maps each organ to the loads the
/// literature ties it to, so each organ can have its own 24-hour curve built
/// from the same timestamps as everything else:
///
///  * heart — nicotine (heart rate, blood pressure) and carbon monoxide
///    (less oxygen delivered to the muscle doing the extra work);
///  * blood vessels — nicotine (vasoconstriction);
///  * brain — nicotine;
///  * lungs and mouth — tar (direct deposit) and carbon monoxide;
///  * skin — nicotine (narrowed vessels) and carbon monoxide;
///  * everything else — the systemic toxicant load, carried by the tar curve.
///
/// The weights say how much of the curve each load contributes. They are a
/// visual mapping, not a dose-response model, and the screen shows them
/// ("Driven by: nicotine, carbon monoxide") rather than hiding them.
library;

import 'body_load_model.dart';

class OrganLoadMix {
  const OrganLoadMix(this.weights);

  final Map<LoadKind, double> weights;

  Iterable<LoadKind> get kinds => weights.keys;
}

const Map<String, OrganLoadMix> organLoadMixes = {
  'heart': OrganLoadMix({
    LoadKind.nicotineAcute: 0.6,
    LoadKind.carbonMonoxide: 0.4,
  }),
  'bloodVessels': OrganLoadMix({LoadKind.nicotineAcute: 1.0}),
  'brain': OrganLoadMix({LoadKind.nicotineAcute: 1.0}),
  'lungs': OrganLoadMix({
    LoadKind.tarCumulative: 0.5,
    LoadKind.carbonMonoxide: 0.5,
  }),
  'mouth': OrganLoadMix({
    LoadKind.tarCumulative: 0.7,
    LoadKind.carbonMonoxide: 0.3,
  }),
  'skin': OrganLoadMix({
    LoadKind.nicotineAcute: 0.5,
    LoadKind.carbonMonoxide: 0.5,
  }),
};

/// Everything not listed above takes the systemic toxicant load.
const OrganLoadMix defaultOrganMix =
    OrganLoadMix({LoadKind.tarCumulative: 0.6, LoadKind.carbonMonoxide: 0.4});

OrganLoadMix mixFor(String organKey) =>
    organLoadMixes[organKey] ?? defaultOrganMix;

/// One organ's 24-hour curve: the weighted sum of each contributing load's
/// normalised curve, renormalised so the organ's own peak is 100.
List<LoadSample> organCurve({
  required BodyLoadModel model,
  required String organKey,
  required DateTime start,
  required DateTime end,
  required List<DateTime> events,
}) {
  final mix = mixFor(organKey);
  List<LoadSample>? base;
  final sums = <double>[];
  mix.weights.forEach((kind, weight) {
    final curve = model.normalizedCurve(kind, start, end, events);
    base ??= curve;
    for (var i = 0; i < curve.length; i++) {
      if (sums.length <= i) {
        sums.add(0);
      }
      sums[i] += weight * curve[i].value;
    }
  });
  if (base == null || sums.isEmpty) {
    return const [];
  }
  final peak = sums.fold<double>(0, (a, b) => a > b ? a : b);
  return [
    for (var i = 0; i < sums.length; i++)
      LoadSample(
        at: base![i].at,
        value: peak <= 0 ? 0 : (sums[i] / peak * 100).round().clamp(0, 100),
      ),
  ];
}
