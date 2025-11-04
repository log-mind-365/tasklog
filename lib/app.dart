import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/providers/settings_provider.dart'
    show ThemeModeEnum, appLocaleProvider, themeModeSettingProvider;

class TaskLogApp extends ConsumerWidget {
  const TaskLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeEnum = ref.watch(themeModeSettingProvider);
    final locale = ref.watch(appLocaleProvider);

    final themeMode = switch (themeModeEnum) {
      ThemeModeEnum.light => ThemeMode.light,
      ThemeModeEnum.dark => ThemeMode.dark,
      ThemeModeEnum.system => ThemeMode.system,
    };

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
}
