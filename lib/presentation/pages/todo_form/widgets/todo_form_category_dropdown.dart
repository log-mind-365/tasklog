import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../../l10n/app_localizations.dart';

class TodoFormCategoryDropdown extends StatelessWidget {
  final int? selectedFolderId;
  final List<FolderEntity> folders;
  final ValueChanged<int?> onChanged;

  const TodoFormCategoryDropdown({
    super.key,
    required this.selectedFolderId,
    required this.folders,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(
              alpha: AppConstants.alphaIntense,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXLarge,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: AppConstants.alphaStrong,
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          ),
          child: DropdownButtonFormField<int?>(
            initialValue: selectedFolderId,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: AppConstants.spacingMedium,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaStrong,
              ),
            ),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.noCategory)),
              ...folders.map((folder) {
                return DropdownMenuItem(
                  value: folder.id,
                  child: Row(
                    children: [
                      Container(
                        width: AppConstants.spacingLarge,
                        height: AppConstants.spacingLarge,
                        decoration: BoxDecoration(
                          color: Color(folder.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingLarge),
                      Text(folder.name),
                    ],
                  ),
                );
              }),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
