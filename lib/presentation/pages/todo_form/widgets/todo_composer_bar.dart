import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../../domain/entities/priority.dart';
import '../../../../domain/entities/todo_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extensions/priority_extension.dart';
import '../../../providers/folder_providers.dart';
import '../../../providers/todo_composer_provider.dart';
import '../../../widgets/dropdown_style.dart';
import '../../../widgets/scale_press_feedback.dart';
import '../todo_form_view_model.dart';
import 'todo_composer_option_button.dart';

/// 할 일 채팅형 입력 바 (화면 하단 고정)
class TodoComposerBar extends ConsumerWidget {
  final int? defaultFolderId;

  const TodoComposerBar({
    super.key,
    required this.defaultFolderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final editingTodo = ref.watch(editingTodoProvider);
    final state = ref.watch(
      todoFormViewModelProvider(editingTodo, defaultFolderId),
    );
    final viewModel = ref.read(
      todoFormViewModelProvider(editingTodo, defaultFolderId).notifier,
    );
    final foldersAsync = ref.watch(foldersStreamProvider);

    return foldersAsync.when(
      data: (folders) => _buildContent(
        context,
        ref,
        theme,
        l10n,
        editingTodo,
        state,
        viewModel,
        folders,
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

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AppLocalizations l10n,
    TodoEntity? editingTodo,
    TodoFormState state,
    TodoFormViewModel viewModel,
    List<FolderEntity> folders,
  ) {
    final isEditing = editingTodo != null;
    final summaryChips = _buildSummaryChips(context, l10n, state, folders);
    final isDark = theme.brightness == Brightness.dark;
    final pillFillColor = isDark
        ? theme.colorScheme.surfaceContainerHigh
        : Colors.white;
    const pillBorderRadius = 999.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingXSmall),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isEditing) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.editTodo,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: AppConstants.alphaVeryStrong,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.cancel,
                  onPressed: () {
                    ref.read(editingTodoProvider.notifier).clear();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSmall),
          ],
          if (summaryChips.isNotEmpty) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: summaryChips),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TodoComposerOptionButton(
                  icon: Icons.folder_outlined,
                  isActive: state.folderId != null,
                  tooltip: l10n.folder,
                  menuChildren: _folderMenuItems(
                    context,
                    l10n,
                    folders,
                    state.folderId,
                    viewModel.setFolderId,
                  ),
                ),
                TodoComposerOptionButton(
                  icon: Icons.flag_outlined,
                  isActive: state.priority != Priority.medium,
                  tooltip: l10n.priority,
                  menuChildren: _priorityMenuItems(
                    context,
                    state.priority,
                    viewModel.setPriority,
                  ),
                ),
                TodoComposerOptionButton(
                  icon: Icons.event_outlined,
                  isActive: state.dueDate != null,
                  tooltip: l10n.dueDate,
                  menuChildren:
                      _dueDateMenuItems(context, l10n, viewModel, state),
                ),
                TodoComposerOptionButton(
                  icon: Icons.notes_outlined,
                  isActive: state.description.trim().isNotEmpty,
                  tooltip: l10n.description,
                  menuChildren: [
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingMedium),
                      child: _DescriptionMenuPanel(
                        controller: viewModel.descriptionController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  // 헤더 `PopupMenuButton`과 동일한 Material 최소 터치 영역(48)에 맞춤
                  height: AppConstants.spacingXHuge,
                  child: Container(
                    decoration: BoxDecoration(
                      color: pillFillColor,
                      borderRadius:
                          BorderRadius.circular(pillBorderRadius),
                      border: isDark
                          ? Border.all(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: AppConstants.alphaMediumLight,
                              ),
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(
                            alpha: AppConstants.alphaVeryLight,
                          ),
                          blurRadius: AppConstants.spacingMedium,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: viewModel.titleController,
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      textAlignVertical: TextAlignVertical.center,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: l10n.todoComposerHint,
                        filled: true,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingLarge,
                          vertical: AppConstants.spacingXSmall,
                        ),
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: AppConstants.alphaStrong,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              ScalePressFeedback(
                enabled: !state.isSaving,
                child: FilledButton(
                  onPressed: state.isSaving
                      ? null
                      : () => _handleSave(
                            context,
                            ref,
                            viewModel,
                            editingTodo,
                          ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(
                      AppConstants.spacingXHuge,
                      AppConstants.spacingXHuge,
                    ),
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  child: state.isSaving
                      ? SizedBox(
                          width: AppConstants.iconSizeMedium,
                          height: AppConstants.iconSizeMedium,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_upward,
                          size: AppConstants.iconSizeMedium,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSummaryChips(
    BuildContext context,
    AppLocalizations l10n,
    TodoFormState state,
    List<FolderEntity> folders,
  ) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    if (state.folderId != null) {
      for (final folder in folders) {
        if (folder.id == state.folderId) {
          chips.add(_summaryChip(theme, folder.name));
          break;
        }
      }
    }

    if (state.priority != Priority.medium) {
      chips.add(_summaryChip(theme, state.priority.getLocalizedName(context)));
    }

    if (state.dueDate != null) {
      final d = state.dueDate!;
      chips.add(
        _summaryChip(
          theme,
          l10n.dueDateFormat(d.year, d.month, d.day),
        ),
      );
    }

    if (state.description.trim().isNotEmpty) {
      chips.add(_summaryChip(theme, l10n.description));
    }

    return chips
        .map(
          (chip) => Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSmall),
            child: chip,
          ),
        )
        .toList();
  }

  Widget _summaryChip(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMedium,
        vertical: AppConstants.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(
          alpha: AppConstants.alphaVeryLight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(
            alpha: AppConstants.alphaMediumLight,
          ),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(
            alpha: AppConstants.alphaVeryStrong,
          ),
        ),
      ),
    );
  }

  List<Widget> _folderMenuItems(
    BuildContext context,
    AppLocalizations l10n,
    List<FolderEntity> folders,
    int? selectedFolderId,
    ValueChanged<int?> onChanged,
  ) {
    final theme = Theme.of(context);
    final menuItemStyle = DropdownStyle.of(context).menuItemStyle;

    Widget buildLabel(String name, Color dotColor, bool isSelected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppConstants.spacingSmall,
            height: AppConstants.spacingSmall,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      );
    }

    return [
      MenuItemButton(
        style: menuItemStyle,
        onPressed: () => onChanged(null),
        child: buildLabel(
          l10n.noFolder,
          theme.colorScheme.onSurfaceVariant,
          selectedFolderId == null,
        ),
      ),
      ...folders.map((folder) {
        final isSelected = selectedFolderId == folder.id;
        return MenuItemButton(
          style: menuItemStyle,
          onPressed: () => onChanged(folder.id),
          child: buildLabel(folder.name, Color(folder.color), isSelected),
        );
      }),
    ];
  }

  List<Widget> _priorityMenuItems(
    BuildContext context,
    Priority selected,
    ValueChanged<Priority> onChanged,
  ) {
    final theme = Theme.of(context);
    final menuItemStyle = DropdownStyle.of(context).menuItemStyle;

    return Priority.values.map((priority) {
      final isSelected = selected == priority;
      return MenuItemButton(
        style: menuItemStyle,
        onPressed: () => onChanged(priority),
        child: Text(
          priority.getLocalizedName(context),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _dueDateMenuItems(
    BuildContext context,
    AppLocalizations l10n,
    TodoFormViewModel viewModel,
    TodoFormState state,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final menuItemStyle = DropdownStyle.of(context).menuItemStyle;

    return [
      MenuItemButton(
        style: menuItemStyle,
        onPressed: () => viewModel.setDueDate(today),
        child: Text(l10n.dueToday),
      ),
      MenuItemButton(
        style: menuItemStyle,
        onPressed: () => viewModel.setDueDate(tomorrow),
        child: Text(l10n.dueTomorrow),
      ),
      MenuItemButton(
        style: menuItemStyle,
        onPressed: () => _pickDueDate(context, viewModel, state.dueDate),
        child: Text(l10n.pickDueDate),
      ),
      if (state.dueDate != null)
        MenuItemButton(
          style: menuItemStyle,
          onPressed: viewModel.clearDueDate,
          child: Text(l10n.clearDueDate),
        ),
    ];
  }

  Future<void> _pickDueDate(
    BuildContext context,
    TodoFormViewModel viewModel,
    DateTime? currentDueDate,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && context.mounted) {
      viewModel.setDueDate(picked);
    }
  }

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    TodoFormViewModel viewModel,
    TodoEntity? editingTodo,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await viewModel.saveTodo(editingTodo);

    if (!context.mounted) return;

    if (success) {
      final wasEditing = editingTodo != null;

      if (wasEditing) {
        ref.read(editingTodoProvider.notifier).clear();
      } else {
        viewModel.titleController.clear();
        viewModel.descriptionController.clear();
        viewModel.setPriority(Priority.medium);
        viewModel.clearDueDate();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wasEditing ? l10n.todoUpdated : l10n.todoAdded),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final errorKey = viewModel.validateTitle();
      final message = errorKey == 'pleaseEnterTitle'
          ? l10n.pleaseEnterTitle
          : l10n.errorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _DescriptionMenuPanel extends StatelessWidget {
  final TextEditingController controller;

  const _DescriptionMenuPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: 260,
      child: TextField(
        controller: controller,
        autofocus: true,
        maxLines: 4,
        minLines: 2,
        decoration: InputDecoration(
          hintText: l10n.addDescription,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          isDense: true,
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
