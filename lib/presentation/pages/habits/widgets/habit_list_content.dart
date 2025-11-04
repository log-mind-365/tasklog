import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/habit_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/habit_item.dart';
import '../../habit_detail/habit_detail_page.dart';
import '../habits_view_model.dart';

/// 습관 리스트 콘텐츠
class HabitListContent extends ConsumerWidget {
  final List<HabitEntity> habits;

  const HabitListContent({super.key, required this.habits});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final viewModel = ref.read(habitsViewModelProvider.notifier);

    if (habits.isEmpty) {
      return _buildEmptyState(theme, l10n);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingMedium,
        bottom: AppConstants.spacingHuge,
        left: AppConstants.spacingLarge,
        right: AppConstants.spacingLarge,
      ),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingLarge),
          child: HabitItem(
            habit: habit,
            onTap: () => _navigateToDetail(context, habit),
            onIncrement: () => viewModel.incrementHabit(habit.id),
            onDecrement: () => viewModel.decrementHabit(habit.id),
            onDelete: () => viewModel.deleteHabit(context, habit),
          ),
        );
      },
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(
                alpha: AppConstants.alphaHigh,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.track_changes_outlined,
              size: AppConstants.iconSizeXLarge,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXXLarge),
          Text(
            l10n.noHabitsYet,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            l10n.tapToCreateFirstHabit,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaVeryStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 습관 상세 페이지로 이동
  void _navigateToDetail(BuildContext context, HabitEntity habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailPage(habitId: habit.id),
      ),
    );
  }
}
