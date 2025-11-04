import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// 아이콘(이모지) 선택 위젯
class IconPickerWidget extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;
  final Color? highlightColor;
  final String? label;
  final List<String>? customIcons;

  const IconPickerWidget({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    this.highlightColor,
    this.label,
    this.customIcons,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icons = customIcons ?? AppPalette.habitIcons;
    final effectiveHighlightColor = highlightColor ?? theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaIntense,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.spacingXLarge),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: AppConstants.alphaStrong,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          ),
          child: Wrap(
            spacing: AppConstants.spacingSmall,
            runSpacing: AppConstants.spacingSmall,
            children: icons.map((icon) {
              final isSelected = icon == selectedIcon;
              return InkWell(
                onTap: () => onIconSelected(icon),
                borderRadius: BorderRadius.circular(AppConstants.spacingMedium),
                child: Container(
                  width: AppConstants.iconSizeXXLarge,
                  height: AppConstants.iconSizeXXLarge,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? effectiveHighlightColor.withValues(
                            alpha: AppConstants.alphaMedium,
                          )
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      AppConstants.spacingMedium,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? effectiveHighlightColor
                          : Colors.transparent,
                      width: AppConstants.borderWidthMedium,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    icon,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
