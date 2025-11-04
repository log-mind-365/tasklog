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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: AppConstants.alphaLight,
            ),
            blurRadius: AppConstants.spacingXLarge,
            offset: const Offset(0, AppConstants.spacingXSmall),
          ),
        ],
      ),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
              border: Border.all(
                color: habitColor.withValues(
                  alpha: AppConstants.alphaMediumLight,
                ),
                width: AppConstants.borderWidthThick,
              ),
            ),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingXLarge),
                  decoration: BoxDecoration(
                    color: habitColor.withValues(
                      alpha: AppConstants.alphaVeryLight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        AppConstants.radiusXXLarge -
                            AppConstants.borderWidthThick,
                      ),
                      topRight: Radius.circular(
                        AppConstants.radiusXXLarge -
                            AppConstants.borderWidthThick,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: AppConstants.spacingGiant,
                        height: AppConstants.spacingGiant,
                        decoration: BoxDecoration(
                          color: habitColor.withValues(
                            alpha: AppConstants.alphaMedium,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusLarge,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            habit.icon,
                            style: const TextStyle(
                              fontSize: AppConstants.iconSizeXLarge,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingLarge),
                      // Habit Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            if (habit.description.isNotEmpty) ...[
                              const SizedBox(
                                height: AppConstants.spacingXSmall,
                              ),
                              Text(
                                habit.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: AppConstants.alphaVeryStrong,
                                  ),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: onDelete,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: AppConstants.alphaStrong,
                        ),
                        tooltip: 'Delete habit',
                      ),
                    ],
                  ),
                ),
                // Progress Section
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingXLarge),
                  child: _buildTodayProgress(
                    context,
                    ref,
                    normalizedToday,
                    habitColor,
                  ),
                ),
              ],
            ),
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
        final isCompleted = completedCount >= habit.goalCount;

        return Column(
          children: [
            // Progress Bar
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMedium,
                              vertical: AppConstants.spacingXSmall,
                            ),
                            decoration: BoxDecoration(
                              color: habitColor.withValues(
                                alpha: AppConstants.alphaMediumLight,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusLarge,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: AppConstants.iconSizeSmall,
                                  color: habitColor,
                                ),
                                const SizedBox(
                                  width: AppConstants.spacingXSmall,
                                ),
                                Text(
                                  'Today',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: habitColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMedium),
                          Text(
                            '$completedCount / ${habit.goalCount}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: habitColor,
                            ),
                          ),
                          if (isCompleted) ...[
                            const SizedBox(width: AppConstants.spacingSmall),
                            Icon(
                              Icons.celebration,
                              size: AppConstants.iconSizeMedium,
                              color: habitColor,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      // Modern Progress Bar
                      Container(
                        height: AppConstants.spacingMedium,
                        decoration: BoxDecoration(
                          color: habitColor.withValues(
                            alpha: AppConstants.alphaMediumLight,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusLarge,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusLarge,
                          ),
                          child: Stack(
                            children: [
                              LinearProgressIndicator(
                                value: clampedProgress,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation(habitColor),
                                minHeight: AppConstants.spacingMedium,
                              ),
                              if (isCompleted)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          habitColor,
                                          habitColor.withValues(alpha: 0.8),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Decrement Button
                Container(
                  decoration: BoxDecoration(
                    color: completedCount > 0
                        ? habitColor.withValues(
                            alpha: AppConstants.alphaMediumLight,
                          )
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusLarge,
                    ),
                  ),
                  child: IconButton(
                    onPressed: completedCount > 0 ? onDecrement : null,
                    icon: const Icon(
                      Icons.remove,
                      size: AppConstants.iconSizeMedium,
                    ),
                    color: completedCount > 0
                        ? habitColor
                        : theme.colorScheme.onSurface.withValues(
                            alpha: AppConstants.alphaHigh,
                          ),
                    tooltip: 'Decrease count',
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                // Increment Button
                Container(
                  decoration: BoxDecoration(
                    color: habitColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusLarge,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: habitColor.withValues(
                          alpha: AppConstants.alphaHigh,
                        ),
                        blurRadius: AppConstants.spacingMedium,
                        offset: const Offset(0, AppConstants.spacingXSmall),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: onIncrement,
                    icon: const Icon(
                      Icons.add,
                      size: AppConstants.iconSizeMedium,
                    ),
                    color: Colors.white,
                    tooltip: 'Increase count',
                  ),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingXLarge),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Text(
          'Error loading progress',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
