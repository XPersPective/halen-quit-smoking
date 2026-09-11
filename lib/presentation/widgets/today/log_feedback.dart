import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// The two log animations (module report §12).
///
/// The whole design rests on one rule: **"I smoked" is a quietening, "I
/// skipped it" is an opening.** Both are the same visual language — breath —
/// running in opposite directions. There is no confetti, no red, no scolding
/// and no childishness on either side, and the record is already saved before
/// either of these appears, so nothing here can cost the user their data.
enum LogFeedbackKind { smoked, skipped }

Future<void> showLogFeedback(
  BuildContext context, {
  required LogFeedbackKind kind,
  required String headline,
  String? detail,
  String? footnote,
  bool celebrate = false,
  Future<void> Function()? onUndo,
  int pauseSeconds = 0,
}) {
  final reduceMotion = MediaQuery.of(context).disableAnimations;
  if (!reduceMotion) {
    // One clear, satisfying tap for a ride-out; nothing loud for a record.
    if (kind == LogFeedbackKind.skipped) {
      celebrate ? HapticFeedback.heavyImpact() : HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
  }
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _LogFeedbackSheet(
      kind: kind,
      headline: headline,
      detail: detail,
      footnote: footnote,
      onUndo: onUndo,
      pauseSeconds: pauseSeconds,
    ),
  );
}

class _LogFeedbackSheet extends StatefulWidget {
  const _LogFeedbackSheet({
    required this.kind,
    required this.headline,
    this.detail,
    this.footnote,
    this.onUndo,
    this.pauseSeconds = 0,
  });

  final LogFeedbackKind kind;
  final String headline;
  final String? detail;
  final String? footnote;
  final Future<void> Function()? onUndo;

  /// Opt-in pause before the sheet can be dismissed. The record is already
  /// saved; this only holds the moment open — and Undo stays live throughout.
  final int pauseSeconds;

  @override
  State<_LogFeedbackSheet> createState() => _LogFeedbackSheetState();
}

class _LogFeedbackSheetState extends State<_LogFeedbackSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.kind == LogFeedbackKind.smoked
        ? const Duration(milliseconds: 1800)
        : const Duration(milliseconds: 1200),
  );

  late int _secondsLeft = widget.pauseSeconds;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    if (_secondsLeft > 0) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          return;
        }
        setState(() => _secondsLeft -= 1);
        if (_secondsLeft <= 0) {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final smoked = widget.kind == LogFeedbackKind.smoked;
    final accent = smoked ? HalenColors.textSecondaryLight : HalenColors.emerald;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final t = reduceMotion ? 1.0 : _controller.value;
                  if (smoked) {
                    // Item 9: an ember going out, and a sprout coming up where
                    // it was. Sad first, then hope — the order is the message,
                    // so it is drawn as one continuous motion.
                    return SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: _EmberToSprout(
                          t: t,
                          ember: HalenColors.textSecondaryLight,
                          sprout: HalenColors.emerald,
                        ),
                      ),
                    );
                  }
                  // Skipped: the ring opens out — one breath in.
                  return Transform.scale(
                    scale: 0.82 + 0.22 * t,
                    child: Opacity(
                      opacity: 0.35 + 0.65 * t,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withValues(alpha: 0.14),
                          border: Border.all(color: accent, width: 2),
                        ),
                        child: Icon(
                          Icons.air_rounded,
                          color: accent,
                          size: 34,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: HalenSpace.x6),
            Text(widget.headline, style: theme.textTheme.titleLarge),
            if (widget.detail != null) ...[
              const SizedBox(height: HalenSpace.x2),
              Text(widget.detail!, style: theme.textTheme.bodyMedium),
            ],
            if (widget.footnote != null) ...[
              const SizedBox(height: HalenSpace.x3),
              Text(widget.footnote!, style: theme.textTheme.labelMedium),
            ],
            if (widget.pauseSeconds > 0) ...[
              const SizedBox(height: HalenSpace.x4),
              Text(l10n.logPauseTitle, style: theme.textTheme.labelLarge),
              const SizedBox(height: HalenSpace.x1),
              Text(l10n.logPauseNote, style: theme.textTheme.bodySmall),
              const SizedBox(height: HalenSpace.x2),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 1 - _secondsLeft / widget.pauseSeconds,
                  minHeight: 6,
                ),
              ),
            ],
            const SizedBox(height: HalenSpace.x5),
            Row(
              children: [
                if (widget.onUndo != null)
                  TextButton(
                    onPressed: () async {
                      await widget.onUndo!();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(l10n.logUndo),
                  ),
                const Spacer(),
                FilledButton(
                  // The pause holds the sheet, never the record.
                  onPressed: _secondsLeft > 0
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(
                    _secondsLeft > 0 ? '$_secondsLeft' : l10n.commonDone,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/// An ember going out, then a sprout growing from the same spot.
///
/// The first half is the loss: the glow dims and its thread of smoke thins
/// away. The second half is the point: a stem draws itself upward and two
/// leaves open. No faces, no cartoon, no confetti — the brief was sad but
/// hopeful, and not childish.
class _EmberToSprout extends CustomPainter {
  _EmberToSprout({required this.t, required this.ember, required this.sprout});

  final double t;
  final Color ember;
  final Color sprout;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Offset(size.width / 2, size.height * 0.78);

    // Phase 1 (0 to 0.5): the ember dims and its smoke thins.
    final fade = (1 - t / 0.5).clamp(0.0, 1.0);
    if (fade > 0) {
      canvas.drawCircle(
        base,
        9 + 5 * fade,
        Paint()
          ..color = ember.withValues(alpha: 0.18 * fade)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(
        base,
        6,
        Paint()..color = ember.withValues(alpha: fade),
      );
      final smoke = Path()
        ..moveTo(base.dx, base.dy - 8)
        ..cubicTo(
          base.dx - 10, base.dy - 26,
          base.dx + 10, base.dy - 40,
          base.dx - 2, base.dy - 58 - 10 * (1 - fade),
        );
      canvas.drawPath(
        smoke,
        Paint()
          ..color = ember.withValues(alpha: 0.5 * fade)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round,
      );
    }

    // Phase 2 (0.45 to 1): a stem grows and two leaves open.
    final grow = ((t - 0.45) / 0.55).clamp(0.0, 1.0);
    if (grow <= 0) {
      return;
    }
    canvas.drawLine(
      base,
      Offset(base.dx, base.dy - 58 * grow),
      Paint()
        ..color = sprout
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    final leaf = ((grow - 0.4) / 0.6).clamp(0.0, 1.0);
    if (leaf <= 0) {
      return;
    }
    final fill = Paint()..color = sprout.withValues(alpha: 0.85);
    for (final side in const [-1.0, 1.0]) {
      final anchor = Offset(base.dx, base.dy - 40 * grow);
      final tip = anchor.translate(side * 22 * leaf, -14 * leaf);
      final path = Path()
        ..moveTo(anchor.dx, anchor.dy)
        ..quadraticBezierTo(
          anchor.dx + side * 18 * leaf, anchor.dy + 4 * leaf,
          tip.dx, tip.dy,
        )
        ..quadraticBezierTo(
          anchor.dx + side * 4 * leaf, anchor.dy - 14 * leaf,
          anchor.dx, anchor.dy,
        )
        ..close();
      canvas.drawPath(path, fill);
    }
  }

  @override
  bool shouldRepaint(_EmberToSprout old) => old.t != t;
}
