import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../todos_view_model.dart';
import '../../folder_management/folder_management_page.dart';
import 'filter_bottom_sheet.dart';

/// 폴더 네비게이션 콘텐츠
class FolderNavigationContent extends ConsumerWidget {
  final List<FolderEntity> folders;
  final int currentIndex;
  final PageController pageController;

  const FolderNavigationContent({
    super.key,
    required this.folders,
    required this.currentIndex,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final folderId = currentIndex == 0 ? -1 : folders[currentIndex - 1].id;
    final pageState = ref.watch(todoPageStateProvider(folderId));
    final viewModel = ref.read(todosViewModelProvider.notifier);

    // 폴더 리스트 구성 (전체 + folders)
    final folderItems = [
      {'name': '전체', 'color': null, 'index': 0},
      ...folders.asMap().entries.map((entry) {
        return {
          'name': entry.value.name,
          'color': Color(entry.value.color),
          'index': entry.key + 1,
        };
      }),
    ];

    return Container(
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Row(
        children: [
          // 스크롤 가능한 폴더 리스트
          Expanded(
            child: SizedBox(
              height: AppConstants.spacingGiant,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLarge,
                  vertical: AppConstants.spacingMedium,
                ),
                itemCount: folderItems.length,
                itemBuilder: (context, index) {
                  final folder = folderItems[index];
                  final isSelected = currentIndex == folder['index'] as int;
                  final folderColor = folder['color'] as Color?;
                  final folderName = folder['name'] as String;

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < folderItems.length - 1
                          ? AppConstants.spacingMedium
                          : 0,
                    ),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: AppConstants.iconSizeSmall,
                            height: AppConstants.iconSizeSmall,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  folderColor ??
                                  (isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: AppConstants.alphaStrong,
                                        )),
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
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(folderName),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          pageController.animateToPage(
                            folder['index'] as int,
                            duration: const Duration(
                              milliseconds: AppConstants.durationNormal,
                            ),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      selectedColor: theme.colorScheme.primaryContainer,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: AppConstants.alphaStrong),
                      labelStyle: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingMedium,
                        vertical: AppConstants.spacingSmall,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXLarge,
                        ),
                      ),
                      side: BorderSide.none,
                    ),
                  );
                },
              ),
            ),
          ),
          // 필터 버튼
          IconButton(
            icon: Icon(_getFilterIcon(pageState.filter)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => FilterBottomSheet(
                  currentFilter: pageState.filter,
                  onFilterSelected: (filter) {
                    viewModel.updateFilter(folderId, filter);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
          // 폴더 관리 버튼
          IconButton(
            icon: const Icon(Icons.create_new_folder),
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

  IconData _getFilterIcon(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.all:
        return Icons.all_inclusive;
      case TodoFilter.incomplete:
        return Icons.radio_button_unchecked;
      case TodoFilter.completed:
        return Icons.check_circle_outline;
    }
  }
}
