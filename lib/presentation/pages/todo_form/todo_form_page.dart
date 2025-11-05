import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/todo_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/folder_providers.dart';
import 'todo_form_view_model.dart';
import 'widgets/todo_form_category_dropdown.dart';
import 'widgets/todo_form_description_field.dart';
import 'widgets/todo_form_due_date_picker.dart';
import 'widgets/todo_form_priority_selector.dart';
import 'widgets/todo_form_save_button.dart';
import 'widgets/todo_form_title_field.dart';

class TodoFormPage extends ConsumerWidget {
  final TodoEntity? todo;
  final int? defaultFolderId;

  const TodoFormPage({super.key, this.todo, this.defaultFolderId});

  Future<void> _selectDueDate(
    BuildContext context,
    WidgetRef ref,
    DateTime? currentDueDate,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      ref
          .read(todoFormViewModelProvider(todo, defaultFolderId).notifier)
          .setDueDate(picked);
    }
  }

  Future<void> _handleSave(BuildContext context, WidgetRef ref) async {
    final viewModel =
        ref.read(todoFormViewModelProvider(todo, defaultFolderId).notifier);
    final success = await viewModel.saveTodo(todo);

    if (context.mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: AppConstants.spacingMedium),
                Text(todo == null ? l10n.todoAdded : l10n.todoUpdated),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
          ),
        );
      } else {
        final state =
            ref.read(todoFormViewModelProvider(todo, defaultFolderId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(
                  child: Text(
                    l10n.errorMessage(state.errorMessage ?? 'Unknown error'),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(todoFormViewModelProvider(todo, defaultFolderId));
    final viewModel =
        ref.read(todoFormViewModelProvider(todo, defaultFolderId).notifier);
    final foldersAsyncValue = ref.watch(foldersStreamProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          todo == null ? l10n.newTodo : l10n.editTodo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
        children: [
          TodoFormTitleField(
            controller: viewModel.titleController,
            validator: viewModel.validateTitle,
          ),
          const SizedBox(height: AppConstants.spacingXXLarge),
          TodoFormDescriptionField(
            controller: viewModel.descriptionController,
          ),
          const SizedBox(height: AppConstants.spacingXXLarge),
          TodoFormPrioritySelector(
            selectedPriority: state.priority,
            onPriorityChanged: viewModel.setPriority,
          ),
          const SizedBox(height: AppConstants.spacingXXLarge),
          TodoFormDueDatePicker(
            dueDate: state.dueDate,
            onTap: () => _selectDueDate(context, ref, state.dueDate),
            onClear: viewModel.clearDueDate,
          ),
          const SizedBox(height: AppConstants.spacingXXLarge),
          foldersAsyncValue.when(
            data: (folders) => TodoFormCategoryDropdown(
              selectedFolderId: state.folderId,
              folders: folders,
              onChanged: viewModel.setFolderId,
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.spacingXLarge),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => Container(
              padding: const EdgeInsets.all(AppConstants.spacingXLarge),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusXLarge,
                ),
              ),
              child: Text(
                l10n.cannotLoadCategories,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingHuge),
          TodoFormSaveButton(
            onPressed: () => _handleSave(context, ref),
            label: todo == null ? l10n.addTodo : l10n.saveChanges,
            isLoading: state.isSaving,
          ),
        ],
      ),
    );
  }
}
