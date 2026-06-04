import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/todo_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../todo_form/todo_form_view_model.dart';
import '../../todo_form/widgets/todo_form_editor_body.dart';
import '../../../providers/folder_providers.dart';

/// 할 일 탭 시 열리는 편집 바텀시트
class TodoEditBottomSheet extends ConsumerWidget {
  const TodoEditBottomSheet({
    super.key,
    required this.scrollController,
    required this.todo,
    required this.defaultFolderId,
  });

  final ScrollController scrollController;
  final TodoEntity todo;
  final int? defaultFolderId;

  static Future<void> show(
    BuildContext context, {
    required TodoEntity todo,
    int? defaultFolderId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.38,
        maxChildSize: 0.94,
        builder: (context, scrollController) => TodoEditBottomSheet(
          scrollController: scrollController,
          todo: todo,
          defaultFolderId: defaultFolderId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final foldersAsync = ref.watch(foldersStreamProvider);
    final viewModel = ref.read(
      todoFormViewModelProvider(todo, defaultFolderId).notifier,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingSmall),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppConstants.alphaMediumLight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingLarge,
              AppConstants.spacingSmall,
              AppConstants.spacingSmall,
              AppConstants.spacingXSmall,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: viewModel.titleController,
                    minLines: 1,
                    maxLines: 6,
                    textInputAction: TextInputAction.newline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.enterTodoTitle,
                      isDense: true,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingSmall,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintStyle: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: AppConstants.alphaStrong,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.cancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: foldersAsync.when(
              data: (folders) => SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  AppConstants.spacingLarge,
                  0,
                  AppConstants.spacingLarge,
                  AppConstants.spacingLarge +
                      MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: TodoFormEditorBody(
                  initialTodo: todo,
                  defaultFolderId: defaultFolderId,
                  folders: folders,
                  usePillTitleDecoration: false,
                  showTitleField: false,
                  onPostSaveSuccess: (ctx, _, __, {required wasEditing}) {
                    if (wasEditing && ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  },
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                child: Text(
                  l10n.cannotLoadCategories,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
