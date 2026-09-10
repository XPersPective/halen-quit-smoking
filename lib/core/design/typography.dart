import 'package:flutter/material.dart';

/// Type identity (premium brief §A.4, §B.1).
///
/// The app drew in the platform's default face. That single fact did more to
/// make it read as unfinished than any layout problem: a system font says
/// "nobody chose anything here", and on a health product that reads as
/// nobody chose the numbers either.
///
/// Inter, the variable original, is the choice. It was drawn for interfaces
/// at small sizes, its Latin Extended coverage carries Turkish and German
/// without falling back mid-word, and — the reason it matters here — it
/// ships **tabular figures**, so a counter that ticks every second does not
/// jitter as its digits change width.
abstract final class HalenType {
  static const String family = 'Inter';

  /// Proportional digits: fine in running prose.
  static const List<FontFeature> _prose = [];

  /// Tabular, lining figures. Every digit occupies the same advance width, so
  /// "1 h 09 m" and "1 h 11 m" occupy the same space and the number stays
  /// still while it changes.
  static const List<FontFeature> _numeric = [
    FontFeature.tabularFigures(),
    FontFeature.liningFigures(),
  ];

  /// Applies the family and the prose figure set to an existing scale, then
  /// tightens the display end — large type needs negative tracking to stop
  /// looking loose, and small type needs a little positive tracking to stay
  /// legible.
  static TextTheme apply(TextTheme base) {
    TextStyle? style(
      TextStyle? from, {
      required double weight,
      double? tracking,
      double? height,
    }) =>
        from?.copyWith(
          fontFamily: family,
          fontWeight: FontWeight.values[(weight ~/ 100) - 1],
          letterSpacing: tracking,
          height: height,
          fontFeatures: _prose,
        );

    return base.copyWith(
      displayLarge: style(base.displayLarge, weight: 700, tracking: -1.5),
      displayMedium: style(base.displayMedium, weight: 700, tracking: -1.2),
      displaySmall: style(base.displaySmall, weight: 700, tracking: -1.0),
      headlineLarge: style(base.headlineLarge, weight: 700, tracking: -0.8),
      headlineMedium: style(base.headlineMedium, weight: 700, tracking: -0.6),
      headlineSmall: style(base.headlineSmall, weight: 700, tracking: -0.4),
      titleLarge: style(base.titleLarge, weight: 700, tracking: -0.3),
      titleMedium: style(base.titleMedium, weight: 600, tracking: -0.1),
      titleSmall: style(base.titleSmall, weight: 600),
      bodyLarge: style(base.bodyLarge, weight: 400, height: 1.5),
      bodyMedium: style(base.bodyMedium, weight: 400, height: 1.45),
      bodySmall: style(base.bodySmall, weight: 400, height: 1.45),
      labelLarge: style(base.labelLarge, weight: 600),
      labelMedium: style(base.labelMedium, weight: 500),
      labelSmall: style(base.labelSmall, weight: 600, tracking: 0.2),
    );
  }

  /// Turns any style into a number style. Use it wherever a value is shown
  /// as a quantity rather than read as a word.
  static TextStyle numeric(TextStyle style) =>
      style.copyWith(fontFeatures: _numeric);
}

/// Convenience so call sites read as intent, not plumbing.
extension NumericText on TextStyle {
  /// This text is a number: tabular, lining figures.
  TextStyle get asNumber => HalenType.numeric(this);
}
