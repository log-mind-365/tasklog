import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';

class TodoFormDueDatePicker extends StatelessWidget {
  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const TodoFormDueDatePicker({
    super.key,
    required this.dueDate,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dueDate,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaIntense,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingXLarge),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: AppConstants.alphaStrong,
                ),
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusXLarge,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSmall),
                    decoration: BoxDecoration(
                      color: dueDate != null
                          ? theme.colorScheme.primary.withValues(
                              alpha: AppConstants.alphaLight,
                            )
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        AppConstants.spacingSmall,
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      color: dueDate != null
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(
                              alpha: AppConstants.alphaStrong,
                            ),
                      size: AppConstants.iconSizeXSmall,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingXLarge),
                  Expanded(
                    child: Text(
                      dueDate == null
                          ? l10n.selectDueDate
                          : l10n.dueDateFormat(
                              dueDate!.year,
                              dueDate!.month,
                              dueDate!.day,
                            ),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: dueDate != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: dueDate != null
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withValues(
                                alpha: AppConstants.alphaStrong,
                              ),
                      ),
                    ),
                  ),
                  if (dueDate != null)
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: AppConstants.alphaStrong,
                        ),
                      ),
                      onPressed: onClear,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
