import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/design/typography.dart';

/// The shared component vocabulary (premium brief §B.3).
///
/// Every screen used to build its own card, its own section header, its own
/// empty state and its own big-number block. They were all *nearly* the same,
/// which is the worst outcome: the differences read as sloppiness rather than
/// as intent, and a change to the card style meant eleven edits.

/// A surface that holds one idea.
///
/// [emphasis] is the only knob. There is deliberately no elevation number, no
/// custom radius and no per-call padding override: a card that needs to look
/// different from the others usually needs to *be* something different.
enum CardEmphasis {
  /// The default: a card among cards.
  resting,

  /// The subject of the screen. One per screen, at most.
  raised,

  /// Quieter than the page — a footnote, a source, a disclosure.
  quiet,
}

class HalenCard extends StatelessWidget {
  const HalenCard({
    super.key,
    required this.child,
    this.emphasis = CardEmphasis.resting,
    this.onTap,
    this.padding = HalenSpace.card,
  });

  final Widget child;
  final CardEmphasis emphasis;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final scheme = theme.colorScheme;

    final background = switch (emphasis) {
      CardEmphasis.resting => scheme.surface,
      CardEmphasis.raised => scheme.surface,
      CardEmphasis.quiet => scheme.surfaceContainerHighest,
    };
    final shadow = switch (emphasis) {
      CardEmphasis.resting => HalenShadow.resting(brightness),
      CardEmphasis.raised => HalenShadow.raised(brightness),
      CardEmphasis.quiet => const <BoxShadow>[],
    };

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: HalenRadius.mediumAll,
        boxShadow: shadow,
        // Dark mode gets no shadow, so the edge has to come from a hairline
        // or the card dissolves into the page.
        border: brightness == Brightness.dark
            ? Border.all(color: scheme.outline)
            : null,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) {
      return surface;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: HalenRadius.mediumAll,
        child: surface,
      ),
    );
  }
}

/// A section title, optionally with one trailing action.
///
/// Titles are sentence case and short. The subtitle carries the explanation,
/// because a title that needs a clause is a title that will wrap on a phone.
class HalenSectionHeader extends StatelessWidget {
  const HalenSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: HalenSpace.x1),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// One number, with what it is above and what it means below.
///
/// The number is allowed to shrink rather than wrap: at 1.6x text scale a
/// wrapped "1 g 4 sa" stops reading as a single quantity.
class HalenStat extends StatelessWidget {
  const HalenStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.caption,
    this.large = false,
  });

  final String label;
  final String value;
  final String? caption;
  final Color color;

  /// The one headline number on a screen.
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: HalenSpace.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            // A quantity, so tabular figures: the value updates every
            // thirty seconds and must not shuffle sideways as digits change.
            style: (large
                    ? theme.textTheme.displaySmall
                    : theme.textTheme.headlineSmall)
                ?.copyWith(color: color, fontWeight: FontWeight.w700)
                .asNumber,
          ),
        ),
        if (caption != null && caption!.isNotEmpty)
          Text(caption!, style: theme.textTheme.labelSmall),
      ],
    );
  }
}

/// What a card shows before it has data (premium brief §B.6).
///
/// A new user meets the app at its emptiest, which is exactly when it has to
/// be most convincing. So an empty state says what will appear here and what
/// produces it — never a blank box, never a zero pretending to be a reading.
class HalenEmptyState extends StatelessWidget {
  const HalenEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HalenSpace.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 28,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(height: HalenSpace.x3),
          Text(message, style: theme.textTheme.bodyMedium),
          if (action != null) ...[
            const SizedBox(height: HalenSpace.x4),
            action!,
          ],
        ],
      ),
    );
  }
}

/// A small labelled pill — evidence grades, bands, units.
class HalenPill extends StatelessWidget {
  const HalenPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HalenSpace.x3,
        vertical: HalenSpace.x1 + 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: HalenRadius.smallAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: HalenSpace.x1 + 2),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
