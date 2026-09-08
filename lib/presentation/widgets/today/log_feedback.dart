import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

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
  });

  final LogFeedbackKind kind;
  final String headline;
  final String? detail;
  final String? footnote;
  final Future<void> Function()? onUndo;

  @override
  State<_LogFeedbackSheet> createState() => _LogFeedbackSheetState();
}

class _LogFeedbackSheetState extends State<_LogFeedbackSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.kind == LogFeedbackKind.smoked
        ? const Duration(milliseconds: 900)
        : const Duration(milliseconds: 1200),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
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
                builder: (context, child) {
                  // Smoked: the ring contracts and desaturates.
                  // Skipped: it opens out — one breath in.
                  final t = reduceMotion ? 1.0 : _controller.value;
                  final scale = smoked ? 1.0 - 0.12 * t : 0.82 + 0.22 * t;
                  final opacity = smoked ? 1.0 - 0.45 * t : 0.35 + 0.65 * t;
                  return Transform.scale(
                    scale: scale,
                    child: Opacity(opacity: opacity, child: child),
                  );
                },
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.14),
                    border: Border.all(color: accent, width: 2),
                  ),
                  child: Icon(
                    smoked
                        ? Icons.nightlight_round
                        : Icons.air_rounded,
                    color: accent,
                    size: 34,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(widget.headline, style: theme.textTheme.titleLarge),
            if (widget.detail != null) ...[
              const SizedBox(height: 8),
              Text(widget.detail!, style: theme.textTheme.bodyMedium),
            ],
            if (widget.footnote != null) ...[
              const SizedBox(height: 12),
              Text(widget.footnote!, style: theme.textTheme.labelMedium),
            ],
            const SizedBox(height: 20),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.commonDone),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
