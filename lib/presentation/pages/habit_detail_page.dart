import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_providers.dart';
import '../widgets/habit_heatmap.dart';
import 'habit_form_page.dart';

class HabitDetailPage extends ConsumerWidget {
  final HabitEntity habit;

  const HabitDetailPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitColor = Color(habit.color);

    // Get logs for the last 12 weeks
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 84));
    final logsAsync = ref.watch(
      habitLogsByDateRangeProvider(habit.id, startDate, today),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEdit(context),
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHabitHeader(context, habitColor),
              const Divider(height: 32),
              _buildStatistics(context, ref, logs),
              const Divider(height: 32),
              _buildHeatmapSection(context, logs),
              const SizedBox(height: 32),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildHabitHeader(BuildContext context, Color habitColor) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            habitColor.withOpacity(0.2),
            habitColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: habitColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              habit.icon,
              style: const TextStyle(fontSize: 48),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            habit.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (habit.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              habit.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: habitColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Daily Goal: ${habit.goalCount}',
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
    List<dynamic> logs,
  ) {
    final theme = Theme.of(context);
    final habitColor = Color(habit.color);

    // Calculate statistics
    final totalDays = logs.length;
    final completedDays = logs.where((log) => log.completedCount >= habit.goalCount).length;
    final totalCount = logs.fold<int>(0, (sum, log) => sum + (log.completedCount as int));
    final completionRate = totalDays > 0 ? (completedDays / totalDays * 100) : 0.0;

    // Current streak
    final currentStreak = _calculateCurrentStreak(logs);
    final longestStreak = _calculateLongestStreak(logs);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Completion Rate',
                  '${completionRate.toStringAsFixed(1)}%',
                  Icons.pie_chart,
                  habitColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Count',
                  totalCount.toString(),
                  Icons.numbers,
                  habitColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Current Streak',
                  '$currentStreak days',
                  Icons.local_fire_department,
                  habitColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Longest Streak',
                  '$longestStreak days',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapSection(BuildContext context, List<dynamic> logs) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Activity Heatmap',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        HabitHeatmap(
          habit: habit,
          logs: logs.cast(),
        ),
      ],
    );
  }

  int _calculateCurrentStreak(List<dynamic> logs) {
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

  int _calculateLongestStreak(List<dynamic> logs) {
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

  void _navigateToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitFormPage(habit: habit),
      ),
    );
  }
}
