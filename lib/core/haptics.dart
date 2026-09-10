import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The app's three touches (premium brief §B, phase 5.4).
///
/// Haptics were being fired ad hoc — one `selectionClick` on the body map and
/// nothing anywhere else. On a phone the feel of a tap is half of whether an
/// app seems considered, and using the same buzz for everything wastes it.
///
/// Three distinct events, and only three:
///
///  * [logged] — a cigarette recorded. Deliberately the *lightest* touch in
///    the app: this is a neutral data point, and a heavy thud here would be
///    the haptic equivalent of a scolding, which the product does not do;
///  * [resisted] — a craving ridden out. A medium impact, so a win is felt
///    more than a log;
///  * [milestone] — a real one. The heaviest, and rare enough to stay
///    meaningful.
///
/// Every call is silent under reduce-motion, which on iOS and Android is the
/// same setting people use when they want the phone to stop buzzing at them.
abstract final class HalenHaptics {
  static bool _muted(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// Selection within a screen: a chip, a hotspot, a tab.
  static void select(BuildContext context) {
    if (!_muted(context)) {
      HapticFeedback.selectionClick();
    }
  }

  /// A cigarette logged. The lightest touch there is.
  static void logged(BuildContext context) {
    if (!_muted(context)) {
      HapticFeedback.lightImpact();
    }
  }

  /// A craving ridden out.
  static void resisted(BuildContext context) {
    if (!_muted(context)) {
      HapticFeedback.mediumImpact();
    }
  }

  /// A milestone reached.
  static void milestone(BuildContext context) {
    if (!_muted(context)) {
      HapticFeedback.heavyImpact();
    }
  }
}
