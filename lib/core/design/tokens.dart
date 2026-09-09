import 'package:flutter/material.dart';

/// Design tokens (premium brief §B.1).
///
/// Before this file, spacing in the app ran 4, 6, 8, 10, 12, 14, 16, 18, 20,
/// 24 and 28; durations ran 220, 240, 280, 400 and 700 ms; radii ran 6, 12,
/// 14, 16, 18, 20 and 24. None of it was wrong individually and all of it was
/// wrong together — the eye reads an unrhythmic layout as unfinished long
/// before anyone can name why.
///
/// Everything visual now comes from here. The rule the codebase is held to:
/// **no raw numbers for spacing, radius, duration or shadow in screen and
/// widget files.**
abstract final class HalenSpace {
  /// 4 dp — hairline gaps inside a single line of content.
  static const double x1 = 4;

  /// 8 dp — between tightly related items (icon and its label).
  static const double x2 = 8;

  /// 12 dp — between a label and the thing it labels.
  static const double x3 = 12;

  /// 16 dp — the default gap, and the default inner padding of small cards.
  static const double x4 = 16;

  /// 20 dp — card padding.
  static const double x5 = 20;

  /// 24 dp — between cards.
  static const double x6 = 24;

  /// 32 dp — between sections.
  static const double x8 = 32;

  /// 48 dp — above a section that starts a new subject.
  static const double x12 = 48;

  /// Standard card padding.
  static const EdgeInsets card = EdgeInsets.all(x5);

  /// Standard screen padding, with room under the last card.
  static const EdgeInsets screen = EdgeInsets.fromLTRB(x5, x3, x5, x8);
}

/// Corner radii. Three steps only — a fourth invites drift.
abstract final class HalenRadius {
  /// 12 dp — chips, small controls, chart clips.
  static const double small = 12;

  /// 20 dp — cards, sheets, buttons.
  static const double medium = 20;

  /// 28 dp — hero surfaces and modal sheets.
  static const double large = 28;

  static const BorderRadius smallAll = BorderRadius.all(
    Radius.circular(small),
  );
  static const BorderRadius mediumAll = BorderRadius.all(
    Radius.circular(medium),
  );
  static const BorderRadius largeAll = BorderRadius.all(
    Radius.circular(large),
  );
}

/// Elevation as shadow recipes rather than Material's numeric elevation.
///
/// Light mode gets soft, wide, low-opacity shadows — the thing that separates
/// a card from a rectangle. Dark mode gets none: a shadow on a dark ground is
/// invisible, so depth there comes from surface tone instead.
abstract final class HalenShadow {
  /// A card resting on the page.
  static List<BoxShadow> resting(Brightness brightness) =>
      brightness == Brightness.light
          ? const [
              BoxShadow(
                color: Color(0x0F0E1F17),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ]
          : const [];

  /// A card that is the subject of the screen.
  static List<BoxShadow> raised(Brightness brightness) =>
      brightness == Brightness.light
          ? const [
              BoxShadow(
                color: Color(0x160E1F17),
                blurRadius: 28,
                offset: Offset(0, 10),
              ),
            ]
          : const [];

  /// A sheet or dialog over the page.
  static List<BoxShadow> overlay(Brightness brightness) =>
      brightness == Brightness.light
          ? const [
              BoxShadow(
                color: Color(0x240E1F17),
                blurRadius: 40,
                offset: Offset(0, 16),
              ),
            ]
          : const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 32,
                offset: Offset(0, 12),
              ),
            ];
}

/// Motion tokens.
///
/// Four speeds, and two of them are for continuous life (the lung, the
/// heart) rather than transitions. Anything not in this list is drift.
abstract final class HalenDuration {
  /// State flips the user must not wait for: selection, toggles.
  static const Duration quick = Duration(milliseconds: 150);

  /// The default: expansions, fades, chart reveals.
  static const Duration standard = Duration(milliseconds: 240);

  /// Something arriving that deserves to be watched: a bar filling.
  static const Duration slow = Duration(milliseconds: 600);

  /// One breath. The lung and the body map share this clock.
  static const Duration breath = Duration(seconds: 4);

  /// One heartbeat cycle.
  static const Duration beat = Duration(seconds: 1);

  /// Collapses to zero when the platform asks for reduced motion.
  static Duration respecting(BuildContext context, Duration duration) =>
      MediaQuery.of(context).disableAnimations ? Duration.zero : duration;
}

/// Easing. Entrances decelerate, exits accelerate — the standard asymmetry
/// that makes motion feel physical rather than mechanical.
abstract final class HalenCurves {
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;

  /// For a value settling into place (a gauge, a bar).
  static const Curve settle = Curves.easeOutQuart;
}
