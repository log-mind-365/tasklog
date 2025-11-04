import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/habit_entity.dart';
import '../../../../domain/entities/habit_log_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/habit_heatmap.dart';

/// 히트맵 콘텐츠
class HeatmapContent extends StatelessWidget {
  final HabitEntity habit;
  final List<HabitLogEntity> logs;

  const HeatmapContent({
    super.key,
    required this.habit,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLarge,
          ),
          child: Text(
            l10n.activityHeatmap,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        HabitHeatmap(habit: habit, logs: logs.cast()),
      ],
    );
  }
}
