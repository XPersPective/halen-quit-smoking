// Simulates the full 8-week journey (first launch → quit day → first 72h)
// through the pure domain layer — the same code the app runs (report §14).
//
// Run:  dart run tool/simulate.dart
//
// The scenario follows the report's reference user: 15 cigarettes/day,
// standard pace (≈13.5%/week), realistic lapses. Every number the script
// prints is S3 (derived) — the printed script mirrors what the UI shows.

// CLI script: print is the intended output channel.
// ignore_for_file: avoid_print

library;

import 'package:halen/domain/entities.dart';
import 'package:halen/domain/plan_engine.dart';

void main() {
  const pace = Pace.standard;
  final speed = PlanSpeed.forPace(pace);
  var weeklyAvg = 15.0; // Onboarding baseline.

  print('Halen — 8-week adaptive taper simulation');
  print('Start: 15/day · pace: standard (${(speed.weeklyRate * 100).round()}%/week)');
  print('');

  var day = DateTime(2026, 9, 7);
  var quitDay = DateTime.now();
  var finalWeekAnnounced = false;

  for (var week = 1; week <= 8; week++) {
    final rawTarget = targetForDay(prevWeekAvg: weeklyAvg, speed: speed);
    final target = rawTarget < 4 ? (rawTarget < 3 ? 3 : rawTarget) : rawTarget;
    final phase = phaseForTarget(target);

    if (phase == PlanPhase.finalWeek && !finalWeekAnnounced) {
      finalWeekAnnounced = true;
      print('W$week: daily budget reached $target — FINAL WEEK.');
      print('      The plan asks the user to confirm a quit day (a plan,');
      print('      not a promise). Quit day confirmed for next Monday.');
      quitDay = day.add(const Duration(days: 7));
    }

    // Simulated real behavior: mostly on-plan, one lapse day per fortnight,
    // weekend bumps. The engine redistributes and softens (never punishes).
    final weekCounts = <int>[];
    for (var d = 0; d < 7; d++) {
      var smoked = target;
      final weekday = day.add(Duration(days: d)).weekday;
      if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
        smoked += 1; // Weekend bump → recalculation, no penalty UI.
      }
      if (week % 2 == 0 && weekday == DateTime.wednesday) {
        smoked += 2; // Stress day → clustered pattern message.
      }
      if (smoked > target) {
        final events = List.generate(smoked, (i) => day.add(Duration(hours: 8 + i * 2)));
        final result = redistributeDay(
          now: day.add(const Duration(hours: 20)),
          targetToday: target,
          smokedToday: smoked,
          dayEnd: day.add(const Duration(hours: 24)),
          todayEvents: events,
          medianGap: medianGapMinutes(events),
        );
        if (d == 0) {
          print('W$week: ${_msg(result.messageKey)}');
        }
      }
      weekCounts.add(smoked);
      day = day.add(const Duration(days: 1));
    }

    final actual = weekCounts.reduce((a, b) => a + b) / 7;
    final adherence = target == 0 ? 1.0 : (target / actual).clamp(0.0, 1.0);
    print('W$week: target $target/day · actual ${actual.toStringAsFixed(1)}/day · '
        'adherence ${(adherence * 100).round()}%');

    // Tempo adaptation (report §14.5).
    final decision = tempoDecision(adherence7: adherence);
    if (decision == TempoDecision.suggestFaster) {
      print('      → adherence ≥85%: the plan suggests a faster pace.');
    } else if (decision == TempoDecision.extendPhase) {
      print('      → adherence ≤55%: the phase is extended automatically.');
    }

    // Weekly overshoot softens the next week by 5% (report §14.4c).
    final overshot = actual > target;
    weeklyAvg = actual;
    if (overshot) {
      print('      → week ran over budget: next week starts 5% softer.');
      weeklyAvg = actual * 0.95;
    }

    // Interval estimate (report §14.7, S3, updated weekly).
    final estimate = quitWeeksEstimate(last7DayAvg: actual, pace: pace);
    if (estimate != null && !finalWeekAnnounced) {
      print('      → estimate: ${estimate.minWeeks}–${estimate.maxWeeks} weeks '
          'to reach the final-week level (S3, range — not a promise).');
    }

    if (finalWeekAnnounced) {
      break;
    }
    print('');
  }

  print('');
  print('Quit day reached: ${_fmt(quitDay)}');
  print('First 72h support (report §20): notifications at +24h, +48h, +72h.');
  print('Nicotine proxy (S3, normalized): after the last cigarette the');
  print('exposure curve halves every 2 hours — 12h: ~2%, 24h: ~0%.');
  print('');
  print('Done — from first launch to quit day and beyond, everything ran');
  print('on-device: no account, no server, no analytics.');
}

String _msg(String key) => switch (key) {
      'completed' => 'day budget completed — well done',
      'clustered' => 'bunched smoking detected: "try to hold the next one '
          'closer to the planned time."',
      _ => 'we recalculated the rest of your day.',
    };

String _fmt(DateTime d) =>
    '${d.day}.${d.month}.${d.year}';
