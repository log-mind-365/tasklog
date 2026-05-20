import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// 박스 디자인과 일관된 드롭다운 surface 스타일.
class DropdownStyle {
  final Color backgroundColor;
  final Color? borderColor;
  final BorderRadius borderRadius;
  final double elevation;
  final Color shadowColor;
  final Color surfaceTintColor;

  const DropdownStyle._({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderRadius,
    required this.elevation,
    required this.shadowColor,
    required this.surfaceTintColor,
  });

  factory DropdownStyle.of(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return DropdownStyle._(
      backgroundColor: isDark
          ? theme.colorScheme.surfaceContainerHigh
          : Colors.white,
      borderColor: isDark
          ? theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaMediumLight,
            )
          : null,
      borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
      elevation: AppConstants.elevationMedium,
      shadowColor: theme.shadowColor.withValues(
        alpha: AppConstants.alphaVeryLight,
      ),
      surfaceTintColor: Colors.transparent,
    );
  }

  OutlinedBorder get shape => RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: borderColor != null
            ? BorderSide(
                color: borderColor!,
                width: AppConstants.borderWidthNormal,
              )
            : BorderSide.none,
      );

  ButtonStyle get menuItemStyle => MenuItemButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLarge,
          vertical: AppConstants.spacingMedium,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      );
}
