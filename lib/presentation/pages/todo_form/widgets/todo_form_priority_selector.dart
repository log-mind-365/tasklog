import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/priority.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extensions/priority_extension.dart';

class TodoFormPrioritySelector extends StatelessWidget {
  final Priority selectedPriority;
  final ValueChanged<Priority> onPriorityChanged;

  const TodoFormPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.priority,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaIntense,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Row(
          children: Priority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            Color color;
            IconData icon;
            switch (priority) {
              case Priority.low:
                color = Colors.green;
                icon = Icons.arrow_downward;
                break;
              case Priority.medium:
                color = Colors.orange;
                icon = Icons.remove;
                break;
              case Priority.high:
                color = Colors.red;
                icon = Icons.arrow_upward;
                break;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: AppConstants.spacingMedium,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onPriorityChanged(priority),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusLarge,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingLarge,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: AppConstants.alphaMedium)
                            : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: AppConstants.alphaStrong),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusLarge,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? color
                              : theme.colorScheme.outline.withValues(
                                  alpha: AppConstants.alphaMedium,
                                ),
                          width: isSelected
                              ? AppConstants.borderWidthMedium
                              : AppConstants.borderWidthThin,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            color: isSelected
                                ? color
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: AppConstants.alphaStrong,
                                  ),
                            size: AppConstants.iconSizeXSmall,
                          ),
                          const SizedBox(height: AppConstants.spacingXSmall),
                          Text(
                            priority.getLocalizedName(context),
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.onSurface.withValues(
                                      alpha: AppConstants.alphaIntense,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
