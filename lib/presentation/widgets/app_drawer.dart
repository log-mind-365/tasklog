import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../pages/settings_page.dart';
import '../providers/settings_provider.dart';

/// 앱 우측 드로어
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: AppConstants.iconSizeXLarge * 1.5,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    l10n.appTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingXSmall),
                  Text(
                    'v1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(
                        alpha: AppConstants.alphaVeryStrong,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 메뉴 아이템
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingMedium,
                ),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    title: l10n.settings,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: l10n.information,
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: l10n.help,
                    onTap: () {
                      Navigator.pop(context);
                      _showHelpDialog(context);
                    },
                  ),
                  const Divider(
                    height: AppConstants.spacingXLarge,
                    indent: AppConstants.spacingLarge,
                    endIndent: AppConstants.spacingLarge,
                  ),
                  _buildMenuItem(
                    context,
                    ref: ref,
                    icon: Icons.language_outlined,
                    title: l10n.languageSettings,
                    onTap: () {
                      _showLanguageDialog(context, ref);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    ref: ref,
                    icon: Icons.palette_outlined,
                    title: l10n.theme,
                    onTap: () {
                      _showThemeDialog(context, ref);
                    },
                  ),
                ],
              ),
            ),

            // 하단 정보
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              child: Text(
                l10n.copyright,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: AppConstants.alphaStrong,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    WidgetRef? ref,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingXLarge,
        vertical: AppConstants.spacingXSmall,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: theme.colorScheme.primary,
              size: AppConstants.iconSizeLarge,
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(l10n.help),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpSection(
                context,
                l10n.helpTodoManagement,
                l10n.helpTodoManagementContent,
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              _buildHelpSection(
                context,
                l10n.helpHabitTracking,
                l10n.helpHabitTrackingContent,
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              _buildHelpSection(
                context,
                l10n.helpSettings,
                l10n.helpSettingsContent,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          content,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);
    final l10n = AppLocalizations.of(context)!;

    String getLanguageLabel(Locale? locale) {
      if (locale == null) return l10n.systemSettings;
      switch (locale.languageCode) {
        case 'ko':
          return l10n.korean;
        case 'en':
          return l10n.english;
        case 'ja':
          return l10n.japanese;
        default:
          return locale.languageCode;
      }
    }

    String getLanguageFlag(Locale? locale) {
      if (locale == null) return '🌐';
      switch (locale.languageCode) {
        case 'ko':
          return '🇰🇷';
        case 'en':
          return '🇺🇸';
        case 'ja':
          return '🇯🇵';
        default:
          return '🌐';
      }
    }

    final supportedLocales = [
      null, // 시스템 설정
      const Locale('ko'),
      const Locale('en'),
      const Locale('ja'),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: supportedLocales.map((locale) {
            return RadioListTile<Locale?>(
              title: Row(
                children: [
                  Text(
                    getLanguageFlag(locale),
                    style: const TextStyle(fontSize: AppConstants.fontSizeLarge),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(getLanguageLabel(locale)),
                ],
              ),
              value: locale,
              groupValue: currentLocale,
              onChanged: (value) {
                ref.read(appLocaleProvider.notifier).setLocale(value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeModeSettingProvider);
    final l10n = AppLocalizations.of(context)!;

    String getThemeLabel(ThemeModeEnum mode) {
      switch (mode) {
        case ThemeModeEnum.light:
          return l10n.light;
        case ThemeModeEnum.dark:
          return l10n.dark;
        case ThemeModeEnum.system:
          return l10n.systemSettings;
      }
    }

    IconData getThemeIcon(ThemeModeEnum mode) {
      switch (mode) {
        case ThemeModeEnum.light:
          return Icons.light_mode;
        case ThemeModeEnum.dark:
          return Icons.dark_mode;
        case ThemeModeEnum.system:
          return Icons.brightness_auto;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeModeEnum.values.map((mode) {
            return RadioListTile<ThemeModeEnum>(
              title: Row(
                children: [
                  Icon(
                    getThemeIcon(mode),
                    size: AppConstants.iconSizeMedium,
                    color: currentThemeMode == mode
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(getThemeLabel(mode)),
                ],
              ),
              value: mode,
              groupValue: currentThemeMode,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(themeModeSettingProvider.notifier)
                      .setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.task_alt,
              color: theme.colorScheme.primary,
              size: AppConstants.iconSizeLarge,
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(l10n.appTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.version} 1.0.0',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Text(
              l10n.appDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.spacingXLarge),
            Text(
              l10n.copyright,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppConstants.alphaStrong,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
