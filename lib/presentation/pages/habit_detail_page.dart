import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../l10n/app_localizations.dart';
import '../providers/habit_providers.dart';
import '../widgets/habit_heatmap.dart';
import 'habit_form_page.dart';

class HabitDetailPage extends ConsumerWidget {
  final int habitId;

  const HabitDetailPage({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final habitAsync = ref.watch(habitByIdProvider(habitId));

    return habitAsync.when(
      data: (habit) {
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.errorOccurred)),
            body: Center(child: Text(l10n.errorOccurred)),
          );
        }

        final habitColor = Color(habit.color);

        // Get logs for the last 12 weeks
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final startDate = today.subtract(const Duration(days: AppConstants.defaultHistoryDays));
        final logsAsync = ref.watch(
          habitLogsByDateRangeProvider(habit.id, startDate, today),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEdit(context, habit),
              ),
            ],
          ),
          body: logsAsync.when(
            data: (logs) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHabitHeader(context, habit, habitColor, l10n),
                  const Divider(height: AppConstants.dividerHeight),
                  _buildStatistics(context, ref, habit, logs, l10n),
                  const Divider(height: AppConstants.dividerHeight),
                  _buildHeatmapSection(context, habit, logs, l10n),
                  const SizedBox(height: AppConstants.spacingHuge),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(l10n.errorMessage(error.toString()))),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.errorOccurred)),
        body: Center(child: Text(l10n.errorMessage(error.toString()))),
      ),
    );
  }

  Widget _buildHabitHeader(BuildContext context, HabitEntity habit, Color habitColor, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            habitColor.withValues(alpha: AppConstants.alphaMedium),
            habitColor.withValues(alpha: AppConstants.alphaLight),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
              boxShadow: [
                BoxShadow(
                  color: habitColor.withValues(alpha: AppConstants.alphaHigh),
                  blurRadius: AppConstants.spacingMedium,
                  offset: const Offset(0, AppConstants.spacingXSmall),
                ),
              ],
            ),
            child: Text(
              habit.icon,
              style: const TextStyle(fontSize: AppConstants.iconSizeHuge),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          Text(
            habit.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (habit.description.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              habit.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaIntense),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppConstants.spacingLarge),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingLarge,
              vertical: AppConstants.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: habitColor.withValues(alpha: AppConstants.alphaMedium),
              borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
            ),
            child: Text(
              l10n.dailyGoalWithCount(habit.goalCount),
              style: theme.textTheme.titleMedium?.copyWith(
                color: habitColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(
    BuildContext context,
    WidgetRef ref,
    HabitEntity habit,
    List<HabitLogEntity> logs,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final habitColor = Color(habit.color);

    // Calculate statistics
    final totalDays = logs.length;
    final completedDays = logs.where((log) => log.completedCount >= habit.goalCount).length;
    final totalCount = logs.fold<int>(0, (sum, log) => sum + log.completedCount);
    final completionRate = totalDays > 0 ? (completedDays / totalDays * 100) : 0.0;

    // Current streak
    final currentStreak = _calculateCurrentStreak(habit, logs);
    final longestStreak = _calculateLongestStreak(habit, logs);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statistics,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.completionRate,
                  '${completionRate.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  habitColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.totalCount,
                  totalCount.toString(),
                  Icons.numbers,
                  habitColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.currentStreak,
                  l10n.daysCount(currentStreak),
                  Icons.local_fire_department,
                  habitColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _buildStatCard(
                  context,
                  l10n.longestStreak,
                  l10n.daysCount(longestStreak),
                  Icons.military_tech,
                  habitColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.alphaLight),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: color.withValues(alpha: AppConstants.alphaHigh),
          width: AppConstants.borderWidthNormal,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppConstants.iconSizeXLarge),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXSmall),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapSection(BuildContext context, HabitEntity habit, List<HabitLogEntity> logs, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLarge),
          child: Text(
            l10n.activityHeatmap,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        HabitHeatmap(
          habit: habit,
          logs: logs.cast(),
        ),
      ],
    );
  }

  int _calculateCurrentStreak(HabitEntity habit, List<HabitLogEntity> logs) {
    if (logs.isEmpty) return 0;

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime checkDate = normalizedToday;

    while (true) {
      final log = logs.where((log) {
        final logDate = DateTime(log.date.year, log.date.month, log.date.day);
        return logDate.isAtSameMomentAs(checkDate);
      }).firstOrNull;

      if (log != null && log.completedCount >= habit.goalCount) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateLongestStreak(HabitEntity habit, List<HabitLogEntity> logs) {
    if (logs.isEmpty) return 0;

    // Sort logs by date
    final sortedLogs = List.from(logs);
    sortedLogs.sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final log in sortedLogs) {
      if (log.completedCount >= habit.goalCount) {
        final logDate = DateTime(log.date.year, log.date.month, log.date.day);

        if (lastDate == null || logDate.difference(lastDate).inDays == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
        } else if (logDate.difference(lastDate).inDays > 1) {
          currentStreak = 1;
        }

        lastDate = logDate;
      }
    }

    return longestStreak;
  }

  void _navigateToEdit(BuildContext context, HabitEntity habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitFormPage(habit: habit),
      ),
    );
  }
}
