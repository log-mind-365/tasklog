import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ColorScheme lightGrayColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF333333),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFF4B4B4B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD0D0D0),
    onSecondaryContainer: Color(0xFF333333),
    tertiary: Color(0xFF555555),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFE0E0E0),
    onTertiaryContainer: Color(0xFF333333),
    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFFB91C1C),
    surface: Color(0xFFFAFAFA),
    onSurface: Color(0xFF1A1A1A),
    onSurfaceVariant: Color(0xFF4B4B4B),
    outline: Color(0xFF808080),
    outlineVariant: Color(0xFFD0D0D0),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF333333),
    onInverseSurface: Color(0xFFF5F5F5),
    inversePrimary: Color(0xFFD0D0D0),
    surfaceDim: Color(0xFFE0E0E0),
    surfaceBright: Color(0xFFFAFAFA),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF5F5F5),
    surfaceContainer: Color(0xFFF0F0F0),
    surfaceContainerHigh: Color(0xFFE0E0E0),
    surfaceContainerHighest: Color(0xFFD0D0D0),
  );

  static const ColorScheme darkGrayColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFFE0E0E0),
    onPrimaryContainer: Color(0xFF000000),
    secondary: Color(0xFFB0B0B0),
    onSecondary: Color(0xFF333333),
    secondaryContainer: Color(0xFF4B4B4B),
    onSecondaryContainer: Color(0xFFD0D0D0),
    tertiary: Color(0xFFE0E0E0),
    onTertiary: Color(0xFF262626),
    tertiaryContainer: Color(0xFF555555),
    onTertiaryContainer: Color(0xFFFFFFFF),
    error: Color(0xFFFCA5A5),
    onError: Color(0xFF7F1D1D),
    errorContainer: Color(0xFFB91C1C),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: Color(0xFF1A1A1A),
    onSurface: Color(0xFFE0E0E0),
    onSurfaceVariant: Color(0xFFD0D0D0),
    outline: Color(0xFF959595),
    outlineVariant: Color(0xFF4B4B4B),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE0E0E0),
    onInverseSurface: Color(0xFF333333),
    inversePrimary: Color(0xFF000000),
    surfaceDim: Color(0xFF1A1A1A),
    surfaceBright: Color(0xFF333333),
    surfaceContainerLowest: Color(0xFF0F0F0F),
    surfaceContainerLow: Color(0xFF1A1A1A),
    surfaceContainer: Color(0xFF262626),
    surfaceContainerHigh: Color(0xFF333333),
    surfaceContainerHighest: Color(0xFF4B4B4B),
  );

  static final ColorScheme lightGreenColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF3FB580),
    brightness: Brightness.light,
  );

  static final ColorScheme darkGreenColorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF3FB580),
    brightness: Brightness.dark,
  );

  static ThemeData get lightTheme =>
      ThemeData(useMaterial3: true, colorScheme: lightGrayColorScheme);

  static ThemeData get darkTheme =>
      ThemeData(useMaterial3: true, colorScheme: darkGrayColorScheme);

  static ThemeData get lightGreenTheme =>
      ThemeData(useMaterial3: true, colorScheme: lightGreenColorScheme);

  static ThemeData get darkGreenTheme =>
      ThemeData(useMaterial3: true, colorScheme: darkGreenColorScheme);
}
