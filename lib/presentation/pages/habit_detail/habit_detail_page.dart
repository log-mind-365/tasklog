import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/habit_providers.dart';
import '../habit_form/habit_form_page.dart';
import 'habit_detail_view_model.dart';
import 'widgets/habit_header_content.dart';
import 'widgets/heatmap_content.dart';
import 'widgets/statistics_content.dart';

/// HabitDetail 페이지 (View)
class HabitDetailPage extends ConsumerWidget {
  final int habitId;

  const HabitDetailPage({super.key, required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final habitAsync = ref.watch(habitByIdProvider(habitId));

    return habitAsync.when(
      data: (habit) {
        if (habit == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.errorOccurred)),
            body: Center(child: Text(l10n.errorOccurred)),
          );
        }

        // Get logs for the last 12 weeks
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final startDate = today.subtract(
          const Duration(days: AppConstants.defaultHistoryDays),
        );
        final logsAsync = ref.watch(
          habitLogsByDateRangeProvider(habit.id, startDate, today),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(habit.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HabitFormPage(habit: habit),
                    ),
                  );
                },
              ),
            ],
          ),
          body: logsAsync.when(
            data: (logs) {
              final viewModel = ref.read(habitDetailViewModelProvider.notifier);
              final statistics = viewModel.calculateStatistics(habit, logs);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HabitHeaderContent(habit: habit),
                    const Divider(height: AppConstants.dividerHeight),
                    StatisticsContent(
                      habit: habit,
                      statistics: statistics,
                    ),
                    const Divider(height: AppConstants.dividerHeight),
                    HeatmapContent(habit: habit, logs: logs),
                    const SizedBox(height: AppConstants.spacingHuge),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text(l10n.errorMessage(error.toString()))),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.errorOccurred)),
        body: Center(child: Text(l10n.errorMessage(error.toString()))),
      ),
    );
  }
}
