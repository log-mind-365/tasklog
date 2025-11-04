import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder_entity.dart';

/// 폴더 리스트 아이템
class FolderListItem extends StatelessWidget {
  final FolderEntity folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FolderListItem({
    required super.key,
    required this.folder,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final folderColor = Color(folder.color);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: folder.order,
          child: Icon(Icons.drag_handle, color: theme.colorScheme.outline),
        ),
        title: Row(
          children: [
            Container(
              width: AppConstants.iconSizeMedium,
              height: AppConstants.iconSizeMedium,
              decoration: BoxDecoration(
                color: folderColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(folder.name),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              tooltip: '편집',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: '삭제',
            ),
          ],
        ),
      ),
    );
  }
}
