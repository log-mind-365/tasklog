import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/todo_providers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/todo_item.dart';
import 'todo_form_page.dart';

enum TodoFilter { all, incomplete, completed }

class TodosPage extends ConsumerStatefulWidget {
  const TodosPage({super.key});

  @override
  ConsumerState<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends ConsumerState<TodosPage> {
  TodoFilter _filter = TodoFilter.all;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getFilterLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (_filter) {
      case TodoFilter.all:
        return l10n.filterAll;
      case TodoFilter.incomplete:
        return l10n.filterActive;
      case TodoFilter.completed:
        return l10n.filterCompleted;
    }
  }

  IconData _getFilterIcon() {
    switch (_filter) {
      case TodoFilter.all:
        return Icons.all_inclusive;
      case TodoFilter.incomplete:
        return Icons.radio_button_unchecked;
      case TodoFilter.completed:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final todosAsyncValue = _filter == TodoFilter.incomplete
        ? ref.watch(incompleteTodosStreamProvider)
        : _filter == TodoFilter.completed
            ? ref.watch(completedTodosStreamProvider)
            : ref.watch(todosStreamProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      endDrawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.spacingXXLarge, AppConstants.spacingXXLarge, AppConstants.spacingXXLarge, AppConstants.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.appTitle,
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
                      // Filter Button
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => _FilterBottomSheet(
                                  currentFilter: _filter,
                                  onFilterSelected: (filter) {
                                    setState(() {
                                      _filter = filter;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingXLarge,
                                vertical: AppConstants.spacingLarge,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getFilterIcon(),
                                    size: AppConstants.iconSizeXSmall,
                                    color: theme.colorScheme.onPrimaryContainer,
                                  ),
                                  const SizedBox(width: AppConstants.spacingMedium),
                                  Text(
                                    _getFilterLabel(context),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMedium),
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
                  const SizedBox(height: AppConstants.spacingXLarge),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withValues(alpha: AppConstants.alphaStrong),
                      borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: AppConstants.alphaLight),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchTodos,
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaStrong),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXLarge,
                          vertical: AppConstants.spacingMedium,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Todo List
            Expanded(
              child: todosAsyncValue.when(
                data: (todos) {
                  final filteredTodos = _searchQuery.isEmpty
                      ? todos
                      : todos.where((todo) {
                          return todo.title.toLowerCase().contains(_searchQuery) ||
                              todo.description.toLowerCase().contains(_searchQuery);
                        }).toList();

                  if (filteredTodos.isEmpty) {
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
                              _searchQuery.isNotEmpty
                                  ? Icons.search_off
                                  : Icons.inbox_outlined,
                              size: AppConstants.iconSizeXLarge,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingXXLarge),
                          Text(
                            _searchQuery.isNotEmpty
                                ? l10n.noSearchResults
                                : l10n.noTodos,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingMedium),
                          Text(
                            _searchQuery.isNotEmpty
                                ? l10n.tryDifferentKeyword
                                : l10n.addNewTodo,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaVeryStrong),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: AppConstants.spacingMedium, bottom: AppConstants.spacingHuge),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoItem(
                        todo: todo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoFormPage(todo: todo),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
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
      floatingActionButton: Container(
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
          heroTag: 'todos_fab',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TodoFormPage(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            l10n.newTodo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Filter Bottom Sheet
class _FilterBottomSheet extends StatelessWidget {
  final TodoFilter currentFilter;
  final Function(TodoFilter) onFilterSelected;

  const _FilterBottomSheet({
    required this.currentFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXXLarge),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppConstants.spacingLarge),
            Container(
              width: AppConstants.spacingXXXLarge,
              height: AppConstants.spacingXSmall,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXXLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXXLarge),
              child: Row(
                children: [
                  Icon(Icons.filter_list, color: theme.colorScheme.primary),
                  const SizedBox(width: AppConstants.spacingLarge),
                  Text(
                    l10n.selectFilter,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingXLarge),
            _FilterOption(
              icon: Icons.all_inclusive,
              label: l10n.filterAll,
              isSelected: currentFilter == TodoFilter.all,
              onTap: () => onFilterSelected(TodoFilter.all),
            ),
            _FilterOption(
              icon: Icons.radio_button_unchecked,
              label: l10n.filterActive,
              isSelected: currentFilter == TodoFilter.incomplete,
              onTap: () => onFilterSelected(TodoFilter.incomplete),
            ),
            _FilterOption(
              icon: Icons.check_circle_outline,
              label: l10n.filterCompleted,
              isSelected: currentFilter == TodoFilter.completed,
              onTap: () => onFilterSelected(TodoFilter.completed),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
          ],
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXXLarge, vertical: AppConstants.spacingXLarge),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: AppConstants.alphaStrong)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: AppConstants.alphaVeryStrong),
              ),
              const SizedBox(width: AppConstants.spacingXLarge),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
