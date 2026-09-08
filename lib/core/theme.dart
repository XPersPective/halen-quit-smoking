import 'package:flutter/material.dart';

/// Halen design language (report §12): warm paper background, deep petrol
/// green for focus surfaces, a single amber accent reserved for the primary
/// CTA. 8pt grid, 24-28 dp card radii, 200-300 ms ease-out motion, soft
/// shadows instead of hard borders in light mode, tonal hairlines in dark.
abstract final class HalenColors {
  // Warm neutrals & modern surfaces.
  static const Color backgroundLight = Color(0xFFF6F4EE);
  static const Color backgroundDark = Color(0xFF0C1512);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF14201B);
  static const Color surfaceElevatedLight = Color(0xFFF0EEE6);
  static const Color surfaceElevatedDark = Color(0xFF1B2A24);
  static const Color outlineLight = Color(0xFFE8E6DD);
  static const Color outlineDark = Color(0xFF263831);

  // Deep petrol green — primary, trust/health.
  static const Color petrol = Color(0xFF1E5B47);
  static const Color petrolDim = Color(0xFF143D30);
  static const Color petrolDeep = Color(0xFF0F2E23);
  static const Color petrolContainerLight = Color(0xFFDCEBE2);
  static const Color petrolContainerDark = Color(0xFF16453A);

  // Calm data-visualization palette (one family, hue-shifted).
  static const Color emerald = Color(0xFF4F8A6E);
  static const Color emeraldContainer = Color(0xFFD6EBDD);
  static const Color skyBlue = Color(0xFF547E9C);
  static const Color coral = Color(0xFFC4674F);
  static const Color purple = Color(0xFF857FA6);
  static const Color mint = Color(0xFFA9D6BE);

  // Amber — the single primary CTA and craving alerts.
  static const Color amberCta = Color(0xFFE9A23B);
  static const Color onAmberCta = Color(0xFF2A1B03);

  // Text.
  static const Color textLight = Color(0xFF1A2622);
  static const Color textDark = Color(0xFFE9EEEC);
  static const Color textSecondaryLight = Color(0xFF52645F);
  static const Color textSecondaryDark = Color(0xFF9FB2AB);

  /// Focus-card gradient (BUGÜN hero, savings hero).
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A6656), Color(0xFF12392C)],
  );

  /// Soft card elevation for light mode (dark mode stays tonal).
  static List<BoxShadow> cardShadow(Brightness brightness) => brightness ==
          Brightness.light
      ? const [
          BoxShadow(
            color: Color(0x140E1F17),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ]
      : const [];
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
      primary: isLight ? HalenColors.petrol : HalenColors.mint,
      onPrimary: isLight ? Colors.white : HalenColors.petrolDeep,
      primaryContainer: isLight
          ? HalenColors.petrolContainerLight
          : HalenColors.petrolContainerDark,
      onPrimaryContainer: isLight ? HalenColors.petrolDim : Colors.white,
      secondary: isLight ? HalenColors.emerald : HalenColors.emerald,
      onSecondary: Colors.white,
      secondaryContainer: isLight
          ? HalenColors.emeraldContainer
          : HalenColors.surfaceElevatedDark,
      onSecondaryContainer: isLight ? HalenColors.petrolDim : HalenColors.mint,
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
      outlineVariant:
          isLight ? HalenColors.outlineLight : HalenColors.outlineDark,
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
      textTheme: base.textTheme.copyWith(
        displaySmall: base.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
        ),
        displayLarge: base.textTheme.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -2.5,
        ),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -1.2,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleSmall: base.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5),
        bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
        bodySmall: base.textTheme.bodySmall?.copyWith(
          height: 1.45,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: base.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: isLight ? 1 : 0.6),
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: isLight ? HalenColors.textLight : HalenColors.textDark,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 24,
        toolbarHeight: 72,
        titleTextStyle: base.textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight
            ? HalenColors.surfaceLight
            : HalenColors.surfaceDark,
        indicatorColor: isLight
            ? HalenColors.petrolContainerLight
            : HalenColors.petrolContainerDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 76,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        // No explicit color here — M3 resolves selected vs unselected label
        // colors with proper contrast against the selected fill.
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        selectedColor: colorScheme.primary,
        backgroundColor: colorScheme.surfaceContainerHighest,
        showCheckmark: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: colorScheme.outline),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 56),
          textStyle: base.textTheme.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isLight
              ? BorderSide.none
              : BorderSide(color: colorScheme.outline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        modalBackgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? HalenColors.petrolDeep : HalenColors.mint,
        contentTextStyle: TextStyle(
          color: isLight ? Colors.white : HalenColors.petrolDeep,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isLight ? HalenColors.petrolDeep : HalenColors.mint,
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(
          color: isLight ? Colors.white : HalenColors.petrolDeep,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : colorScheme.onSurfaceVariant,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
        ),
      ),
    );
  }
}

/// Shared decoration for standard white cards so screens stay consistent
/// without repeating BoxDecoration everywhere.
abstract final class HalenCard {
  static BoxDecoration decoration(ThemeData theme) => BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: theme.brightness == Brightness.dark
            ? Border.all(color: theme.colorScheme.outline)
            : null,
        boxShadow: HalenColors.cardShadow(theme.brightness),
      );

  static BoxDecoration hero() => const BoxDecoration(
        gradient: HalenColors.heroGradient,
        borderRadius: BorderRadius.all(Radius.circular(28)),
      );
}
