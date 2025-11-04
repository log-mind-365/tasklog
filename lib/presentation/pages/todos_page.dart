import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../providers/folder_providers.dart';
import '../providers/todo_providers.dart';
import '../widgets/todo_item.dart';
import 'todo_form_page.dart';
import 'folder_management_page.dart';

enum TodoFilter { all, incomplete, completed }

class TodosPage extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const TodosPage({super.key, this.scaffoldKey});

  @override
  ConsumerState<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends ConsumerState<TodosPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(selectedFolderPageIndexProvider);
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final foldersAsyncValue = ref.watch(foldersStreamProvider);
    final currentPageIndex = ref.watch(selectedFolderPageIndexProvider);

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
          child: foldersAsyncValue.when(
            data: (folders) {
              final totalPages = folders.length + 1; // +1 for "전체" folder

              return Column(
                children: [
                  // App Header (Title + Message)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.spacingXXLarge,
                      AppConstants.spacingXXLarge,
                      AppConstants.spacingXXLarge,
                      AppConstants.spacingLarge,
                    ),
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
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: AppConstants.alphaVeryStrong,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Folder Navigation Header
                  _buildFolderNavigation(
                    context,
                    folders,
                    currentPageIndex,
                    totalPages,
                  ),
                  // PageView
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: totalPages,
                      onPageChanged: (index) {
                        ref
                                .read(selectedFolderPageIndexProvider.notifier)
                                .state =
                            index;
                      },
                      itemBuilder: (context, pageIndex) {
                        // First page (index 0): "전체" folder (null folderId)
                        // Other pages: specific folder
                        final folderId = pageIndex == 0
                            ? null
                            : folders[pageIndex - 1].id;
                        final folderColor = pageIndex == 0
                            ? null
                            : folders[pageIndex - 1].color;

                        return _TodoListPage(
                          folderId: folderId,
                          folderColor: folderColor,
                          scaffoldKey: widget.scaffoldKey,
                        );
                      },
                    ),
                  ),
                ],
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
                  Text(l10n.errorOccurred, style: theme.textTheme.titleLarge),
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
        floatingActionButton: foldersAsyncValue.maybeWhen(
          data: (folders) {
            final folderId = currentPageIndex == 0
                ? null
                : folders[currentPageIndex - 1].id;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
                color: theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(
                      alpha: AppConstants.alphaStrong,
                    ),
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
                      builder: (context) =>
                          TodoFormPage(defaultFolderId: folderId),
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
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildFolderNavigation(
    BuildContext context,
    List folders,
    int currentIndex,
    int totalPages,
  ) {
    final theme = Theme.of(context);

    final folderName = currentIndex == 0
        ? '전체'
        : folders[currentIndex - 1].name;
    final folderColor = currentIndex == 0
        ? null
        : Color(folders[currentIndex - 1].color);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: AppConstants.borderWidthThin,
          ),
        ),
      ),
      child: Row(
        children: [
          // Left Arrow
          IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: currentIndex > 0
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(
                      alpha: AppConstants.alphaHigh,
                    ),
            ),
            onPressed: currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(
                        milliseconds: AppConstants.durationNormal,
                      ),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
          ),
          // Current Folder Display
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppConstants.iconSizeMedium,
                    height: AppConstants.iconSizeMedium,
                    decoration: BoxDecoration(
                      color: folderColor ?? theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusSmall,
                      ),
                    ),
                    child: Icon(
                      Icons.folder,
                      size: AppConstants.iconSizeXSmall,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(
                    folderName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  Text(
                    '${currentIndex + 1} / $totalPages',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: AppConstants.alphaVeryStrong,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right Arrow
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: currentIndex < totalPages - 1
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(
                      alpha: AppConstants.alphaHigh,
                    ),
            ),
            onPressed: currentIndex < totalPages - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(
                        milliseconds: AppConstants.durationNormal,
                      ),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
          ),
          // Folder Management Button
          IconButton(
            icon: Icon(
              Icons.create_new_folder,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FolderManagementPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Individual Todo List Page
class _TodoListPage extends ConsumerStatefulWidget {
  final int? folderId;
  final int? folderColor;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const _TodoListPage({
    required this.folderId,
    this.folderColor,
    this.scaffoldKey,
  });

  @override
  ConsumerState<_TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<_TodoListPage> {
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
    final todosAsyncValue = ref.watch(todosByFolderProvider(widget.folderId));

    return Column(
      children: [
        // Header (Search + Filter)
        Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchTodos,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: AppConstants.alphaStrong),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusXLarge,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingXXLarge,
                    vertical: AppConstants.spacingLarge,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: AppConstants.alphaStrong,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: AppConstants.alphaStrong,
                            ),
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              // Filter Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXLarge,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusXLarge,
                          ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getFilterIcon(),
                                  size: AppConstants.iconSizeXSmall,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                const SizedBox(
                                  width: AppConstants.spacingMedium,
                                ),
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
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  // Menu Button
                  IconButton(
                    icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
                    onPressed: () {
                      widget.scaffoldKey?.currentState?.openEndDrawer();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        // Todo List
        Expanded(
          child: todosAsyncValue.when(
            data: (todos) {
              // Apply filter
              final filteredByStatus = _filter == TodoFilter.incomplete
                  ? todos.where((todo) => !todo.isDone).toList()
                  : _filter == TodoFilter.completed
                  ? todos.where((todo) => todo.isDone).toList()
                  : todos;

              // Apply search
              final filteredTodos = _searchQuery.isEmpty
                  ? filteredByStatus
                  : filteredByStatus.where((todo) {
                      return todo.title.toLowerCase().contains(_searchQuery) ||
                          todo.description.toLowerCase().contains(_searchQuery);
                    }).toList();

              if (filteredTodos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          AppConstants.spacingXXLarge,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: AppConstants.alphaHigh,
                          ),
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
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: AppConstants.alphaVeryStrong,
                          ),
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
                ),
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
                  Text(l10n.errorOccurred, style: theme.textTheme.titleLarge),
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
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingXXLarge,
              ),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXXLarge,
            vertical: AppConstants.spacingXLarge,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(
                    alpha: AppConstants.alphaStrong,
                  )
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(
                        alpha: AppConstants.alphaVeryStrong,
                      ),
              ),
              const SizedBox(width: AppConstants.spacingXLarge),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
