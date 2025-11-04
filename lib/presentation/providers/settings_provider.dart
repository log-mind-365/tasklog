import 'package:flutter/material.dart' as flutter;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

/// 테마 모드 설정 Provider
@riverpod
class ThemeModeSetting extends _$ThemeModeSetting {
  static const String _key = 'theme_mode';

  @override
  ThemeModeEnum build() {
    _loadThemeMode();
    return ThemeModeEnum.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_key);

    if (themeModeString != null) {
      state = ThemeModeEnum.values.firstWhere(
        (e) => e.name == themeModeString,
        orElse: () => ThemeModeEnum.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeModeEnum mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  flutter.ThemeMode toFlutterThemeMode() {
    switch (state) {
      case ThemeModeEnum.light:
        return flutter.ThemeMode.light;
      case ThemeModeEnum.dark:
        return flutter.ThemeMode.dark;
      case ThemeModeEnum.system:
        return flutter.ThemeMode.system;
    }
  }
}

/// 테마 모드 열거형
enum ThemeModeEnum {
  light,
  dark,
  system,
}

/// 로케일 설정 Provider
@riverpod
class AppLocale extends _$AppLocale {
  static const String _key = 'app_locale';

  @override
  flutter.Locale? build() {
    _loadLocale();
    return null; // null이면 시스템 언어 사용
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_key);

    if (languageCode != null) {
      state = flutter.Locale(languageCode);
    }
  }

  Future<void> setLocale(flutter.Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();

    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
  }
}
