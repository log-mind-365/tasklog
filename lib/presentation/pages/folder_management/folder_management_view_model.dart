import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/ui_utils.dart';
import '../../../domain/entities/folder_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';

part 'folder_management_view_model.g.dart';

/// FolderManagement ViewModel
@riverpod
class FolderManagementViewModel extends _$FolderManagementViewModel {
  @override
  void build() {
    // No initial state needed
  }

  /// 폴더 순서 재정렬
  Future<void> reorderFolders(
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

  /// 폴더 삭제
  Future<void> deleteFolder(
    BuildContext context,
    FolderEntity folder,
    AppLocalizations l10n,
  ) async {
    final confirmed = await UiUtils.showDeleteConfirmationDialog(
      context,
      title: l10n.deleteFolderTitle,
      message: l10n.deleteFolderConfirm(folder.name),
    );

    if (confirmed) {
      try {
        await ref.read(deleteFolderUseCaseProvider)(folder.id);
        if (context.mounted) {
          UiUtils.showSuccessSnackBar(context, l10n.folderDeleted);
        }
      } catch (e) {
        if (context.mounted) {
          UiUtils.showErrorSnackBar(context, l10n.errorMessage(e.toString()));
        }
      }
    }
  }

  /// 폴더 추가
  Future<void> addFolder(
    BuildContext context,
    String name,
    Color color,
    int order,
    AppLocalizations l10n,
  ) async {
    try {
      final newFolder = FolderEntity(
        id: 0,
        name: name,
        color: color.toARGB32(),
        order: order,
      );
      await ref.read(addFolderUseCaseProvider)(newFolder);

      if (context.mounted) {
        UiUtils.showSuccessSnackBar(context, l10n.folderAdded);
      }
    } catch (e) {
      if (context.mounted) {
        UiUtils.showErrorSnackBar(context, l10n.errorMessage(e.toString()));
      }
    }
  }

  /// 폴더 수정
  Future<void> updateFolder(
    BuildContext context,
    FolderEntity folder,
    AppLocalizations l10n,
  ) async {
    try {
      await ref.read(updateFolderUseCaseProvider)(folder);

      if (context.mounted) {
        UiUtils.showSuccessSnackBar(context, l10n.folderUpdated);
      }
    } catch (e) {
      if (context.mounted) {
        UiUtils.showErrorSnackBar(context, l10n.errorMessage(e.toString()));
      }
    }
  }
}
