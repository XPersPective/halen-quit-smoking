import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/body_load_model.dart';

void main() {
  final t0 = DateTime(2026, 9, 8, 8);
  const model = BodyLoadModel();

  group('BodyLoadModel decay', () {
    test('each curve halves after its own half-life', () {
      for (final kind in LoadKind.values) {
        final halfLife = model.halfLifeHoursFor(kind);
        final at0 = model.rawAt(kind, t0, [t0]);
        final atHalf = model.rawAt(
          kind,
          t0.add(Duration(minutes: (halfLife * 60).round())),
          [t0],
        );
        expect(atHalf, closeTo(at0 / 2, 1e-6), reason: kind.name);
      }
    });

    test('future doses are not counted', () {
      expect(model.rawAt(LoadKind.nicotineAcute, t0, [t0.add(const Duration(hours: 1))]), 0);
    });

    test('doses accumulate', () {
      final one = model.rawAt(LoadKind.nicotineAcute, t0, [t0]);
      final two = model.rawAt(LoadKind.nicotineAcute, t0, [t0, t0]);
      expect(two, closeTo(one * 2, 1e-9));
    });

    test('CO clears faster than the cotinine baseline', () {
      final after8h = t0.add(const Duration(hours: 8));
      final co = model.rawAt(LoadKind.carbonMonoxide, after8h, [t0]);
      final baseline = model.rawAt(LoadKind.nicotineBaseline, after8h, [t0]);
      expect(co, lessThan(baseline));
    });
  });

  group('normalization', () {
    test('normalized curve peaks at 100 and never exceeds it', () {
      final samples = model.normalizedCurve(
        LoadKind.nicotineAcute,
        t0,
        t0.add(const Duration(hours: 12)),
        [t0.add(const Duration(hours: 2))],
      );
      expect(samples.map((s) => s.value).reduce((a, b) => a > b ? a : b), 100);
      expect(samples.every((s) => s.value >= 0 && s.value <= 100), isTrue);
    });

    test('no events yields an all-zero curve', () {
      final samples = model.normalizedCurve(
        LoadKind.nicotineAcute,
        t0,
        t0.add(const Duration(hours: 4)),
        const [],
      );
      expect(samples.every((s) => s.value == 0), isTrue);
    });
  });

  group('metabolism calibration', () {
    test('fast metabolism leaves less nicotine than slow at the same time', () {
      const fast = BodyLoadModel(metabolism: MetabolismSpeed.fast);
      const slow = BodyLoadModel(metabolism: MetabolismSpeed.slow);
      final at = t0.add(const Duration(hours: 3));
      expect(
        fast.rawAt(LoadKind.nicotineAcute, at, [t0]),
        lessThan(slow.rawAt(LoadKind.nicotineAcute, at, [t0])),
      );
    });

    test('calibration does not touch the CO curve', () {
      const fast = BodyLoadModel(metabolism: MetabolismSpeed.fast);
      expect(
        fast.halfLifeHoursFor(LoadKind.carbonMonoxide),
        LoadKind.carbonMonoxide.halfLifeHours,
      );
    });
  });

  group('snapshot', () {
    test('reports time since the last cigarette and a falling CO load', () {
      final now = t0.add(const Duration(hours: 6, minutes: 20));
      final snap = model.snapshot(now, [t0]);
      expect(snap.sinceLast, const Duration(hours: 6, minutes: 20));
      expect(snap.coDropPercent, greaterThan(0));
      expect(snap.values.keys.length, LoadKind.values.length);
    });

    test('no records yields a null sinceLast', () {
      expect(model.snapshot(t0, const []).sinceLast, isNull);
    });
  });

  group('tar load vs baseline', () {
    test('is 0 without a baseline', () {
      expect(
        model.tarLoadVsBaseline(now: t0, events: [t0], baselineCpd: 0),
        0,
      );
    });

    test('rises with more cigarettes and stays within 0..100', () {
      final few = model.tarLoadVsBaseline(
        now: t0,
        events: List.filled(5, t0),
        baselineCpd: 20,
      );
      final many = model.tarLoadVsBaseline(
        now: t0,
        events: List.filled(50, t0),
        baselineCpd: 20,
      );
      expect(few, lessThan(many));
      expect(many, lessThanOrEqualTo(100));
      expect(few, greaterThanOrEqualTo(0));
    });
  });

  test('bands split the 0-100 range into low/medium/high', () {
    expect(bandFor(0), LoadBand.low);
    expect(bandFor(50), LoadBand.medium);
    expect(bandFor(100), LoadBand.high);
  });
}
