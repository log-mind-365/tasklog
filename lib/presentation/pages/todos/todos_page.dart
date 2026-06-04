import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/folder_providers.dart';
import '../todo_form/widgets/todo_composer_bar.dart';
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
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: foldersAsyncValue.when(
            data: (folders) {
              final totalPages = folders.length + 1;
              final defaultFolderId = currentPageIndex == 0
                  ? null
                  : folders[currentPageIndex - 1].id;

              return Column(
                children: [
                  FolderNavigationContent(
                    folders: folders,
                    currentIndex: currentPageIndex,
                    pageController: _pageController,
                    scaffoldKey: widget.scaffoldKey,
                  ),
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
                        final pageFolderId = pageIndex == 0
                            ? null
                            : folders[pageIndex - 1].id;
                        final folderColor = pageIndex == 0
                            ? null
                            : folders[pageIndex - 1].color;

                        return TodoListContent(
                          folderId: pageFolderId,
                          folderColor: folderColor,
                        );
                      },
                    ),
                  ),
                  _buildComposerSection(defaultFolderId),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(theme, l10n, error),
          ),
        ),
      ),
    );
  }

  Widget _buildComposerSection(int? defaultFolderId) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppConstants.spacingLarge,
        AppConstants.spacingMedium,
        AppConstants.spacingLarge,
        AppConstants.spacingMedium + bottomInset,
      ),
      child: TodoComposerBar(
        key: ValueKey(defaultFolderId ?? 'all'),
        defaultFolderId: defaultFolderId,
      ),
    );
  }

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
