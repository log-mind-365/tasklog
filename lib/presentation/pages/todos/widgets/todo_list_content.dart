import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/todo_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/todo_item.dart';
import '../todos_view_model.dart';
import '../../../providers/todo_providers.dart';
import 'todo_edit_bottom_sheet.dart';

/// Todo 리스트 콘텐츠
class TodoListContent extends ConsumerWidget {
  final int? folderId;
  final int? folderColor;

  const TodoListContent({super.key, required this.folderId, this.folderColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final todosAsyncValue = ref.watch(todosByFolderProvider(folderId));
    final viewModel = ref.read(todosViewModelProvider.notifier);

    // 페이지 상태 가져오기
    final stateKey = folderId ?? -1;
    final pageState = ref.watch(todoPageStateProvider(stateKey));

    return Column(
      children: [
        Expanded(
          child: todosAsyncValue.when(
            data: (todos) {
              // 필터링된 Todo 리스트 가져오기
              final filteredTodos = viewModel.getFilteredTodos(
                todos: todos,
                pageState: pageState,
              );

              if (filteredTodos.isEmpty) {
                return _buildEmptyState(
                  context,
                  theme,
                  l10n,
                  pageState.searchQuery.isNotEmpty,
                );
              }

              return _buildTodoList(context, ref, filteredTodos);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                _buildErrorState(context, theme, l10n, error),
          ),
        ),
      ],
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    bool isSearching,
  ) {
    final mutedColor = theme.colorScheme.onSurface.withValues(
      alpha: AppConstants.alphaStrong,
    );
    final subtleColor = theme.colorScheme.onSurface.withValues(
      alpha: AppConstants.alphaMedium,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isSearching ? l10n.noSearchResults : l10n.noTodos,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: mutedColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            isSearching ? l10n.tryDifferentKeyword : l10n.addNewTodo,
            style: theme.textTheme.bodyMedium?.copyWith(color: subtleColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Todo 리스트 위젯
  Widget _buildTodoList(
    BuildContext context,
    WidgetRef ref,
    List<TodoEntity> todos,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingMedium,
        bottom: AppConstants.spacingMassive,
      ),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onTap: () {
            TodoEditBottomSheet.show(
              context,
              todo: todo,
              defaultFolderId: folderId,
            );
          },
        );
      },
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Object error,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppConstants.iconSizeXLarge,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppConstants.spacingXLarge),
          Text(l10n.errorOccurred, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            error.toString(),
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
