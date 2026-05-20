import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/folder_providers.dart';
import '../../../widgets/empty_state_widget.dart';
import '../folder_management_view_model.dart';
import 'folder_form_dialog.dart';
import 'folder_list_item.dart';

/// 폴더 관리 바텀시트
class FolderManagementBottomSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const FolderManagementBottomSheet({
    super.key,
    required this.scrollController,
  });

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) =>
            FolderManagementBottomSheet(scrollController: scrollController),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final foldersAsync = ref.watch(foldersStreamProvider);
    final viewModel = ref.read(folderManagementViewModelProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXXLarge),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingMedium),
          Container(
            width: AppConstants.spacingXXXLarge,
            height: AppConstants.spacingXSmall,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingXXLarge,
              AppConstants.spacingXLarge,
              AppConstants.spacingMedium,
              AppConstants.spacingMedium,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppConstants.spacingLarge),
                Expanded(
                  child: Text(
                    l10n.folderManagement,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: l10n.newFolder,
                  onPressed: () => _showFolderDialog(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: foldersAsync.when(
              data: (folders) => folders.isEmpty
                  ? EmptyStateWidget(message: l10n.noFolders)
                  : ReorderableListView.builder(
                      scrollController: scrollController,
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
                          onEdit: () =>
                              _showFolderDialog(context, folder: folder),
                          onDelete: () =>
                              viewModel.deleteFolder(context, folder, l10n),
                        );
                      },
                    ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Text(l10n.errorMessage(error.toString())),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFolderDialog(BuildContext context, {FolderEntity? folder}) {
    showDialog<void>(
      context: context,
      builder: (context) => FolderFormDialog(folder: folder),
    );
  }
}
