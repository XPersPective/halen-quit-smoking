import 'package:flutter/material.dart';

/// Halen design language (report §12):
/// warm neutral background, deep petrol green primary, amber only on the
/// single primary CTA. 8pt grid, 200-300 ms ease-out motion.
abstract final class HalenColors {
  // Warm neutrals.
  static const Color backgroundLight = Color(0xFFFAF7F2);
  static const Color backgroundDark = Color(0xFF1B1A17);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF26241F);
  static const Color outlineLight = Color(0xFFE3DDD2);
  static const Color outlineDark = Color(0xFF3A382F);

  // Deep petrol green — primary, trust/health.
  static const Color petrol = Color(0xFF0E5553);
  static const Color petrolDim = Color(0xFF0A403E);
  static const Color petrolContainerLight = Color(0xFFD5EAE8);
  static const Color petrolContainerDark = Color(0xFF0F5A57);

  // Amber — only ever used for the primary CTA.
  static const Color amberCta = Color(0xFFE8930C);
  static const Color onAmberCta = Color(0xFF241A02);

  // Text.
  static const Color textLight = Color(0xFF1D2A28);
  static const Color textDark = Color(0xFFE9E5DC);
  static const Color textSecondaryLight = Color(0xFF5A6A67);
  static const Color textSecondaryDark = Color(0xFFA9B4B1);
}

abstract final class HalenSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
}

abstract final class HalenMotion {
  /// 200-300 ms ease-out per report §12; halved when the user asks for
  /// reduced motion (system setting or in-app toggle).
  static const Duration standard = Duration(milliseconds: 240);
  static const Curve curve = Curves.easeOutCubic;

  static Duration duration({required bool reduceMotion}) =>
      reduceMotion ? Duration.zero : standard;
}

class HalenTheme {
  static ThemeData light() => _theme(Brightness.light);
  static ThemeData dark() => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isLight ? HalenColors.petrol : HalenColors.petrolContainerDark,
      onPrimary: Colors.white,
      primaryContainer: isLight
          ? HalenColors.petrolContainerLight
          : HalenColors.petrolDim,
      onPrimaryContainer: isLight ? HalenColors.petrolDim : Colors.white,
      secondary: isLight ? HalenColors.petrol : HalenColors.petrolContainerDark,
      onSecondary: Colors.white,
      secondaryContainer: isLight
          ? HalenColors.petrolContainerLight
          : HalenColors.petrolDim,
      onSecondaryContainer: isLight ? HalenColors.petrolDim : Colors.white,
      // Amber lives only on the primary CTA, surfaced via explicit colors in
      // the CTA widget — kept here so it is part of the scheme.
      tertiary: HalenColors.amberCta,
      onTertiary: HalenColors.onAmberCta,
      tertiaryContainer: HalenColors.amberCta,
      onTertiaryContainer: HalenColors.onAmberCta,
      error: const Color(0xFF8C3A22),
      onError: Colors.white,
      surface: isLight ? HalenColors.surfaceLight : HalenColors.surfaceDark,
      onSurface: isLight ? HalenColors.textLight : HalenColors.textDark,
      surfaceContainerHighest: isLight
          ? HalenColors.petrolContainerLight
          : HalenColors.outlineDark,
      onSurfaceVariant: isLight
          ? HalenColors.textSecondaryLight
          : HalenColors.textSecondaryDark,
      outline: isLight ? HalenColors.outlineLight : HalenColors.outlineDark,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isLight
          ? HalenColors.backgroundLight
          : HalenColors.backgroundDark,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isLight
            ? HalenColors.backgroundLight
            : HalenColors.backgroundDark,
        foregroundColor: isLight ? HalenColors.textLight : HalenColors.textDark,
        centerTitle: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline),
        ),
        margin: EdgeInsets.zero,
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
