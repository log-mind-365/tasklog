import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/settings_provider.dart';

class TaskLogApp extends ConsumerWidget {
  const TaskLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeSettingProvider);
    final locale = ref.watch(appLocaleProvider);
    final themeMode = ref.read(themeModeSettingProvider.notifier).toFlutterThemeMode();

    // macOS에서는 Cupertino 스타일 사용
    if (Platform.isMacOS) {
      return CupertinoApp(
        onGenerateTitle: (context) => 'TaskLog',
        theme: _buildCupertinoTheme(themeMode == ThemeMode.dark),

        // Localization
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,

        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      );
    }

    // 다른 플랫폼에서는 Material Design 사용
    return MaterialApp(
      onGenerateTitle: (context) => 'TaskLog',
      theme: AppTheme.buildLightTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: themeMode,

      // Localization
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
