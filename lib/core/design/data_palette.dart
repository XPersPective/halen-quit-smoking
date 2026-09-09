import 'package:flutter/material.dart';

import '../theme.dart';

/// Semantic colour roles for data (premium brief §A.5).
///
/// The app had emerald, amber, coral, sky blue, purple, mint and petrol in
/// circulation, chosen per-widget. That is a box of paints, not a palette:
/// nothing could be learned from a colour, because the same hue meant
/// savings on one screen and nicotine on the next.
///
/// Here each role is a *meaning*, and the meaning is fixed across the whole
/// app. Two rules ride along:
///
///  * **no red on health data.** [caution] exists for interface warnings —
///    an expired export, a permission that is off — never for "you smoked".
///  * **a role, not a decoration.** If a new chart needs a colour, it needs
///    to name what it means first; if it means nothing new, it reuses a role.
enum DataRole {
  /// What the person is doing: adherence, progress, resisted cravings.
  progress,

  /// Nicotine — the acute curve, and the primary CTA it belongs to.
  nicotine,

  /// Carbon monoxide / oxygen debt.
  oxygen,

  /// The all-day baseline (cotinine proxy).
  baseline,

  /// Cumulative particle load.
  particle,

  /// Money.
  money,

  /// Time given back.
  time,

  /// Interface warnings only. Never a health value.
  caution,
}

extension DataRoleColor on DataRole {
  /// The colour for this role in the current theme.
  Color of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return switch (this) {
      DataRole.progress =>
        dark ? const Color(0xFF6FB894) : HalenColors.emerald,
      DataRole.nicotine => HalenColors.amberCta,
      DataRole.oxygen => dark ? const Color(0xFF7BA6C4) : HalenColors.skyBlue,
      DataRole.baseline => dark ? const Color(0xFFA9A2CC) : HalenColors.purple,
      DataRole.particle => dark
          ? HalenColors.textSecondaryDark
          : HalenColors.textSecondaryLight,
      DataRole.money => dark ? HalenColors.mint : HalenColors.petrol,
      DataRole.time => dark ? const Color(0xFF8FCBAE) : HalenColors.emerald,
      DataRole.caution => HalenColors.coral,
    };
  }

  /// A tinted ground for the same role — bars, fills, chips.
  Color containerOf(BuildContext context) =>
      of(context).withValues(alpha: 0.12);
}
