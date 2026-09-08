import 'package:flutter/material.dart';

/// Halen design language (report §12):
/// warm neutral background, deep petrol green primary, amber only on the
/// single primary CTA. 8pt grid, 200-300 ms ease-out motion.
abstract final class HalenColors {
  // Warm neutrals & modern surfaces.
  static const Color backgroundLight = Color(0xFFF9F7F4);
  static const Color backgroundDark = Color(0xFF0F1716);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF162220);
  static const Color surfaceElevatedLight = Color(0xFFF2EFEA);
  static const Color surfaceElevatedDark = Color(0xFF1C2C29);
  static const Color outlineLight = Color(0xFFE5DFD5);
  static const Color outlineDark = Color(0xFF263936);

  // Deep petrol green — primary, trust/health.
  static const Color petrol = Color(0xFF0D5E5A);
  static const Color petrolDim = Color(0xFF08413E);
  static const Color petrolContainerLight = Color(0xFFD3EAE7);
  static const Color petrolContainerDark = Color(0xFF11423F);

  // Vibrant accent colors for data visualization.
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldContainer = Color(0xFFD1FAE5);
  static const Color skyBlue = Color(0xFF0EA5E9);
  static const Color coral = Color(0xFFF43F5E);
  static const Color purple = Color(0xFF8B5CF6);

  // Amber — primary CTA and craving alerts.
  static const Color amberCta = Color(0xFFE8930C);
  static const Color onAmberCta = Color(0xFF241A02);

  // Text.
  static const Color textLight = Color(0xFF172624);
  static const Color textDark = Color(0xFFE8ECEB);
  static const Color textSecondaryLight = Color(0xFF536A66);
  static const Color textSecondaryDark = Color(0xFFA1B3B0);
}

abstract final class HalenSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
}

abstract final class HalenMotion {
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
      primary: isLight ? HalenColors.petrol : HalenColors.emerald,
      onPrimary: Colors.white,
      primaryContainer: isLight
          ? HalenColors.petrolContainerLight
          : HalenColors.petrolContainerDark,
      onPrimaryContainer: isLight ? HalenColors.petrolDim : Colors.white,
      secondary: isLight ? HalenColors.petrol : HalenColors.emerald,
      onSecondary: Colors.white,
      secondaryContainer: isLight
          ? HalenColors.petrolContainerLight
          : HalenColors.petrolContainerDark,
      onSecondaryContainer: isLight ? HalenColors.petrolDim : Colors.white,
      tertiary: HalenColors.amberCta,
      onTertiary: HalenColors.onAmberCta,
      tertiaryContainer: HalenColors.amberCta,
      onTertiaryContainer: HalenColors.onAmberCta,
      error: HalenColors.coral,
      onError: Colors.white,
      surface: isLight ? HalenColors.surfaceLight : HalenColors.surfaceDark,
      onSurface: isLight ? HalenColors.textLight : HalenColors.textDark,
      surfaceContainerHighest: isLight
          ? HalenColors.surfaceElevatedLight
          : HalenColors.surfaceElevatedDark,
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
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight
            ? HalenColors.surfaceLight
            : HalenColors.surfaceDark,
        indicatorColor: isLight
            ? HalenColors.petrolContainerLight
            : HalenColors.petrolContainerDark,
        elevation: 4,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
