import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/habit_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../habit_detail_view_model.dart';

/// 통계 콘텐츠
class StatisticsContent extends StatelessWidget {
  final HabitEntity habit;
  final HabitStatistics statistics;

  const StatisticsContent({
    super.key,
    required this.habit,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final habitColor = Color(habit.color);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLarge,
      ),
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
                child: _StatCard(
                  label: l10n.completionRate,
                  value: '${statistics.completionRate.toStringAsFixed(1)}%',
                  icon: Icons.pie_chart,
                  color: habitColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _StatCard(
                  label: l10n.totalCount,
                  value: statistics.totalCount.toString(),
                  icon: Icons.numbers,
                  color: habitColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: l10n.currentStreak,
                  value: l10n.daysCount(statistics.currentStreak),
                  icon: Icons.local_fire_department,
                  color: habitColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _StatCard(
                  label: l10n.longestStreak,
                  value: l10n.daysCount(statistics.longestStreak),
                  icon: Icons.military_tech,
                  color: habitColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 통계 카드 위젯
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
}
