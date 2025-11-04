import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/ui_utils.dart';
import '../../domain/entities/folder_entity.dart';
import '../providers/folder_providers.dart';
import '../providers/providers.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/color_picker_widget.dart';

class FolderManagementPage extends ConsumerWidget {
  const FolderManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('폴더 관리'), elevation: 0),
      body: foldersAsync.when(
        data: (folders) => folders.isEmpty
            ? const EmptyStateWidget(
                icon: Icons.folder_outlined,
                message: '폴더가 없습니다',
              )
            : ReorderableListView.builder(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                itemCount: folders.length,
                onReorder: (oldIndex, newIndex) {
                  _reorderFolders(ref, folders, oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return _FolderListItem(
                    key: ValueKey(folder.id),
                    folder: folder,
                    onEdit: () =>
                        _showFolderDialog(context, ref, folder: folder),
                    onDelete: () => _deleteFolder(context, ref, folder),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFolderDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _reorderFolders(
    WidgetRef ref,
    List<FolderEntity> folders,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final movedFolder = folders[oldIndex];
    final reorderedFolders = List<FolderEntity>.from(folders);
    reorderedFolders.removeAt(oldIndex);
    reorderedFolders.insert(newIndex, movedFolder);

    // Update order for all affected folders
    for (int i = 0; i < reorderedFolders.length; i++) {
      final folder = reorderedFolders[i];
      if (folder.order != i) {
        final updatedFolder = FolderEntity(
          id: folder.id,
          name: folder.name,
          color: folder.color,
          order: i,
        );
        await ref.read(updateFolderUseCaseProvider)(updatedFolder);
      }
    }
  }

  void _deleteFolder(
    BuildContext context,
    WidgetRef ref,
    FolderEntity folder,
  ) async {
    final confirmed = await UiUtils.showDeleteConfirmationDialog(
      context,
      title: '폴더 삭제',
      message: '${folder.name} 폴더를 삭제하시겠습니까?\n이 폴더의 할일들은 "전체"로 이동됩니다.',
    );

    if (confirmed) {
      try {
        await ref.read(deleteFolderUseCaseProvider)(folder.id);
        if (context.mounted) {
          UiUtils.showSuccessSnackBar(context, '폴더가 삭제되었습니다');
        }
      } catch (e) {
        if (context.mounted) {
          UiUtils.showErrorSnackBar(context, '오류가 발생했습니다: $e');
        }
      }
    }
  }

  void _showFolderDialog(
    BuildContext context,
    WidgetRef ref, {
    FolderEntity? folder,
  }) {
    showDialog(
      context: context,
      builder: (context) => _FolderFormDialog(folder: folder),
    );
  }
}

class _FolderListItem extends StatelessWidget {
  final FolderEntity folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _FolderListItem({
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

class _FolderFormDialog extends ConsumerStatefulWidget {
  final FolderEntity? folder;

  const _FolderFormDialog({this.folder});

  @override
  ConsumerState<_FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends ConsumerState<_FolderFormDialog> {
  late TextEditingController _nameController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder?.name ?? '');
    _selectedColor = widget.folder != null
        ? Color(widget.folder!.color)
        : Color(AppPalette.colorValues[0]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.folder != null;

    return AlertDialog(
      title: Text(isEditing ? '폴더 편집' : '새 폴더'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '폴더 이름',
                hintText: '폴더 이름을 입력하세요',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppConstants.spacingXLarge),
            ColorPickerWidget(
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              label: '색상 선택',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _saveFolder,
          child: Text(isEditing ? '저장' : '추가'),
        ),
      ],
    );
  }

  Future<void> _saveFolder() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      UiUtils.showErrorSnackBar(context, '폴더 이름을 입력하세요');
      return;
    }

    try {
      if (widget.folder != null) {
        // Update existing folder
        final updatedFolder = FolderEntity(
          id: widget.folder!.id,
          name: name,
          color: _selectedColor.value,
          order: widget.folder!.order,
        );
        await ref.read(updateFolderUseCaseProvider)(updatedFolder);
      } else {
        // Add new folder
        final foldersAsync = ref.read(foldersStreamProvider);
        final currentFolders = foldersAsync.value ?? [];
        final newOrder = currentFolders.length;

        final newFolder = FolderEntity(
          id: 0, // Will be auto-generated by database
          name: name,
          color: _selectedColor.value,
          order: newOrder,
        );
        await ref.read(addFolderUseCaseProvider)(newFolder);
      }

      if (mounted) {
        Navigator.of(context).pop();
        UiUtils.showSuccessSnackBar(
          context,
          widget.folder != null ? '폴더가 수정되었습니다' : '폴더가 추가되었습니다',
        );
      }
    } catch (e) {
      if (mounted) {
        UiUtils.showErrorSnackBar(context, '오류가 발생했습니다: $e');
      }
    }
  }
}
