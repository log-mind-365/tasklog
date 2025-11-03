import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/priority.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/providers.dart';

class TodoItem extends ConsumerWidget {
  final TodoEntity todo;
  final VoidCallback onTap;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleUseCase = ref.read(toggleTodoDoneUseCaseProvider);
    final deleteUseCase = ref.read(deleteTodoUseCaseProvider);

    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await deleteUseCase(todo.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${todo.title} 삭제됨')),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isDone,
            onChanged: (_) async {
              await toggleUseCase(todo.id);
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isDone ? TextDecoration.lineThrough : null,
              color: todo.isDone ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description.isNotEmpty)
                Text(
                  todo.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: todo.isDone ? Colors.grey : null,
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _PriorityChip(priority: todo.priority),
                  if (todo.dueDate != null) ...[
                    const SizedBox(width: 8),
                    _DueDateChip(dueDate: todo.dueDate!),
                  ],
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
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
    switch (priority) {
      case Priority.low:
        color = Colors.green;
        break;
      case Priority.medium:
        color = Colors.orange;
        break;
      case Priority.high:
        color = Colors.red;
        break;
    }

    return Chip(
      label: Text(
        priority.displayName,
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: color.withOpacity(0.2),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
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

    return Chip(
      label: Text(
        DateFormatter.formatDisplayDate(dueDate),
        style: const TextStyle(fontSize: 11),
      ),
      backgroundColor: color.withOpacity(0.2),
      avatar: Icon(Icons.calendar_today, size: 14, color: color),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
