import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../providers/folder_providers.dart';
import '../../../widgets/color_picker_widget.dart';
import '../folder_management_view_model.dart';

/// 폴더 생성/수정 다이얼로그
class FolderFormDialog extends ConsumerStatefulWidget {
  final FolderEntity? folder;

  const FolderFormDialog({super.key, this.folder});

  @override
  ConsumerState<FolderFormDialog> createState() => _FolderFormDialogState();
}

class _FolderFormDialogState extends ConsumerState<FolderFormDialog> {
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

    final viewModel = ref.read(folderManagementViewModelProvider.notifier);

    if (widget.folder != null) {
      // Update existing folder
      final updatedFolder = FolderEntity(
        id: widget.folder!.id,
        name: name,
        color: _selectedColor.toARGB32(),
        order: widget.folder!.order,
      );
      await viewModel.updateFolder(context, updatedFolder);
    } else {
      // Add new folder
      final foldersAsync = ref.read(foldersStreamProvider);
      final currentFolders = foldersAsync.value ?? [];
      final newOrder = currentFolders.length;

      await viewModel.addFolder(context, name, _selectedColor, newOrder);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
