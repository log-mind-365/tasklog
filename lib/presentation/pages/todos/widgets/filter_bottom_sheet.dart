import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../todos_view_model.dart';

/// 필터 선택 바텀시트
class FilterBottomSheet extends StatelessWidget {
  final TodoFilter currentFilter;
  final Function(TodoFilter) onFilterSelected;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppConstants.spacingLarge),
            Container(
              width: AppConstants.spacingXXXLarge,
              height: AppConstants.spacingXSmall,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingXXLarge,
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: theme.colorScheme.primary),
                  const SizedBox(width: AppConstants.spacingLarge),
                  Text(
                    l10n.selectFilter,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingXLarge),
            FilterOption(
              icon: Icons.all_inclusive,
              label: l10n.filterAll,
              isSelected: currentFilter == TodoFilter.all,
              onTap: () => onFilterSelected(TodoFilter.all),
            ),
            FilterOption(
              icon: Icons.radio_button_unchecked,
              label: l10n.filterActive,
              isSelected: currentFilter == TodoFilter.incomplete,
              onTap: () => onFilterSelected(TodoFilter.incomplete),
            ),
            FilterOption(
              icon: Icons.check_circle_outline,
              label: l10n.filterCompleted,
              isSelected: currentFilter == TodoFilter.completed,
              onTap: () => onFilterSelected(TodoFilter.completed),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
          ],
        ),
      ),
    );
  }
}

/// 필터 옵션 위젯
class FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterOption({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXXLarge,
            vertical: AppConstants.spacingXLarge,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(
                    alpha: AppConstants.alphaStrong,
                  )
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(
                        alpha: AppConstants.alphaVeryStrong,
                      ),
              ),
              const SizedBox(width: AppConstants.spacingXLarge),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
