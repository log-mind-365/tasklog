import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../todos_view_model.dart';

/// 앱 헤더 콘텐츠 (제목 + 검색)
class AppHeaderContent extends ConsumerWidget {
  final int folderId;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AppHeaderContent({super.key, required this.folderId, this.scaffoldKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final pageState = ref.watch(todoPageStateProvider(folderId));
    final viewModel = ref.read(todosViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLarge,
        vertical: AppConstants.spacingMedium,
      ),
      child: pageState.isSearching
          ? _buildSearchBar(context, theme, l10n, viewModel)
          : _buildDefaultHeader(context, theme, l10n, viewModel),
    );
  }

  /// 검색 바
  Widget _buildSearchBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    TodosViewModel viewModel,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.searchTodos,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: AppConstants.alphaStrong,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusXLarge),
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
            ),
            style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
            onChanged: (value) {
              viewModel.updateSearchQuery(folderId, value);
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
          onPressed: () {
            viewModel.stopSearch(folderId);
          },
        ),
      ],
    );
  }

  /// 기본 헤더 (제목 + 메시지 + 버튼)
  Widget _buildDefaultHeader(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    TodosViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: AppConstants.alphaVeryStrong,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.search, color: theme.colorScheme.onSurface),
              onPressed: () {
                viewModel.startSearch(folderId);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
              onPressed: () {
                scaffoldKey?.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ],
    );
  }
}
