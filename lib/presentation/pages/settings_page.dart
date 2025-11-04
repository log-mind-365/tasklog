import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

/// 설정 페이지
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeSettingProvider);
    final locale = ref.watch(appLocaleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          // 테마 설정 섹션
          _buildSectionHeader(context, l10n.theme),
          _buildThemeTile(context, ref, themeMode),
          const Divider(height: AppConstants.spacingXLarge),

          // 언어 설정 섹션
          _buildSectionHeader(context, l10n.language),
          _buildLanguageTile(context, ref, locale),
          const Divider(height: AppConstants.spacingXLarge),

          // 정보 섹션
          _buildSectionHeader(context, l10n.information),
          _buildInfoTile(
            context,
            icon: Icons.info_outline,
            title: l10n.version,
            subtitle: '1.0.0',
            onTap: null,
          ),
          _buildInfoTile(
            context,
            icon: Icons.description_outlined,
            title: l10n.license,
            subtitle: l10n.viewOpenSourceLicenses,
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: l10n.appTitle,
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingXLarge,
        AppConstants.spacingXLarge,
        AppConstants.spacingXLarge,
        AppConstants.spacingMedium,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    WidgetRef ref,
    ThemeModeEnum themeMode,
  ) {
    final theme = Theme.of(context);
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

    return ListTile(
      leading: Icon(
        Icons.palette_outlined,
        color: theme.colorScheme.primary,
      ),
      title: Text(l10n.theme),
      subtitle: Text(getThemeLabel(themeMode)),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(
          alpha: AppConstants.alphaStrong,
        ),
      ),
      onTap: () {
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
                        color: themeMode == mode
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: AppConstants.spacingMedium),
                      Text(getThemeLabel(mode)),
                    ],
                  ),
                  value: mode,
                  groupValue: themeMode,
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
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    WidgetRef ref,
    Locale? locale,
  ) {
    final theme = Theme.of(context);
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

    return ListTile(
      leading: Icon(
        Icons.language_outlined,
        color: theme.colorScheme.primary,
      ),
      title: Text(l10n.language),
      subtitle: Text(getLanguageLabel(locale)),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(
          alpha: AppConstants.alphaStrong,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.selectLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: supportedLocales.map((supportedLocale) {
                return RadioListTile<Locale?>(
                  title: Row(
                    children: [
                      Text(
                        getLanguageFlag(supportedLocale),
                        style: const TextStyle(fontSize: AppConstants.fontSizeLarge),
                      ),
                      const SizedBox(width: AppConstants.spacingMedium),
                      Text(getLanguageLabel(supportedLocale)),
                    ],
                  ),
                  value: supportedLocale,
                  groupValue: locale,
                  onChanged: (value) {
                    ref.read(appLocaleProvider.notifier).setLocale(value);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaStrong,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
