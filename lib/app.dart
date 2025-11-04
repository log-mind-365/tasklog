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

    return MaterialApp(
      onGenerateTitle: (context) => 'TaskLog',
      theme: AppTheme.buildLightTheme(),
      darkTheme: AppTheme.buildDarkTheme(),
      themeMode: ref.read(themeModeSettingProvider.notifier).toFlutterThemeMode(),

      // Localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,

      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
