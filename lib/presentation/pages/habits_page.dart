import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../../l10n/app_localizations.dart';
import '../providers/habit_providers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/habit_item.dart';
import 'habit_detail_page.dart';
import 'habit_form_page.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final habitsAsync = ref.watch(habitsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        endDrawer: const AppDrawer(),
        body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingXXLarge,
                AppConstants.spacingXXLarge,
                AppConstants.spacingXXLarge,
                AppConstants.spacingLarge,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.habitsPageTitle,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingXSmall),
                        Text(
                          l10n.todayCheerMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaVeryStrong),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu Button
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Habit List
            Expanded(
              child: habitsAsync.when(
                data: (habits) => _buildHabitList(context, ref, habits, l10n, theme),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppConstants.iconSizeXLarge,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: AppConstants.spacingXLarge),
                      Text(
                        l10n.errorOccurred,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context, l10n, theme),
    ),
    );
  }

  Widget _buildHabitList(
    BuildContext context,
    WidgetRef ref,
    List<HabitEntity> habits,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: AppConstants.alphaHigh),
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
                color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaVeryStrong),
              ),
            ),
          ],
        ),
      );
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
            onIncrement: () => _incrementHabit(ref, habit.id),
            onDecrement: () => _decrementHabit(ref, habit.id),
            onDelete: () => _deleteHabit(context, ref, habit, l10n),
          ),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: AppConstants.alphaStrong),
            blurRadius: AppConstants.spacingLarge,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        heroTag: 'habits_fab',
        onPressed: () => _navigateToForm(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          l10n.newHabit,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, HabitEntity habit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HabitDetailPage(habit: habit),
      ),
    );
  }

  void _navigateToForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HabitFormPage(),
      ),
    );
  }

  Future<void> _incrementHabit(WidgetRef ref, int habitId) async {
    final useCase = ref.read(incrementHabitLogUseCaseProvider);
    await useCase(habitId, DateTime.now());
  }

  Future<void> _decrementHabit(WidgetRef ref, int habitId) async {
    final useCase = ref.read(decrementHabitLogUseCaseProvider);
    await useCase(habitId, DateTime.now());
  }

  Future<void> _deleteHabit(
    BuildContext context,
    WidgetRef ref,
    HabitEntity habit,
    AppLocalizations l10n,
  ) async {
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: AppConstants.spacingMedium),
                Text(l10n.habitDeletedMessage(habit.name)),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
          ),
        );
      }
    }
  }
}
