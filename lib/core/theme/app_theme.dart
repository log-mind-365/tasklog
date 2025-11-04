import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'colors.dart';

/// 애플리케이션 테마 설정을 관리하는 클래스
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  /// 라이트 테마 빌드
  static ThemeData buildLightTheme() {
    return _buildTheme(AppColors.lightGrayColorScheme);
  }

  /// 다크 테마 빌드
  static ThemeData buildDarkTheme() {
    return _buildTheme(AppColors.darkGrayColorScheme);
  }

  /// 공통 테마 설정
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'SF Pro Display',
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(
        elevation: AppConstants.elevationNone,
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: AppConstants.elevationNone,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: AppConstants.fontSizeXHuge,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: colorScheme.brightness,
          statusBarIconBrightness: colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppConstants.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: AppConstants.alphaStrong,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingXLarge,
          vertical: AppConstants.spacingLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),
    );
  }
}
