import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/folder_providers.dart';
import '../../widgets/empty_state_widget.dart';
import 'folder_management_view_model.dart';
import 'widgets/folder_form_dialog.dart';
import 'widgets/folder_list_item.dart';

/// FolderManagement 페이지 (View)
class FolderManagementPage extends ConsumerWidget {
  const FolderManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersAsync = ref.watch(foldersStreamProvider);
    final viewModel = ref.read(folderManagementViewModelProvider.notifier);

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
                  viewModel.reorderFolders(folders, oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final folder = folders[index];
                  return FolderListItem(
                    key: ValueKey(folder.id),
                    folder: folder,
                    onEdit: () => _showFolderDialog(context, folder: folder),
                    onDelete: () => viewModel.deleteFolder(context, folder),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFolderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFolderDialog(BuildContext context, {folder}) {
    showDialog(
      context: context,
      builder: (context) => FolderFormDialog(folder: folder),
    );
  }
}
