import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// 빈 상태를 표시하는 공통 위젯
class EmptyStateWidget extends StatelessWidget {
  final IconData? icon;
  final String message;
  final String? subtitle;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    this.icon,
    required this.message,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurface.withValues(
      alpha: AppConstants.alphaStrong,
    );
    final subtleColor = theme.colorScheme.onSurface.withValues(
      alpha: AppConstants.alphaMedium,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppConstants.iconSizeLarge * 3,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppConstants.spacingLarge),
          ],
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: mutedColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: subtleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppConstants.spacingXLarge),
            action!,
          ],
        ],
      ),
    );
  }
}
