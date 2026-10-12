
import 'package:flutter/material.dart';

class AppTheme {
  final TextTheme textTheme;

  const AppTheme(this.textTheme);

  // ==================== LIGHT MODE ====================

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,

      primary: Color(0xFF7160BB),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE9E1FF),
      onPrimaryContainer: Color(0xFF261653),

      primaryFixed: Color(0xFFE9E1FF),
      onPrimaryFixed: Color(0xFF261653),
      primaryFixedDim: Color(0xFFCEC0FF),
      onPrimaryFixedVariant: Color(0xFF58479D),

      secondary: Color(0xFF625B71),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE8DEF8),
      onSecondaryContainer: Color(0xFF211A2D),

      secondaryFixed: Color(0xFFE8DEF8),
      onSecondaryFixed: Color(0xFF211A2D),
      secondaryFixedDim: Color(0xFFCCC2DC),
      onSecondaryFixedVariant: Color(0xFF4A4458),

      tertiary: Color(0xFF7D5260),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFD9E3),
      onTertiaryContainer: Color(0xFF31101D),

      tertiaryFixed: Color(0xFFFFD9E3),
      onTertiaryFixed: Color(0xFF31101D),
      tertiaryFixedDim: Color(0xFFEFB8C8),
      onTertiaryFixedVariant: Color(0xFF633B48),

      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      surface: Color(0xFFFAF8FF),
      onSurface: Color(0xFF1D1B20),
      onSurfaceVariant: Color(0xFF49454F),

      surfaceTint: Color(0xFF7160BB),
      surfaceDim: Color(0xFFDED8E1),
      surfaceBright: Color(0xFFFAF8FF),

      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F2FA),
      surfaceContainer: Color(0xFFF3EDF7),
      surfaceContainerHigh: Color(0xFFECE6F0),
      surfaceContainerHighest: Color(0xFFE6E0E9),

      outline: Color(0xFF79747E),
      outlineVariant: Color(0xFFCAC4D0),

      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      inverseSurface: Color(0xFF322F35),
      onInverseSurface: Color(0xFFF5EFF7),
      inversePrimary: Color(0xFFCEC0FF),
    );
  }

  ThemeData light() => theme(lightScheme());

  // ==================== DARK MODE ====================

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,

      primary: Color(0xFFCEC0FF),
      onPrimary: Color(0xFF403075),
      primaryContainer: Color(0xFF58479D),
      onPrimaryContainer: Color(0xFFE9E1FF),

      primaryFixed: Color(0xFFE9E1FF),
      onPrimaryFixed: Color(0xFF261653),
      primaryFixedDim: Color(0xFFCEC0FF),
      onPrimaryFixedVariant: Color(0xFF58479D),

      secondary: Color(0xFFCCC2DC),
      onSecondary: Color(0xFF332D41),
      secondaryContainer: Color(0xFF4A4458),
      onSecondaryContainer: Color(0xFFE8DEF8),

      secondaryFixed: Color(0xFFE8DEF8),
      onSecondaryFixed: Color(0xFF211A2D),
      secondaryFixedDim: Color(0xFFCCC2DC),
      onSecondaryFixedVariant: Color(0xFF4A4458),

      tertiary: Color(0xFFEFB8C8),
      onTertiary: Color(0xFF492532),
      tertiaryContainer: Color(0xFF633B48),
      onTertiaryContainer: Color(0xFFFFD9E3),

      tertiaryFixed: Color(0xFFFFD9E3),
      onTertiaryFixed: Color(0xFF31101D),
      tertiaryFixedDim: Color(0xFFEFB8C8),
      onTertiaryFixedVariant: Color(0xFF633B48),

      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),

      surface: Color(0xFF15131D),
      onSurface: Color(0xFFE6E0E9),
      onSurfaceVariant: Color(0xFFCAC4D0),

      surfaceTint: Color(0xFFCEC0FF),
      surfaceDim: Color(0xFF15131D),
      surfaceBright: Color(0xFF3B383E),

      surfaceContainerLowest: Color(0xFF100E16),
      surfaceContainerLow: Color(0xFF1D1B24),
      surfaceContainer: Color(0xFF211F28),
      surfaceContainerHigh: Color(0xFF2C2933),
      surfaceContainerHighest: Color(0xFF37343E),

      outline: Color(0xFF948F99),
      outlineVariant: Color(0xFF49454F),

      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      inverseSurface: Color(0xFFE6E0E9),
      onInverseSurface: Color(0xFF322F35),
      inversePrimary: Color(0xFF7160BB),
    );
  }

  ThemeData dark() => theme(darkScheme());

  // ==================== SHARED THEME ====================

  ThemeData theme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,

      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),

      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }

  // ==================== EXTENDED COLORS ====================

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
  });
}

class ColorFamily {
  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;

  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });
}
