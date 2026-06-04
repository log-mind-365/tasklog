import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/folder_providers.dart';
import 'todo_form_editor_body.dart';

/// 할 일 채팅형 입력 바 (화면 하단 고정, 신규 할 일 전용)
class TodoComposerBar extends ConsumerWidget {
  final int? defaultFolderId;

  const TodoComposerBar({super.key, required this.defaultFolderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final foldersAsync = ref.watch(foldersStreamProvider);

    return foldersAsync.when(
      data: (folders) => Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacingXSmall),
        child: TodoFormEditorBody(
          initialTodo: null,
          defaultFolderId: defaultFolderId,
          folders: folders,
        ),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(AppConstants.spacingXXLarge),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        child: Text(
          l10n.cannotLoadCategories,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      ),
    );
  }
}
