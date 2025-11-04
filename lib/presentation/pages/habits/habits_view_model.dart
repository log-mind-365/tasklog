import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/habit_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/habit_providers.dart';

part 'habits_view_model.g.dart';

/// Habits ViewModel
@riverpod
class HabitsViewModel extends _$HabitsViewModel {
  @override
  void build() {
    // No initial state needed
  }

  /// 습관 증가
  Future<void> incrementHabit(int habitId) async {
    final useCase = ref.read(incrementHabitLogUseCaseProvider);
    await useCase(habitId, DateTime.now());
  }

  /// 습관 감소
  Future<void> decrementHabit(int habitId) async {
    final useCase = ref.read(decrementHabitLogUseCaseProvider);
    await useCase(habitId, DateTime.now());
  }

  /// 습관 삭제 (다이얼로그 표시 포함)
  Future<void> deleteHabit(BuildContext context, HabitEntity habit) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteHabit),
        content: Text(l10n.deleteHabitConfirm(habit.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final useCase = ref.read(deleteHabitUseCaseProvider);
      await useCase(habit.id);

      if (context.mounted) {
        _showDeletedSnackbar(context, habit.name);
      }
    }
  }

  /// 삭제 완료 스낵바 표시
  void _showDeletedSnackbar(BuildContext context, String habitName) {
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(l10n.habitDeletedMessage(habitName)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
