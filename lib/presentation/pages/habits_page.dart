import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_providers.dart';
import '../widgets/habit_item.dart';
import 'habit_detail_page.dart';
import 'habit_form_page.dart';

class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          habitsAsync.when(
            data: (habits) => _buildHabitList(context, ref, habits),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar.large(
      title: Text(
        'Habits',
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      centerTitle: false,
      floating: true,
      backgroundColor: theme.colorScheme.surface,
      expandedHeight: AppConstants.spacingMassive,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: AppConstants.spacingXLarge, bottom: AppConstants.spacingXLarge),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: AppConstants.alphaLight),
                theme.colorScheme.secondary.withValues(alpha: AppConstants.alphaLight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitList(
    BuildContext context,
    WidgetRef ref,
    List<HabitEntity> habits,
  ) {
    if (habits.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.track_changes, size: AppConstants.iconSizeXLarge, color: Colors.grey),
              SizedBox(height: AppConstants.spacingXLarge),
              Text(
                'No habits yet',
                style: TextStyle(fontSize: AppConstants.fontSizeLarge, color: Colors.grey),
              ),
              SizedBox(height: AppConstants.spacingMedium),
              Text(
                'Tap + to create your first habit',
                style: TextStyle(fontSize: AppConstants.fontSizeMedium, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppConstants.spacingXLarge),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final habit = habits[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingLarge),
              child: HabitItem(
                habit: habit,
                onTap: () => _navigateToDetail(context, habit),
                onIncrement: () => _incrementHabit(ref, habit.id),
                onDecrement: () => _decrementHabit(ref, habit.id),
                onDelete: () => _deleteHabit(context, ref, habit),
              ),
            );
          },
          childCount: habits.length,
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'habits_fab',
      onPressed: () => _navigateToForm(context),
      icon: const Icon(Icons.add),
      label: const Text('New Habit'),
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
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final useCase = ref.read(deleteHabitUseCaseProvider);
      await useCase(habit.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${habit.name} deleted')),
        );
      }
    }
  }
}
