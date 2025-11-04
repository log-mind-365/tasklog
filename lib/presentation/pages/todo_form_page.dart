import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/priority.dart';
import '../../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../providers/category_providers.dart';
import '../extensions/priority_extension.dart';

class TodoFormPage extends ConsumerStatefulWidget {
  final TodoEntity? todo;

  const TodoFormPage({super.key, this.todo});

  @override
  ConsumerState<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends ConsumerState<TodoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Priority _priority;
  DateTime? _dueDate;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(text: widget.todo?.description ?? '');
    _priority = widget.todo?.priority ?? Priority.medium;
    _dueDate = widget.todo?.dueDate;
    _categoryId = widget.todo?.categoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;

    final addUseCase = ref.read(addTodoUseCaseProvider);
    final updateUseCase = ref.read(updateTodoUseCaseProvider);

    final todo = TodoEntity(
      id: widget.todo?.id ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      isDone: widget.todo?.isDone ?? false,
      priority: _priority,
      dueDate: _dueDate,
      categoryId: _categoryId,
      createdAt: widget.todo?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.todo == null) {
        await addUseCase(todo);
      } else {
        await updateUseCase(todo);
      }
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: AppConstants.spacingMedium),
                Text(widget.todo == null ? l10n.todoAdded : l10n.todoUpdated),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error saving todo: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(child: Text(l10n.errorMessage(e.toString()))),
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

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
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

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsyncValue = ref.watch(categoriesStreamProvider);

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
          widget.todo == null ? l10n.newTodo : l10n.editTodo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
          children: [
            // Title Field
            Text(
              l10n.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l10n.enterTodoTitle,
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: AppConstants.alphaStrong),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXXLarge,
                  vertical: AppConstants.spacingXLarge,
                ),
              ),
              style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterTitle;
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),

            // Description Field
            Text(
              l10n.description,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: l10n.descriptionHint,
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: AppConstants.alphaStrong),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingXXLarge,
                  vertical: AppConstants.spacingXLarge,
                ),
              ),
              maxLines: 4,
              style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),

            // Priority Selector
            Text(
              l10n.priority,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Row(
              children: Priority.values.map((priority) {
                final isSelected = _priority == priority;
                Color color;
                IconData icon;
                switch (priority) {
                  case Priority.low:
                    color = Colors.green;
                    icon = Icons.arrow_downward;
                    break;
                  case Priority.medium:
                    color = Colors.orange;
                    icon = Icons.remove;
                    break;
                  case Priority.high:
                    color = Colors.red;
                    icon = Icons.arrow_upward;
                    break;
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppConstants.spacingMedium),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _priority = priority),
                        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingLarge),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: AppConstants.alphaMedium)
                                : theme.colorScheme.surfaceVariant.withValues(alpha: AppConstants.alphaStrong),
                            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : theme.colorScheme.outline.withValues(alpha: AppConstants.alphaMedium),
                              width: isSelected ? AppConstants.borderWidthMedium : AppConstants.borderWidthThin,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                icon,
                                color: isSelected ? color : theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                                size: AppConstants.iconSizeXSmall,
                              ),
                              const SizedBox(height: AppConstants.spacingXSmall),
                              Text(
                                priority.getLocalizedName(context),
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? color : theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),

            // Due Date
            Text(
              l10n.dueDate,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _selectDueDate,
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingXLarge),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withValues(alpha: AppConstants.alphaStrong),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingSmall),
                        decoration: BoxDecoration(
                          color: _dueDate != null
                              ? theme.colorScheme.primary.withValues(alpha: AppConstants.alphaLight)
                              : theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppConstants.spacingSmall),
                        ),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: _dueDate != null
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                          size: AppConstants.iconSizeXSmall,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingXLarge),
                      Expanded(
                        child: Text(
                          _dueDate == null
                              ? l10n.selectDueDate
                              : l10n.dueDateFormat(
                                  _dueDate!.year,
                                  _dueDate!.month,
                                  _dueDate!.day,
                                ),
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: _dueDate != null ? FontWeight.w600 : FontWeight.normal,
                            color: _dueDate != null
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                          ),
                        ),
                      ),
                      if (_dueDate != null)
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                          ),
                          onPressed: () => setState(() => _dueDate = null),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),

            // Category
            Text(
              l10n.category,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            categoriesAsyncValue.when(
              data: (categories) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXLarge),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withValues(alpha: AppConstants.alphaStrong),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  ),
                  child: DropdownButtonFormField<int?>(
                    value: _categoryId,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: AppConstants.spacingMedium),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(l10n.noCategory),
                      ),
                      ...categories.map((category) {
                        return DropdownMenuItem(
                          value: category.id,
                          child: Row(
                            children: [
                              Container(
                                width: AppConstants.spacingLarge,
                                height: AppConstants.spacingLarge,
                                decoration: BoxDecoration(
                                  color: Color(category.color),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingLarge),
                              Text(category.name),
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _categoryId = value;
                      });
                    },
                  ),
                );
              },
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
                  borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                ),
                child: Text(
                  l10n.cannotLoadCategories,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingHuge),

            // Save Button
            Container(
              height: AppConstants.spacingGiant,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                color: theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: AppConstants.alphaStrong),
                    blurRadius: AppConstants.spacingLarge,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveTodo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white),
                    const SizedBox(width: AppConstants.spacingMedium),
                    Text(
                      widget.todo == null ? l10n.addTodo : l10n.saveChanges,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
