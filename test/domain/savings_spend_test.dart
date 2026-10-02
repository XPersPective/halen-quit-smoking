import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/savings_ledger.dart';
import 'package:halen/domain/spend_summary.dart';

void main() {
  group('SavingsLedger', () {
    test('first day: 4 cigarettes in a row save nothing (owner 2026-10-02)', () {
      final ledger = SavingsLedger.from(
        baselineCpd: 20,
        startKey: '2026-10-02',
        todayKey: '2026-10-02',
        rows: const [LedgerRow(dateKey: '2026-10-02', count: 4)],
      );
      expect(ledger.avoided, 0);
      expect(ledger.trackedDays, 0);
    });

    test('empty days are unknown, not "all avoided"', () {
      // 90 days of nothing but one engaged yesterday (smoked 15 of 20).
      final ledger = SavingsLedger.from(
        baselineCpd: 20,
        startKey: '2026-07-04',
        todayKey: '2026-10-02',
        rows: const [LedgerRow(dateKey: '2026-10-01', count: 15)],
      );
      expect(ledger.avoided, 5); // not 90 * 20 - 15 = 1785
      expect(ledger.smoked, 15);
      expect(ledger.trackedDays, 1);
    });

    test('a resisted-only day is a genuine zero day', () {
      final ledger = SavingsLedger.from(
        baselineCpd: 20,
        startKey: '2026-09-01',
        todayKey: '2026-10-02',
        rows: const [LedgerRow(dateKey: '2026-09-30', count: 0, resisted: 3)],
      );
      expect(ledger.avoided, 20);
      expect(ledger.trackedDays, 1);
    });

    test('going over baseline never produces negative savings', () {
      final ledger = SavingsLedger.from(
        baselineCpd: 20,
        startKey: '2026-09-01',
        todayKey: '2026-10-02',
        rows: const [
          LedgerRow(dateKey: '2026-09-29', count: 30),
          LedgerRow(dateKey: '2026-09-30', count: 10),
        ],
      );
      expect(ledger.avoided, 10);
    });

    test('days before the start day are ignored', () {
      final ledger = SavingsLedger.from(
        baselineCpd: 20,
        startKey: '2026-09-30',
        todayKey: '2026-10-02',
        rows: const [LedgerRow(dateKey: '2026-09-01', count: 1)],
      );
      expect(ledger.avoided, 0);
    });
  });

  group('SpendSummary', () {
    SpendSummary build({double? years = 10, List<SpendDay>? days}) =>
        SpendSummary.compute(
          days: days ?? const [],
          now: DateTime(2026, 10, 2, 14),
          pricePerPack: 100,
          packSize: 20,
          startKey: '2026-10-02',
          declaredCpd: 20,
          smokingYears: years,
        );

    test('10 years x 20 a day at 5 per cigarette is about 365 thousand', () {
      final s = build();
      expect(s.perCigarette, 5);
      expect(s.declaredCigarettes, 73050);
      expect(s.declaredTotal, closeTo(365250, 0.5));
      expect(s.lifetimeTotal, closeTo(365250, 0.5));
      // 73050 cigarettes x 5 min = 365250 min = ~253.7 days.
      expect(s.lifetimeTimeSmoking!.inDays, 253);
    });

    test('unknown years give no lifetime figure (ask, never invent)', () {
      final s = build(years: null);
      expect(s.lifetimeTotal, isNull);
      expect(s.lifetimeTimeSmoking, isNull);
    });

    test('today, week and month windows use recorded days only', () {
      final s = build(days: const [
        SpendDay(dateKey: '2026-10-02', count: 4),
        SpendDay(dateKey: '2026-09-28', count: 10),
        SpendDay(dateKey: '2026-09-10', count: 20),
      ]);
      expect(s.todayCount, 4);
      expect(s.today, 20);
      // startKey is 2026-10-02, so earlier rows are pre-Halen and excluded.
      expect(s.week, 20);
      expect(s.recordedTotal, 20);
    });

    test('lifetime adds recorded spend to the declared history', () {
      final s = build(days: const [SpendDay(dateKey: '2026-10-02', count: 4)]);
      expect(s.lifetimeTotal, closeTo(365250 + 20, 0.5));
    });
  });
}
