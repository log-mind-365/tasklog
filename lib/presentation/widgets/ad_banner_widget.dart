import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// 배너 광고 영역 스켈레톤 UI
class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: AppConstants.alphaStrong,
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: AppConstants.borderWidthThin,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
            ),
            const SizedBox(width: AppConstants.spacingLarge),
            Container(
              width: 80,
              height: 20,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
