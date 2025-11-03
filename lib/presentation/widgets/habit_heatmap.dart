import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_log_entity.dart';

class HabitHeatmap extends StatelessWidget {
  final HabitEntity habit;
  final List<HabitLogEntity> logs;
  final int weeksToShow;

  const HabitHeatmap({
    super.key,
    required this.habit,
    required this.logs,
    this.weeksToShow = AppConstants.defaultWeeksToShow,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: weeksToShow * AppConstants.daysPerWeek - 1));

    // Normalize to start of day
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);

    // Find the Monday before or on start date
    final startMonday = normalizedStart.subtract(
      Duration(days: normalizedStart.weekday - 1),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthLabels(startMonday, weeksToShow),
            const SizedBox(height: AppConstants.spacingSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayLabels(),
                const SizedBox(width: AppConstants.spacingSmall),
                _buildHeatmapGrid(context, startMonday, normalizedToday, weeksToShow),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthLabels(DateTime startDate, int weeks) {
    final monthLabels = <Widget>[];
    DateTime currentDate = startDate;

    for (int week = 0; week < weeks; week++) {
      final isFirstWeekOfMonth = week == 0 ||
          currentDate.month != currentDate.subtract(const Duration(days: 7)).month;

      monthLabels.add(
        SizedBox(
          width: AppConstants.spacingLarge,
          child: isFirstWeekOfMonth
              ? Text(
                  DateFormat('MMM').format(currentDate),
                  style: const TextStyle(fontSize: AppConstants.fontSizeXSmall),
                )
              : null,
        ),
      );

      currentDate = currentDate.add(const Duration(days: AppConstants.daysPerWeek));
    }

    return Padding(
      padding: const EdgeInsets.only(left: AppConstants.spacingXLarge + AppConstants.spacingSmall),
      child: Row(children: monthLabels),
    );
  }

  Widget _buildDayLabels() {
    const days = ['Mon', 'Wed', 'Fri'];
    const dayIndices = [0, 2, 4]; // Monday, Wednesday, Friday

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(AppConstants.daysPerWeek, (index) {
        final dayIndex = dayIndices.indexOf(index);
        return SizedBox(
          height: AppConstants.spacingLarge,
          width: AppConstants.spacingXLarge,
          child: dayIndex != -1
              ? Text(
                  days[dayIndex],
                  style: const TextStyle(fontSize: AppConstants.fontSizeXSmall),
                  textAlign: TextAlign.right,
                )
              : null,
        );
      }),
    );
  }

  Widget _buildHeatmapGrid(
    BuildContext context,
    DateTime startDate,
    DateTime today,
    int weeks,
  ) {
    // Create a map for quick lookup
    final logMap = <String, HabitLogEntity>{};
    for (final log in logs) {
      final normalizedDate = DateTime(log.date.year, log.date.month, log.date.day);
      final key = DateFormat('yyyy-MM-dd').format(normalizedDate);
      logMap[key] = log;
    }

    return Row(
      children: List.generate(weeks, (weekIndex) {
        final weekStartDate = startDate.add(Duration(days: weekIndex * AppConstants.daysPerWeek));

        return Column(
          children: List.generate(AppConstants.daysPerWeek, (dayIndex) {
            final currentDate = weekStartDate.add(Duration(days: dayIndex));
            final isInFuture = currentDate.isAfter(today);
            final dateKey = DateFormat('yyyy-MM-dd').format(currentDate);
            final log = logMap[dateKey];

            return _buildDayCell(
              context,
              currentDate,
              log,
              isInFuture,
            );
          }),
        );
      }),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime date,
    HabitLogEntity? log,
    bool isInFuture,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color cellColor;
    if (isInFuture) {
      cellColor = colorScheme.surfaceContainerHighest.withValues(alpha: AppConstants.alphaHigh);
    } else if (log == null || log.completedCount == 0) {
      cellColor = colorScheme.surfaceContainerHighest;
    } else {
      final completionRate = log.completedCount / habit.goalCount;
      final clampedRate = completionRate.clamp(0.0, 1.0);

      // Use habit color with varying opacity based on completion rate
      final habitColor = Color(habit.color);
      if (clampedRate >= 1.0) {
        cellColor = habitColor;
      } else if (clampedRate >= 0.75) {
        cellColor = habitColor.withValues(alpha: AppConstants.alphaVeryIntense);
      } else if (clampedRate >= 0.5) {
        cellColor = habitColor.withValues(alpha: AppConstants.alphaStrong);
      } else {
        cellColor = habitColor.withValues(alpha: AppConstants.alphaHigh);
      }
    }

    return Tooltip(
      message: _buildTooltipMessage(date, log, isInFuture),
      child: Container(
        width: AppConstants.cellSize,
        height: AppConstants.cellSize,
        margin: const EdgeInsets.all(AppConstants.spacingXXSmall),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: AppConstants.alphaMedium),
            width: AppConstants.borderWidthThin,
          ),
        ),
      ),
    );
  }

  String _buildTooltipMessage(DateTime date, HabitLogEntity? log, bool isInFuture) {
    final dateStr = DateFormat('yyyy-MM-dd (E)').format(date);

    if (isInFuture) {
      return '$dateStr\nNot yet';
    } else if (log == null || log.completedCount == 0) {
      return '$dateStr\n0 / ${habit.goalCount}';
    } else {
      return '$dateStr\n${log.completedCount} / ${habit.goalCount}';
    }
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final habitColor = Color(habit.color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Less', style: TextStyle(fontSize: AppConstants.fontSizeXSmall)),
        const SizedBox(width: AppConstants.spacingXSmall),
        _buildLegendCell(colorScheme.surfaceContainerHighest),
        _buildLegendCell(habitColor.withValues(alpha: AppConstants.alphaHigh)),
        _buildLegendCell(habitColor.withValues(alpha: AppConstants.alphaStrong)),
        _buildLegendCell(habitColor.withValues(alpha: AppConstants.alphaVeryIntense)),
        _buildLegendCell(habitColor),
        const SizedBox(width: AppConstants.spacingXSmall),
        const Text('More', style: TextStyle(fontSize: AppConstants.fontSizeXSmall)),
      ],
    );
  }

  Widget _buildLegendCell(Color color) {
    return Container(
      width: AppConstants.cellSize,
      height: AppConstants.cellSize,
      margin: const EdgeInsets.all(AppConstants.spacingXXSmall),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
      ),
    );
  }
}
