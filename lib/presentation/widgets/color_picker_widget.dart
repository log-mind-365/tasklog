import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/ui_utils.dart';

/// 색상 선택 위젯
class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final String? label;
  final List<int>? customColorValues;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.label,
    this.customColorValues,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorValues = customColorValues ?? AppPalette.colorValues;
    final colors = colorValues.map((value) => Color(value)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppConstants.spacingMedium),
        ],
        Wrap(
          spacing: AppConstants.spacingMedium,
          runSpacing: AppConstants.spacingMedium,
          children: colors.map((color) {
            final isSelected = selectedColor.value == color.value;
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: theme.colorScheme.primary, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: AppConstants.alphaHigh,
                            ),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: UiUtils.getContrastColor(color),
                        size: AppConstants.iconSizeMedium,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
