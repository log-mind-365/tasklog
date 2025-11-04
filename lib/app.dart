import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/settings_provider.dart'
    show
        ThemeModeEnum,
        appLocaleProvider,
        systemBrightnessProvider,
        themeModeSettingProvider;

class TaskLogApp extends ConsumerWidget {
  const TaskLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeEnum = ref.watch(themeModeSettingProvider);
    final systemBrightness = ref.watch(systemBrightnessProvider);
    final locale = ref.watch(appLocaleProvider);

    final themeMode = switch (themeModeEnum) {
      ThemeModeEnum.light => ThemeMode.light,
      ThemeModeEnum.dark => ThemeMode.dark,
      ThemeModeEnum.system => ThemeMode.system,
    };

    if (Platform.isMacOS || Platform.isIOS) {
      // themeMode가 system일 때는 실제 시스템 brightness를 사용
      final isDark = themeMode == ThemeMode.system
          ? systemBrightness == Brightness.dark
          : themeMode == ThemeMode.dark;

      return CupertinoApp(
        onGenerateTitle: (context) => 'TaskLog',
        theme: _buildCupertinoTheme(isDark),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      onGenerateTitle: (context) => 'TaskLog',
      theme: AppTheme.buildLightTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }

  CupertinoThemeData _buildCupertinoTheme(bool isDark) {
    return CupertinoThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: CupertinoColors.systemBlue,
      barBackgroundColor: isDark
          ? CupertinoColors.systemBackground.darkColor
          : CupertinoColors.systemBackground.color,
      scaffoldBackgroundColor: isDark
          ? CupertinoColors.systemBackground.darkColor
          : CupertinoColors.systemBackground.color,
    );
  }
}
