import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import 'widgets/section_header.dart';
import 'widgets/theme_selector_tile.dart';
import 'widgets/language_selector_tile.dart';
import 'widgets/info_tile.dart';

/// Settings 페이지 (View)
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
          SectionHeader(title: l10n.theme),
          ThemeSelectorTile(themeMode: themeMode),
          const Divider(height: AppConstants.spacingXLarge),

          // 언어 설정 섹션
          SectionHeader(title: l10n.language),
          LanguageSelectorTile(locale: locale),
          const Divider(height: AppConstants.spacingXLarge),

          // 정보 섹션
          SectionHeader(title: l10n.information),
          InfoTile(
            icon: Icons.info_outline,
            title: l10n.version,
            subtitle: '1.0.0',
            onTap: null,
          ),
          InfoTile(
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
}
