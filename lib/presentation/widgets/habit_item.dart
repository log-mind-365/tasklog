import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_providers.dart';

class HabitItem extends ConsumerWidget {
  final HabitEntity habit;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const HabitItem({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habitColor = Color(habit.color);

    // Watch today's log for this habit
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    return Card(
      elevation: AppConstants.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        side: BorderSide(
          color: habitColor.withValues(alpha: AppConstants.alphaHigh),
          width: AppConstants.borderWidthThick,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSmall),
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: AppConstants.alphaMedium),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: Text(
                      habit.icon,
                      style: const TextStyle(fontSize: AppConstants.iconSizeLarge),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (habit.description.isNotEmpty) ...[
                          const SizedBox(height: AppConstants.spacingXSmall),
                          Text(
                            habit.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaVeryStrong),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    color: theme.colorScheme.error,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              _buildTodayProgress(context, ref, normalizedToday, habitColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgress(
    BuildContext context,
    WidgetRef ref,
    DateTime today,
    Color habitColor,
  ) {
    final theme = Theme.of(context);
    final logsAsync = ref.watch(habitLogsProvider(habit.id));

    return logsAsync.when(
      data: (logs) {
        final todayLog = logs.where((log) {
          final logDate = DateTime(log.date.year, log.date.month, log.date.day);
          return logDate.isAtSameMomentAs(today);
        }).firstOrNull;

        final completedCount = todayLog?.completedCount ?? 0;
        final progress = completedCount / habit.goalCount;
        final clampedProgress = progress.clamp(0.0, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Today',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaVeryStrong),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(
                            '$completedCount / ${habit.goalCount}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: habitColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingSmall),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        child: LinearProgressIndicator(
                          value: clampedProgress,
                          backgroundColor: habitColor.withValues(alpha: AppConstants.alphaMedium),
                          valueColor: AlwaysStoppedAnimation(habitColor),
                          minHeight: AppConstants.spacingSmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.spacingLarge),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: completedCount > 0 ? onDecrement : null,
                      icon: const Icon(Icons.remove, size: AppConstants.iconSizeMedium),
                      style: IconButton.styleFrom(
                        backgroundColor: habitColor.withValues(alpha: AppConstants.alphaMedium),
                        foregroundColor: habitColor,
                        disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
                        disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaHigh),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    IconButton.filled(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add, size: AppConstants.iconSizeMedium),
                      style: IconButton.styleFrom(
                        backgroundColor: habitColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
