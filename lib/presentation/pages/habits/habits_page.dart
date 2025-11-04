import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/habit_providers.dart';
import '../habit_form/habit_form_page.dart';
import 'widgets/app_header_content.dart';
import 'widgets/habit_list_content.dart';

/// Habits 페이지 (View)
class HabitsPage extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HabitsPage({super.key, this.scaffoldKey});

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
        body: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              AppHeaderContent(scaffoldKey: scaffoldKey),
              // Habit List
              Expanded(
                child: habitsAsync.when(
                  data: (habits) => HabitListContent(habits: habits),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => _buildErrorState(theme, l10n, error),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFAB(context, l10n),
      ),
    );
  }

  /// FAB 빌드
  Widget _buildFAB(BuildContext context, AppLocalizations l10n) {
    return FloatingActionButton.extended(
      heroTag: 'habits_fab',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HabitFormPage()),
        );
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: const Icon(Icons.add),
      label: Text(
        l10n.newHabit,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(
    ThemeData theme,
    AppLocalizations l10n,
    Object error,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppConstants.iconSizeXLarge,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppConstants.spacingXLarge),
          Text(l10n.errorOccurred, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            error.toString(),
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
