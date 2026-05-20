import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.folder != null;

    return AlertDialog(
      title: Text(isEditing ? l10n.editFolder : l10n.newFolder),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.folderNameLabel,
                hintText: l10n.enterFolderName,
                border: const OutlineInputBorder(),
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
              label: l10n.selectColor,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _saveFolder,
          child: Text(isEditing ? l10n.saveChanges : l10n.add),
        ),
      ],
    );
  }

  Future<void> _saveFolder() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      UiUtils.showErrorSnackBar(context, l10n.pleaseEnterFolderName);
      return;
    }

    final viewModel = ref.read(folderManagementViewModelProvider.notifier);

    if (widget.folder != null) {
      final updatedFolder = FolderEntity(
        id: widget.folder!.id,
        name: name,
        color: _selectedColor.toARGB32(),
        order: widget.folder!.order,
      );
      await viewModel.updateFolder(context, updatedFolder, l10n);
    } else {
      final foldersAsync = ref.read(foldersStreamProvider);
      final currentFolders = foldersAsync.value ?? [];
      final newOrder = currentFolders.length;

      await viewModel.addFolder(context, name, _selectedColor, newOrder, l10n);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
