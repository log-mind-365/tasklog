import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/habit_entity.dart';
import '../../../../l10n/app_localizations.dart';

/// 습관 헤더 콘텐츠
class HabitHeaderContent extends StatelessWidget {
  final HabitEntity habit;

  const HabitHeaderContent({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final habitColor = Color(habit.color);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
      decoration: BoxDecoration(
        color: habitColor.withValues(alpha: AppConstants.alphaMediumLight),
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
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppConstants.alphaIntense,
                ),
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
}
