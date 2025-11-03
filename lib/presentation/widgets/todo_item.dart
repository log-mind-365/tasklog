import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/priority.dart';
import '../../domain/entities/todo_entity.dart';
import '../providers/providers.dart';

class TodoItem extends ConsumerWidget {
  final TodoEntity todo;
  final VoidCallback onTap;

  const TodoItem({super.key, required this.todo, required this.onTap});

  Color _getPriorityColor() {
    switch (todo.priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleUseCase = ref.read(toggleTodoDoneUseCaseProvider);
    final deleteUseCase = ref.read(deleteTodoUseCaseProvider);
    final priorityColor = _getPriorityColor();
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge, vertical: AppConstants.spacingSmall),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.spacingXXLarge),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: AppConstants.iconSizeLarge),
            SizedBox(height: AppConstants.spacingXSmall),
            Text(
              '삭제',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) async {
        await deleteUseCase(todo.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text('${todo.title} 삭제됨'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge, vertical: AppConstants.spacingSmall),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: AppConstants.alphaVeryLight),
              blurRadius: AppConstants.spacingMedium,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                border: Border(
                  left: BorderSide(color: priorityColor, width: 4),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingXLarge),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await toggleUseCase(todo.id);
                      },
                      child: Container(
                        width: AppConstants.iconSizeMedium,
                        height: AppConstants.iconSizeMedium,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: todo.isDone
                                ? priorityColor
                                : theme.dividerColor,
                            width: AppConstants.borderWidthMedium,
                          ),
                          color: todo.isDone
                              ? priorityColor
                              : Colors.transparent,
                        ),
                        child: todo.isDone
                            ? const Icon(
                                Icons.check,
                                size: AppConstants.iconSizeSmall,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingXLarge),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              decoration: todo.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isDone
                                  ? theme.textTheme.bodySmall?.color
                                  : theme.textTheme.titleMedium?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (todo.description.isNotEmpty) ...[
                            const SizedBox(height: AppConstants.spacingSmall),
                            Text(
                              todo.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: todo.isDone
                                    ? theme.textTheme.bodySmall?.color
                                          ?.withValues(alpha: AppConstants.alphaStrong)
                                    : theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                          const SizedBox(height: AppConstants.spacingMedium),
                          Wrap(
                            spacing: AppConstants.spacingMedium,
                            runSpacing: AppConstants.spacingXSmall,
                            children: [
                              _PriorityChip(priority: todo.priority),
                              if (todo.dueDate != null)
                                _DueDateChip(dueDate: todo.dueDate!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: theme.dividerColor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final Priority priority;

  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSmall, vertical: AppConstants.spacingXSmall),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: AppConstants.alphaLight),
            color.withValues(alpha: AppConstants.alphaMedium),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: color.withValues(alpha: AppConstants.alphaHigh), width: AppConstants.borderWidthThin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppConstants.iconSizeXSmall, color: color),
          const SizedBox(width: AppConstants.spacingXSmall),
          Text(
            priority.displayName,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DueDateChip extends StatelessWidget {
  final DateTime dueDate;

  const _DueDateChip({required this.dueDate});

  @override
  Widget build(BuildContext context) {
    final isOverdue = DateFormatter.isOverdue(dueDate);
    final isDueToday = DateFormatter.isDueToday(dueDate);

    Color color;
    if (isOverdue) {
      color = Colors.red;
    } else if (isDueToday) {
      color = Colors.orange;
    } else {
      color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingSmall, vertical: AppConstants.spacingXSmall),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: AppConstants.alphaLight),
            color.withValues(alpha: AppConstants.alphaMedium),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: color.withValues(alpha: AppConstants.alphaHigh), width: AppConstants.borderWidthThin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined, size: AppConstants.fontSizeSmall, color: color),
          const SizedBox(width: AppConstants.spacingXSmall),
          Text(
            DateFormatter.formatDisplayDate(dueDate),
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
