import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/folder_providers.dart';
import '../todo_form_page.dart';
import 'widgets/app_header_content.dart';
import 'widgets/folder_navigation_content.dart';
import 'widgets/todo_list_content.dart';

/// Todos 페이지 (View)
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
              final folderId = currentPageIndex == 0
                  ? -1
                  : folders[currentPageIndex - 1].id;

              return Column(
                children: [
                  // App Header (Title + Message + Search)
                  AppHeaderContent(
                    folderId: folderId,
                    scaffoldKey: widget.scaffoldKey,
                  ),
                  // Folder Navigation Header
                  FolderNavigationContent(
                    folders: folders,
                    currentIndex: currentPageIndex,
                    pageController: _pageController,
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

                        return TodoListContent(
                          folderId: folderId,
                          folderColor: folderColor,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(theme, l10n, error),
          ),
        ),
        floatingActionButton: _buildFAB(context, l10n, foldersAsyncValue),
      ),
    );
  }

  /// FAB 빌드
  Widget _buildFAB(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue foldersAsyncValue,
  ) {
    return foldersAsyncValue.maybeWhen(
      data: (folders) {
        final currentPageIndex = ref.watch(selectedFolderPageIndexProvider);
        final folderId = currentPageIndex == 0
            ? null
            : folders[currentPageIndex - 1].id;

        return FloatingActionButton.extended(
          heroTag: 'todos_fab',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoFormPage(defaultFolderId: folderId),
              ),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.add),
          label: Text(
            l10n.newTodo,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
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
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 24),
          Text(l10n.errorOccurred, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
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
