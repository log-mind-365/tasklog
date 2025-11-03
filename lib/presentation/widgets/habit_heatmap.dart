import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    this.weeksToShow = 12,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startDate = today.subtract(Duration(days: weeksToShow * 7 - 1));

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthLabels(startMonday, weeksToShow),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayLabels(),
                const SizedBox(width: 8),
                _buildHeatmapGrid(context, startMonday, normalizedToday, weeksToShow),
              ],
            ),
            const SizedBox(height: 16),
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
          width: 16,
          child: isFirstWeekOfMonth
              ? Text(
                  DateFormat('MMM').format(currentDate),
                  style: const TextStyle(fontSize: 10),
                )
              : null,
        ),
      );

      currentDate = currentDate.add(const Duration(days: 7));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(children: monthLabels),
    );
  }

  Widget _buildDayLabels() {
    const days = ['Mon', 'Wed', 'Fri'];
    const dayIndices = [0, 2, 4]; // Monday, Wednesday, Friday

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(7, (index) {
        final dayIndex = dayIndices.indexOf(index);
        return SizedBox(
          height: 16,
          width: 20,
          child: dayIndex != -1
              ? Text(
                  days[dayIndex],
                  style: const TextStyle(fontSize: 10),
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
        final weekStartDate = startDate.add(Duration(days: weekIndex * 7));

        return Column(
          children: List.generate(7, (dayIndex) {
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
      cellColor = colorScheme.surfaceContainerHighest.withOpacity(0.3);
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
        cellColor = habitColor.withOpacity(0.75);
      } else if (clampedRate >= 0.5) {
        cellColor = habitColor.withOpacity(0.5);
      } else {
        cellColor = habitColor.withOpacity(0.3);
      }
    }

    return Tooltip(
      message: _buildTooltipMessage(date, log, isInFuture),
      child: Container(
        width: 14,
        height: 14,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(2),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 0.5,
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
        const Text('Less', style: TextStyle(fontSize: 10)),
        const SizedBox(width: 4),
        _buildLegendCell(colorScheme.surfaceContainerHighest),
        _buildLegendCell(habitColor.withOpacity(0.3)),
        _buildLegendCell(habitColor.withOpacity(0.5)),
        _buildLegendCell(habitColor.withOpacity(0.75)),
        _buildLegendCell(habitColor),
        const SizedBox(width: 4),
        const Text('More', style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildLegendCell(Color color) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
