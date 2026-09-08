import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:halen/application/plan_controller.dart';
import 'package:halen/application/providers.dart';
import 'package:halen/application/record_providers.dart';
import 'package:halen/core/dates.dart';
import 'package:halen/domain/entities.dart';
import 'package:halen/core/routes.dart';
import 'package:halen/l10n/generated/app_localizations.dart';
import 'package:halen/presentation/widgets/sos_techniques_list.dart';
import 'package:halen/presentation/screens/shell_screen.dart';

/// Screen 13: Craving SOS (report §15).
///
/// 2-minute timer + 4D cards + guided box breathing + "watch and wait".
/// Outcome is recorded without shame language: "Atlattım" is a positive
/// count, "İçtim" logs a cigarette and the plan recalculates. No
/// acupressure, no "proven method" claims. Fixed NRT line at the bottom.
class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  static const _timerSeconds = 120;
  int _secondsLeft = _timerSeconds;
  bool _timerRunning = false;
  CravingIntensity _intensity = CravingIntensity.medium;

  /// The technique the user picked for this craving, if any.
  String? _technique;
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _ticker?.cancel();
    setState(() => _timerRunning = true);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_secondsLeft <= 1) {
      _ticker?.cancel();
      setState(() {
        _secondsLeft = 0;
        _timerRunning = false;
      });
      return;
    }
    setState(() => _secondsLeft -= 1);
  }

  Future<void> _record(CravingOutcome outcome) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    await ref
        .read(recordRepositoryProvider)
        .logCraving(
          outcome: outcome,
          intensity: _intensity,
          techniqueKey: _technique,
        );
    if (outcome == CravingOutcome.smoked) {
      // "İçtim" logs the cigarette and the plan recalculates (report §15:
      // record + recalculate, no shame language).
      await ref
          .read(recordRepositoryProvider)
          .logCigarette(source: RecordSource.app);
      final controller = PlanController(db);
      final plan = await controller.ensureTodayPlan(now);
      final events = await db.recordDao.getEventsBetween(
        now.dayStart,
        now.dayStart.add(const Duration(days: 1)),
      );
      await controller.recalculateAfterRecord(
        now: now,
        todayEvents: events,
        plan: plan,
        wakingDayEndHour: 24,
      );
      ref.invalidate(todayStateProvider);
    }
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            outcome == CravingOutcome.resisted
                ? l10n.sosAfterResisted
                : l10n.sosAfterSmoked,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final resistedAsync = ref.watch(resistedCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sosTitle),
        actions: const [ShellSettingsButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(l10n.sosIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            // 2-minute timer (report §15: delay first) — a calm countdown
            // ring instead of an urgent clock.
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: 208,
                      height: 208,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(208, 208),
                            painter: _CountdownRingPainter(
                              fraction:
                                  _secondsLeft / _timerSeconds,
                              color: theme.colorScheme.primary,
                              track: theme.colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.14),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.air_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 24,
                                ),
                                const SizedBox(height: 6),
                                ExcludeSemantics(
                                  child: Text(
                                    '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                                    style:
                                        theme.textTheme.displaySmall?.copyWith(
                                      fontSize: 52,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -2,
                                      color:
                                          theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _timerRunning || _secondsLeft < _timerSeconds
                          ? (_secondsLeft > 0
                                ? l10n.sosTimerRunning(_secondsLeft)
                                : l10n.sosTimerDone)
                          : l10n.sos4dDelayBody,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    if (!_timerRunning && _secondsLeft == 0)
                      OutlinedButton(
                        onPressed: () =>
                            setState(() => _secondsLeft = _timerSeconds),
                        child: Text(l10n.commonRetry),
                      )
                    else if (!_timerRunning)
                      FilledButton.icon(
                        onPressed: _startTimer,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(l10n.sosTimerTitle),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // The 4D set now lives inside the evidence-graded toolkit
            // below, so there is exactly one list of things to do and every
            // entry carries what the evidence actually says about it.
            // Module report §5 — evidence-graded techniques, ordered by what
            // has actually worked for this user. Picking one tags the next
            // craving record with it, which is what teaches that order.
            SosTechniquesList(
              onSelected: (key) {
                setState(() => _technique = key);
                switch (key) {
                  case 'breathe':
                    Navigator.pushNamed(context, Routes.breathing);
                  case 'delay' || 'walk5':
                    _startTimer();
                }
              },
            ),
            const SizedBox(height: 16),
            // Outcome recording (report §15: positive resisted, shameless smoked).
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.sosOutcomeTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.sosIntensityTitle),
                    const SizedBox(height: 4),
                    SegmentedButton<CravingIntensity>(
                      segments: [
                        ButtonSegment(
                          value: CravingIntensity.mild,
                          label: Text(l10n.sosIntensity1),
                        ),
                        ButtonSegment(
                          value: CravingIntensity.medium,
                          label: Text(l10n.sosIntensity2),
                        ),
                        ButtonSegment(
                          value: CravingIntensity.strong,
                          label: Text(l10n.sosIntensity3),
                        ),
                      ],
                      selected: {_intensity},
                      onSelectionChanged: (selection) =>
                          setState(() => _intensity = selection.first),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _record(CravingOutcome.resisted),
                      icon: const Icon(Icons.front_hand),
                      label: Text(l10n.sosResisted),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _record(CravingOutcome.smoked),
                      icon: const Icon(Icons.edit_note),
                      label: Text(l10n.sosSmoked),
                    ),
                    const SizedBox(height: 8),
                    resistedAsync.maybeWhen(
                      data: (n) => Text(l10n.sosResistedCount(n)),
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Fixed NRT line (report §15 — product never recommends NRT).
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.medical_information_outlined),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.sosNrtLine)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// One tick per second — the Timer.periodic lives in the state and is
/// cancelled on dispose so tests never leak pending timers.

/// Soft depleting ring for the SOS countdown.
class _CountdownRingPainter extends CustomPainter {
  const _CountdownRingPainter({
    required this.fraction,
    required this.color,
    required this.track,
  });

  final double fraction;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final rect = Offset.zero & size;
    final inner = rect.deflate(stroke / 2);
    const start = -math.pi / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawArc(inner, 0, math.pi * 2, false, trackPaint);

    final sweep = math.pi * 2 * fraction.clamp(0.0, 1.0);
    if (sweep <= 0) return;
    final progress = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [color.withValues(alpha: 0.65), color],
        transform: const GradientRotation(start),
      ).createShader(inner);
    canvas.drawArc(inner, start, sweep, false, progress);
  }

  @override
  bool shouldRepaint(_CountdownRingPainter old) =>
      old.fraction != fraction || old.color != color || old.track != track;
}

