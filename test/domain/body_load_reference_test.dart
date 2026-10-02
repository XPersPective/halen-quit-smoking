import 'package:flutter_test/flutter_test.dart';
import 'package:halen/domain/body_load_model.dart';

void main() {
  const model = BodyLoadModel();
  final now = DateTime(2026, 10, 2, 11);

  int rel(List<DateTime> events, {double cpd = 20}) =>
      model.relativeNow(LoadKind.nicotineAcute, now, events, cpd);

  test('one cigarette is a small share of a 20-a-day smoker\'s usual level', () {
    final r = rel([now.subtract(const Duration(minutes: 1))]);
    expect(r, lessThan(35));
  });

  test('four in four minutes is far more than one, still below a full usual '
      'day-peak, and nothing is pinned at 100 by construction', () {
    final one = rel([now.subtract(const Duration(minutes: 1))]);
    final four = rel([
      for (var i = 0; i < 4; i++) now.subtract(Duration(minutes: i)),
    ]);
    expect(four, greaterThan(one * 3));
    expect(four, lessThan(100));
  });

  test('a person smoking every 45 minutes sits near their own usual level', () {
    // 20 a day over 16 waking hours = every 48 min; the last ten hours of it.
    final events = [
      for (var i = 0; i < 13; i++) now.subtract(Duration(minutes: 48 * i)),
    ];
    final r = rel(events);
    expect(r, inInclusiveRange(70, 130));
  });

  test('the reference peak grows with the declared amount', () {
    final light = model.referencePeak(LoadKind.nicotineAcute, 5);
    final heavy = model.referencePeak(LoadKind.nicotineAcute, 30);
    expect(heavy, greaterThan(light * 2));
  });

  test('without a baseline the snapshot falls back to the 24 h peak', () {
    final snap = model.snapshot(now, [now.subtract(const Duration(minutes: 1))]);
    expect(snap.nicotinePercentOfPeak, 100);
    final rel1 = model.snapshot(
      now,
      [now.subtract(const Duration(minutes: 1))],
      baselineCpd: 20,
    );
    expect(rel1.nicotinePercentOfPeak, lessThan(35));
  });
}
