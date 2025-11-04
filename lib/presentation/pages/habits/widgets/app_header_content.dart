import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';

/// 앱 헤더 콘텐츠 (제목 + 메뉴 버튼)
class AppHeaderContent extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppHeaderContent({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLarge,
        vertical: AppConstants.spacingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.habitsPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXSmall),
                Text(
                  l10n.todayCheerMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: AppConstants.alphaVeryStrong,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 메뉴 버튼
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
            onPressed: () {
              scaffoldKey?.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
