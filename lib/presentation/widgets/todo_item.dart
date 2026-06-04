import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/todo_card_description_parser.dart';
import '../../domain/entities/todo_entity.dart';
import '../../l10n/app_localizations.dart';
import '../extensions/card_color_extension.dart';
import '../extensions/priority_extension.dart';
import '../providers/folder_providers.dart';
import '../providers/providers.dart';

/// [todo.labels]와 설명 파서 태그를 합치되, 대소문자 무시 중복은 제거한다.
List<String> mergedTodoLabelTags(TodoEntity todo, List<String> descTagLabels) {
  final seen = <String>{};
  final out = <String>[];
  for (final l in todo.labels) {
    final k = l.toLowerCase();
    if (k.isEmpty || seen.contains(k)) continue;
    seen.add(k);
    out.add(l);
  }
  for (final l in descTagLabels) {
    final k = l.toLowerCase();
    if (k.isEmpty || seen.contains(k)) continue;
    seen.add(k);
    out.add(l);
  }
  return out;
}

class TodoItem extends ConsumerWidget {
  final TodoEntity todo;
  final VoidCallback onTap;

  const TodoItem({super.key, required this.todo, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggleUseCase = ref.read(toggleTodoDoneUseCaseProvider);
    final deleteUseCase = ref.read(deleteTodoUseCaseProvider);
    final foldersAsync = ref.watch(foldersStreamProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final descParts = parseTodoCardDescription(todo.description);
    final mergedTagLabels = mergedTodoLabelTags(todo, descParts.tagLabels);

    final folderChipData = foldersAsync.maybeWhen(
      data: (folders) {
        final id = todo.folderId;
        if (id == null) return null;
        for (final f in folders) {
          if (f.id == id) {
            return (name: f.name, dot: Color(f.color));
          }
        }
        return null;
      },
      orElse: () => null,
    );

    final onMuted = theme.colorScheme.onSurface.withValues(
      alpha: AppConstants.alphaStrong,
    );
    final cardColor = todo.cardColor?.background(theme.brightness);
    final doneStyle = todo.isDone
        ? TextStyle(decoration: TextDecoration.lineThrough, color: onMuted)
        : null;

    return Dismissible(
      key: Key(todo.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLarge,
          vertical: AppConstants.spacingSmall,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.spacingXXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: theme.colorScheme.onError,
              size: AppConstants.iconSizeLarge,
            ),
            const SizedBox(height: AppConstants.spacingXSmall),
            Text(
              l10n.delete,
              style: TextStyle(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) async {
        await deleteUseCase(todo.id);
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(l10n.todoDeletedMessage(todo.title)),
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
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLarge,
          vertical: AppConstants.spacingSmall,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLarge,
              vertical: AppConstants.spacingMedium,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacingXXSmall,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await toggleUseCase(todo.id);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: AppConstants.iconSizeMedium,
                      height: AppConstants.iconSizeMedium,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: todo.isDone
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: AppConstants.borderWidthMedium,
                        ),
                        color: todo.isDone
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                      child: todo.isDone
                          ? Icon(
                              Icons.check,
                              size: AppConstants.iconSizeSmall,
                              color: theme.colorScheme.onPrimary,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: todo.isDone ? onMuted : null,
                          decoration: doneStyle?.decoration,
                        ),
                      ),
                      if (mergedTagLabels.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingSmall),
                        Wrap(
                          spacing: AppConstants.spacingSmall,
                          runSpacing: AppConstants.spacingXSmall,
                          children: mergedTagLabels
                              .map(
                                (t) => _NeutralChip(label: '#$t', theme: theme),
                              )
                              .toList(),
                        ),
                      ],
                      if (descParts.mentionNames.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingSmall),
                        Wrap(
                          spacing: AppConstants.spacingSmall,
                          runSpacing: AppConstants.spacingXSmall,
                          children: descParts.mentionNames
                              .map(
                                (m) => _NeutralChip(label: '@$m', theme: theme),
                              )
                              .toList(),
                        ),
                      ],
                      if (descParts.subTasks.isNotEmpty) ...[
                        const SizedBox(height: AppConstants.spacingSmall),
                        ...descParts.subTasks.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingXXSmall,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppConstants.spacingXXSmall,
                                  ),
                                  child: Icon(
                                    Icons.fiber_manual_record,
                                    size: 6,
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(
                                  width: AppConstants.spacingSmall,
                                ),
                                Expanded(
                                  child: Text(
                                    s,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: todo.isDone ? onMuted : null,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (descParts.body.isNotEmpty) ...[
                        if (descParts.hasStructuredContent)
                          const SizedBox(height: AppConstants.spacingSmall),
                        Text(
                          descParts.body,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onMuted,
                            height: 1.35,
                            decoration: doneStyle?.decoration,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppConstants.spacingMedium),
                      Wrap(
                        spacing: AppConstants.spacingSmall,
                        runSpacing: AppConstants.spacingXSmall,
                        children: [
                          _NeutralChip(
                            theme: theme,
                            label: todo.priority.getLocalizedName(context),
                          ),
                          if (todo.dueDate != null)
                            _NeutralChip(
                              theme: theme,
                              label: DateFormatter.formatDisplayDate(
                                todo.dueDate!,
                              ),
                              icon: Icons.calendar_today_outlined,
                            ),
                          if (folderChipData != null)
                            _NeutralChip(
                              theme: theme,
                              label: folderChipData.name,
                              leadingDot: folderChipData.dot,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppConstants.spacingXXSmall,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [TodoComposerBar]의 요약 칩과 동일한 톤
class _NeutralChip extends StatelessWidget {
  const _NeutralChip({
    required this.theme,
    required this.label,
    this.icon,
    this.leadingDot,
  });

  final ThemeData theme;
  final String label;
  final IconData? icon;
  final Color? leadingDot;

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingDot != null) ...[
            Container(
              width: AppConstants.spacingSmall,
              height: AppConstants.spacingSmall,
              decoration: BoxDecoration(
                color: leadingDot,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
          ],
          if (icon != null) ...[
            Icon(
              icon,
              size: AppConstants.iconSizeXSmall,
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaVeryStrong,
              ),
            ),
            const SizedBox(width: AppConstants.spacingXSmall),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaVeryStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
