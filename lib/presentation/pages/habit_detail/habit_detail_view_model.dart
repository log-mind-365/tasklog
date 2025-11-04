import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/habit_entity.dart';
import '../../../domain/entities/habit_log_entity.dart';

part 'habit_detail_view_model.g.dart';

/// 습관 통계 데이터
class HabitStatistics {
  final int totalDays;
  final int completedDays;
  final int totalCount;
  final double completionRate;
  final int currentStreak;
  final int longestStreak;

  const HabitStatistics({
    required this.totalDays,
    required this.completedDays,
    required this.totalCount,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
  });
}

/// HabitDetail ViewModel
@riverpod
class HabitDetailViewModel extends _$HabitDetailViewModel {
  @override
  void build() {
    // No initial state needed
  }

  /// 습관 통계 계산
  HabitStatistics calculateStatistics(
    HabitEntity habit,
    List<HabitLogEntity> logs,
  ) {
    final totalDays = logs.length;
    final completedDays =
        logs.where((log) => log.completedCount >= habit.goalCount).length;
    final totalCount = logs.fold<int>(
      0,
      (sum, log) => sum + log.completedCount,
    );
    final completionRate =
        totalDays > 0 ? (completedDays / totalDays * 100) : 0.0;

    final currentStreak = _calculateCurrentStreak(habit, logs);
    final longestStreak = _calculateLongestStreak(habit, logs);

    return HabitStatistics(
      totalDays: totalDays,
      completedDays: completedDays,
      totalCount: totalCount,
      completionRate: completionRate,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
    );
  }

  /// 현재 연속 기록 계산
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

  /// 최장 연속 기록 계산
  int _calculateLongestStreak(HabitEntity habit, List<HabitLogEntity> logs) {
    if (logs.isEmpty) return 0;

    // Sort logs by date
    final sortedLogs = List<HabitLogEntity>.from(logs);
    sortedLogs.sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final log in sortedLogs) {
      if (log.completedCount >= habit.goalCount) {
        final logDate = DateTime(log.date.year, log.date.month, log.date.day);

        if (lastDate == null || logDate.difference(lastDate).inDays == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak
              ? currentStreak
              : longestStreak;
        } else if (logDate.difference(lastDate).inDays > 1) {
          currentStreak = 1;
        }

        lastDate = logDate;
      }
    }

    return longestStreak;
  }
}
