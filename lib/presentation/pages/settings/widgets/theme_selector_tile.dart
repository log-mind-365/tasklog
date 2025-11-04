import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';

class ThemeSelectorTile extends ConsumerWidget {
  final ThemeModeEnum themeMode;

  const ThemeSelectorTile({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: Icon(Icons.palette_outlined, color: theme.colorScheme.primary),
      title: Text(l10n.theme),
      subtitle: Text(_getThemeLabel(l10n, themeMode)),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
      ),
      onTap: () => _showThemeDialog(context, ref, theme, l10n),
    );
  }

  String _getThemeLabel(AppLocalizations l10n, ThemeModeEnum mode) {
    switch (mode) {
      case ThemeModeEnum.light: return l10n.light;
      case ThemeModeEnum.dark: return l10n.dark;
      case ThemeModeEnum.system: return l10n.systemSettings;
    }
  }

  IconData _getThemeIcon(ThemeModeEnum mode) {
    switch (mode) {
      case ThemeModeEnum.light: return Icons.light_mode;
      case ThemeModeEnum.dark: return Icons.dark_mode;
      case ThemeModeEnum.system: return Icons.brightness_auto;
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeData theme, AppLocalizations l10n) {
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
                  Icon(_getThemeIcon(mode), size: AppConstants.iconSizeMedium,
                    color: themeMode == mode ? theme.colorScheme.primary : theme.colorScheme.onSurface),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(_getThemeLabel(l10n, mode)),
                ],
              ),
              value: mode,
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeSettingProvider.notifier).setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
