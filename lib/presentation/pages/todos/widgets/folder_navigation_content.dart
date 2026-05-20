import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/dropdown_popup_animation.dart';
import '../../../widgets/dropdown_style.dart';
import '../../../widgets/scale_press_feedback.dart';
import '../../folder_management/widgets/folder_management_bottom_sheet.dart';
import '../todos_view_model.dart';

enum _MenuAction { folderManagement, openDrawer }

/// 폴더 네비게이션 콘텐츠
class FolderNavigationContent extends ConsumerWidget {
  final List<FolderEntity> folders;
  final int currentIndex;
  final PageController pageController;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const FolderNavigationContent({
    super.key,
    required this.folders,
    required this.currentIndex,
    required this.pageController,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final folderId = currentIndex == 0 ? -1 : folders[currentIndex - 1].id;
    final pageState = ref.watch(todoPageStateProvider(folderId));
    final viewModel = ref.read(todosViewModelProvider.notifier);
    final dropdownStyle = DropdownStyle.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingLarge,
        AppConstants.spacingMedium,
        AppConstants.spacingLarge,
        AppConstants.spacingXSmall,
      ),
      child: Row(
        children: [
          _buildCircularButton(
            context,
            PopupMenuButton<int>(
              popUpAnimationStyle: DropdownPopupAnimation.popUpStyle,
              icon: const Icon(Icons.folder),
              color: dropdownStyle.backgroundColor,
              surfaceTintColor: dropdownStyle.surfaceTintColor,
              shape: dropdownStyle.shape,
              elevation: dropdownStyle.elevation,
              shadowColor: dropdownStyle.shadowColor,
              onSelected: (index) => pageController.jumpToPage(index),
              itemBuilder: (context) {
                final items = <PopupMenuEntry<int>>[
                  _buildFolderMenuItem(
                    context: context,
                    index: 0,
                    name: '전체',
                    dotColor: theme.colorScheme.onSurfaceVariant,
                    isSelected: currentIndex == 0,
                  ),
                ];

                for (var i = 0; i < folders.length; i++) {
                  final folder = folders[i];
                  items.add(_buildFolderMenuItem(
                    context: context,
                    index: i + 1,
                    name: folder.name,
                    dotColor: Color(folder.color),
                    isSelected: currentIndex == i + 1,
                  ));
                }

                return items;
              },
            ),
          ),
          const Spacer(),
          _buildCircularButton(
            context,
            PopupMenuButton<Object>(
              popUpAnimationStyle: DropdownPopupAnimation.popUpStyle,
              icon: const Icon(Icons.tune),
              color: dropdownStyle.backgroundColor,
              surfaceTintColor: dropdownStyle.surfaceTintColor,
              shape: dropdownStyle.shape,
              elevation: dropdownStyle.elevation,
              shadowColor: dropdownStyle.shadowColor,
              onSelected: (value) {
                if (value is TodoFilter) {
                  viewModel.updateFilter(folderId, value);
                } else if (value == _MenuAction.folderManagement) {
                  FolderManagementBottomSheet.show(context);
                } else if (value == _MenuAction.openDrawer) {
                  scaffoldKey?.currentState?.openEndDrawer();
                }
              },
              itemBuilder: (context) => [
                CheckedPopupMenuItem<Object>(
                  value: TodoFilter.all,
                  checked: pageState.filter == TodoFilter.all,
                  child: Text(l10n.allTodos),
                ),
                CheckedPopupMenuItem<Object>(
                  value: TodoFilter.incomplete,
                  checked: pageState.filter == TodoFilter.incomplete,
                  child: Text(l10n.incompleteTodos),
                ),
                CheckedPopupMenuItem<Object>(
                  value: TodoFilter.completed,
                  checked: pageState.filter == TodoFilter.completed,
                  child: Text(l10n.completedTodos),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<Object>(
                  value: _MenuAction.folderManagement,
                  child: Row(
                    children: [
                      const Icon(Icons.create_new_folder),
                      const SizedBox(width: AppConstants.spacingMedium),
                      Text(l10n.folderManagement),
                    ],
                  ),
                ),
                PopupMenuItem<Object>(
                  value: _MenuAction.openDrawer,
                  child: Row(
                    children: [
                      const Icon(Icons.menu),
                      const SizedBox(width: AppConstants.spacingMedium),
                      Text(l10n.settings),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ScalePressFeedback(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? theme.colorScheme.surfaceContainerHigh
              : Colors.white,
          border: isDark
              ? Border.all(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: AppConstants.alphaMediumLight,
                  ),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(
                alpha: AppConstants.alphaVeryLight,
              ),
              blurRadius: AppConstants.spacingLarge,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  PopupMenuItem<int> _buildFolderMenuItem({
    required BuildContext context,
    required int index,
    required String name,
    required Color dotColor,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    return PopupMenuItem<int>(
      value: index,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppConstants.spacingSmall,
            height: AppConstants.spacingSmall,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Text(
            name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
