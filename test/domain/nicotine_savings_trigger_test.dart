import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/domain/nicotine_model.dart';
import 'package:halen/domain/savings.dart';
import 'package:halen/domain/trigger_stats.dart';

void main() {
  group('NicotineModel', () {
    const model = NicotineModel();

    test('one cigarette decays by half every 2 hours', () {
      final t0 = DateTime(2026, 9, 7, 8);
      final one = model.proxyAt(t0, [t0]);
      final after2h = model.proxyAt(t0.add(const Duration(hours: 2)), [t0]);
      final after4h = model.proxyAt(t0.add(const Duration(hours: 4)), [t0]);
      expect(one, closeTo(1.2, 1e-9));
      expect(after2h, closeTo(0.6, 1e-9));
      expect(after4h, closeTo(0.3, 1e-9));
    });

    test('doses superpose', () {
      final t0 = DateTime(2026, 9, 7, 8);
      final c = model.proxyAt(
        t0.add(const Duration(hours: 2)),
        [t0, t0.add(const Duration(hours: 2))],
      );
      expect(c, closeTo(0.6 + 1.2, 1e-9));
    });

    test('future doses do not count', () {
      final t0 = DateTime(2026, 9, 7, 8);
      expect(model.proxyAt(t0, [t0.add(const Duration(hours: 1))]), 0);
    });

    test('normalized curve stays within 0–100 and peaks at 100', () {
      final start = DateTime(2026, 9, 7, 8);
      final events = [
        start,
        start.add(const Duration(minutes: 90)),
        start.add(const Duration(hours: 5)),
      ];
      final curve = model.normalizedCurve(
        start,
        start.add(const Duration(hours: 12)),
        events,
      );
      expect(curve, everyElement(inExclusiveRange(-1, 101)));
      expect(curve.reduce((a, b) => a > b ? a : b), 100);
    });

    test('empty day normalizes to all zeros (no absolute values)', () {
      final start = DateTime(2026, 9, 7, 8);
      final curve = model.normalizedCurve(
        start,
        start.add(const Duration(hours: 4)),
        const [],
      );
      expect(curve, everyElement(0));
    });

    test('quit decay halves every half-life step', () {
      final curve = model.quitDecayCurve(hours: 4, stepMinutes: 120);
      expect(curve[0], 100);
      expect(curve[1], 50);
      expect(curve[2], 25);
    });
  });

  group('Savings', () {
    test('per cigarette = pack price / pack size', () {
      const s = Savings(pricePerPack: 100, packSize: 20);
      expect(s.perCigarette, closeTo(5.0, 1e-9));
      expect(s.forAvoided(3), closeTo(15.0, 1e-9));
    });

    test('guards against zero pack size', () {
      const s = Savings(pricePerPack: 100, packSize: 0);
      expect(s.perCigarette, 0);
      expect(s.forAvoided(5), 0);
    });

    test('packs equivalent framing', () {
      const s = Savings(pricePerPack: 100, packSize: 20);
      expect(s.packsEquivalent(250), closeTo(2.5, 1e-9));
    });
  });

  group('TriggerStats', () {
    final base = DateTime(2026, 9, 1, 8);

    List<TriggerObservation> coffeeObservations({
      required int total,
      required int followed,
    }) =>
        [
          for (var i = 0; i < total; i++)
            TriggerObservation(
              label: TriggerLabel.coffee,
              at: base.add(Duration(days: i)),
              nextCigaretteAt: i < followed
                  ? base.add(Duration(days: i, minutes: 10))
                  : null,
            ),
        ];

    test('silent below n≥10 — no keys at all', () {
      const stats = TriggerStats();
      final shares = stats.riskShares(
        observations: coffeeObservations(total: 9, followed: 9),
      );
      expect(shares, isEmpty);
    });

    test('reports share once n≥10', () {
      const stats = TriggerStats();
      final shares = stats.riskShares(
        observations: coffeeObservations(total: 10, followed: 4),
      );
      expect(shares[TriggerLabel.coffee], closeTo(0.4, 1e-9));
    });

    test('window boundary: cigarette at exactly 15 min counts, 16 does not',
        () {
      const stats = TriggerStats(minObservations: 1);
      final atEdge = stats.riskShares(observations: [
        TriggerObservation(
          label: TriggerLabel.stress,
          at: base,
          nextCigaretteAt: base.add(const Duration(minutes: 15)),
        ),
      ]);
      expect(atEdge[TriggerLabel.stress], 1.0);

      final outside = stats.riskShares(observations: [
        TriggerObservation(
          label: TriggerLabel.stress,
          at: base,
          nextCigaretteAt: base.add(const Duration(minutes: 16)),
        ),
      ]);
      expect(outside[TriggerLabel.stress], 0.0);
    });
  });
}
