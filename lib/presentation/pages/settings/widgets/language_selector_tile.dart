import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/settings_provider.dart';

class LanguageSelectorTile extends ConsumerWidget {
  final Locale? locale;

  const LanguageSelectorTile({super.key, required this.locale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: Icon(Icons.language, color: theme.colorScheme.primary),
      title: Text(l10n.language),
      subtitle: Text(_getLanguageLabel(l10n, locale)),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
      ),
      onTap: () => _showLanguageDialog(context, ref, l10n),
    );
  }

  String _getLanguageLabel(AppLocalizations l10n, Locale? locale) {
    if (locale == null) return l10n.systemSettings;
    switch (locale.languageCode) {
      case 'ko': return l10n.korean;
      case 'en': return l10n.english;
      case 'ja': return l10n.japanese;
      default: return locale.languageCode;
    }
  }

  String _getLanguageFlag(Locale? locale) {
    if (locale == null) return '🌐';
    switch (locale.languageCode) {
      case 'ko': return '🇰🇷';
      case 'en': return '🇺🇸';
      case 'ja': return '🇯🇵';
      default: return '🌐';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final locales = [null, const Locale('ko'), const Locale('en'), const Locale('ja')];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: locales.map((loc) {
            return RadioListTile<Locale?>(
              title: Row(
                children: [
                  Text(_getLanguageFlag(loc), style: const TextStyle(fontSize: AppConstants.iconSizeMedium)),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(_getLanguageLabel(l10n, loc)),
                ],
              ),
              value: loc,
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
  }
}
