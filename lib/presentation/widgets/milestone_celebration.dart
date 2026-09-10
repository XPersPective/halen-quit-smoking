import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design/data_palette.dart';
import '../../core/design/tokens.dart';
import '../../core/haptics.dart';
import '../../l10n/generated/app_localizations.dart';
import 'design/body_clock.dart';
import 'design/halen_components.dart';

/// A milestone, made into a moment (premium brief §A.8).
///
/// The app already knew when someone hit a day, a week, a month or their
/// hundredth ridden-out craving — and marked it with a line of text in a
/// list. Nothing in the product felt like an event, and in a process whose
/// entire fuel is accumulated small wins, that is a real omission.
///
/// The restraint that keeps it from being childish, which the user asked for
/// explicitly: no confetti, no cartoon, no sound. One expanding ring, one
/// number, one sentence. It reads as a certificate rather than a party.
Future<void> showMilestone(
  BuildContext context, {
  required String title,
  required String detail,
}) {
  HalenHaptics.milestone(context);
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _MilestoneDialog(title: title, detail: detail),
  );
}

class _MilestoneDialog extends StatelessWidget {
  const _MilestoneDialog({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: HalenCard(
        emphasis: CardEmphasis.raised,
        padding: const EdgeInsets.all(HalenSpace.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: BodyPulse(
                builder: (context, seconds) => CustomPaint(
                  painter: _RingsPainter(
                    phase: BodyClock.phaseOf(seconds, HalenDuration.breath),
                    color: DataRole.progress.of(context),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 40,
                      color: DataRole.progress.of(context),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x5),
            Text(
              l10n.celebrateTitle,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x1),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HalenSpace.x3),
            Text(
              detail,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: HalenSpace.x6),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(l10n.celebrateClose),
            ),
          ],
        ),
      ),
    );
  }
}

/// Three rings leaving the centre on the shared clock, each fading as it
/// grows. Quiet on purpose — the point is that something happened, not that
/// the app is excited.
class _RingsPainter extends CustomPainter {
  _RingsPainter({required this.phase, required this.color});

  final double phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;

    for (var i = 0; i < 3; i++) {
      final local = (phase + i / 3) % 1.0;
      final radius = maxRadius * (0.45 + 0.55 * local);
      final fade = (1 - local).clamp(0.0, 1.0);
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..color = color.withValues(alpha: 0.35 * fade)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // A still inner disc so the icon always sits on something solid.
    canvas.drawCircle(
      centre,
      maxRadius * 0.42,
      Paint()..color = color.withValues(alpha: 0.14),
    );
  }

  @override
  bool shouldRepaint(_RingsPainter old) =>
      old.phase != phase || old.color != color;
}

/// Which milestones exist, and what counts as reaching one.
///
/// Kept as data so the celebration cannot drift out of step with the
/// timeline screen that lists the same moments.
enum Milestone {
  day1(days: 1),
  day3(days: 3),
  week1(days: 7),
  month1(days: 30);

  const Milestone({required this.days});

  final int days;

  /// The milestone newly crossed between [before] and [after] days smoke
  /// free, or null. Only one fires at a time, and only on the crossing —
  /// a celebration that reappears every launch stops being one.
  static Milestone? crossed({required int before, required int after}) {
    for (final milestone in values.reversed) {
      if (before < milestone.days && after >= milestone.days) {
        return milestone;
      }
    }
    return null;
  }

  String title(AppLocalizations l10n) => switch (this) {
        Milestone.day1 => l10n.celebrateDay1,
        Milestone.day3 => l10n.celebrateDay3,
        Milestone.week1 => l10n.celebrateWeek1,
        Milestone.month1 => l10n.celebrateMonth1,
      };
}

/// Rounds a duration to whole days the way the milestones count them.
int daysSmokeFree(Duration since) => math.max(0, since.inHours ~/ 24);
