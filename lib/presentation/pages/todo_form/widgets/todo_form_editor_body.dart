import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/card_color.dart';
import '../../../../domain/entities/folder_entity.dart';
import '../../../../domain/entities/priority.dart';
import '../../../../domain/entities/todo_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../extensions/card_color_extension.dart';
import '../../../extensions/priority_extension.dart';
import '../../../widgets/dropdown_style.dart';
import '../../../widgets/scale_press_feedback.dart';
import '../todo_form_view_model.dart';
import 'label_select_bottom_sheet.dart';
import 'todo_composer_option_button.dart';

/// 할 일 폼 본문 (옵션 행 + 제목 + 저장). 컴포저·편집 바텀시트에서 공유한다.
class TodoFormEditorBody extends ConsumerWidget {
  const TodoFormEditorBody({
    super.key,
    required this.initialTodo,
    required this.defaultFolderId,
    required this.folders,
    this.onPostSaveSuccess,
    this.titleFieldMaxLines = 4,
    this.titleFieldMinLines = 1,
    this.usePillTitleDecoration = true,
    this.showTitleField = true,
  });

  final TodoEntity? initialTodo;
  final int? defaultFolderId;
  final List<FolderEntity> folders;

  /// 저장 성공 직후 (스낵바 전에 호출). 시트는 여기서 `pop` 등 처리.
  final void Function(
    BuildContext context,
    WidgetRef ref,
    TodoFormViewModel viewModel, {
    required bool wasEditing,
  })?
  onPostSaveSuccess;

  final int titleFieldMaxLines;
  final int titleFieldMinLines;
  final bool usePillTitleDecoration;

  /// false면 본문에서 제목 입력을 그리지 않는다 (편집 시트는 헤더에 제목을 둠).
  final bool showTitleField;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(
      todoFormViewModelProvider(initialTodo, defaultFolderId),
    );
    final viewModel = ref.read(
      todoFormViewModelProvider(initialTodo, defaultFolderId).notifier,
    );

    final summaryChips = _buildSummaryChips(context, l10n, state, folders);

    final optionsRow = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          TodoComposerOptionButton(
            icon: Icons.folder_outlined,
            isActive: state.folderId != null,
            tooltip: l10n.folder,
            menuChildren: _folderMenuItems(
              context,
              l10n,
              folders,
              state.folderId,
              viewModel.setFolderId,
            ),
          ),
          TodoComposerOptionButton(
            icon: Icons.flag_outlined,
            isActive: state.priority != Priority.medium,
            tooltip: l10n.priority,
            menuChildren: _priorityMenuItems(
              context,
              state.priority,
              viewModel.setPriority,
            ),
          ),
          TodoComposerOptionButton(
            icon: Icons.event_outlined,
            isActive: state.dueDate != null,
            tooltip: l10n.dueDate,
            menuChildren: _dueDateMenuItems(context, l10n, viewModel, state),
          ),
          TodoComposerOptionButton(
            icon: Icons.label_outline,
            isActive: state.labels.isNotEmpty,
            tooltip: l10n.labelSheetTitle,
            menuChildren: const [],
            onTap: () => LabelSelectBottomSheet.show(
              context,
              initialTodo: initialTodo,
              defaultFolderId: defaultFolderId,
            ),
          ),
          TodoComposerOptionButton(
            icon: Icons.palette_outlined,
            isActive: state.cardColor != null,
            tooltip: l10n.cardColorTooltip,
            swatchColor:
                state.cardColor?.swatch ??
                theme.colorScheme.surfaceContainerHighest,
            menuChildren: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: _CardColorMenuPanel(
                  selected: state.cardColor,
                  onSelected: viewModel.setCardColor,
                  onClear: viewModel.clearCardColor,
                  l10n: l10n,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final descriptionField = _InlineDescriptionField(
      controller: viewModel.descriptionController,
      hintText: l10n.addDescription,
    );

    final saveButton = ScalePressFeedback(
      enabled: !state.isSaving,
      child: FilledButton(
        onPressed: state.isSaving
            ? null
            : () => _handleSave(context, ref, viewModel, initialTodo, folders),
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            AppConstants.spacingXHuge,
            AppConstants.spacingXHuge,
          ),
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
        ),
        child: state.isSaving
            ? SizedBox(
                width: AppConstants.iconSizeMedium,
                height: AppConstants.iconSizeMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : const Icon(
                Icons.arrow_upward,
                size: AppConstants.iconSizeMedium,
              ),
      ),
    );

    final chipsSection = <Widget>[
      if (summaryChips.isNotEmpty) ...[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: summaryChips),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
      ],
    ];

    // 편집 시트: 제목은 시트 헤더에 위치하므로 본문은 설명 입력을 맨 위에 둔다.
    if (!showTitleField) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          descriptionField,
          const SizedBox(height: AppConstants.spacingMedium),
          ...chipsSection,
          optionsRow,
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [saveButton],
          ),
        ],
      );
    }

    // 컴포저: 옵션 → 설명 → 제목+저장
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...chipsSection,
        optionsRow,
        const SizedBox(height: AppConstants.spacingSmall),
        descriptionField,
        const SizedBox(height: AppConstants.spacingSmall),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: AppConstants.spacingXHuge,
                child: usePillTitleDecoration
                    ? Container(
                        decoration: _composerPillDecoration(theme),
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.centerLeft,
                        child: _TitleField(
                          controller: viewModel.titleController,
                          maxLines: titleFieldMaxLines,
                          minLines: titleFieldMinLines,
                          hintText: l10n.todoComposerHint,
                          transparentFill: true,
                          borderless: true,
                        ),
                      )
                    : _TitleField(
                        controller: viewModel.titleController,
                        maxLines: titleFieldMaxLines,
                        minLines: titleFieldMinLines,
                        hintText: l10n.enterTodoTitle,
                        transparentFill: false,
                        borderless: false,
                      ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            saveButton,
          ],
        ),
      ],
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    WidgetRef ref,
    TodoFormViewModel viewModel,
    TodoEntity? editingTodo,
    List<FolderEntity> folders,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await viewModel.saveTodo(editingTodo, folders: folders);

    if (!context.mounted) return;

    if (success) {
      final wasEditing = editingTodo != null;
      if (!wasEditing) {
        viewModel.titleController.clear();
        viewModel.descriptionController.clear();
        viewModel.setPriority(Priority.medium);
        viewModel.clearDueDate();
        viewModel.clearLabels();
        viewModel.clearCardColor();
      }

      onPostSaveSuccess?.call(context, ref, viewModel, wasEditing: wasEditing);
    } else {
      final errorKey = viewModel.validateTitle();
      final message = errorKey == 'pleaseEnterTitle'
          ? l10n.pleaseEnterTitle
          : l10n.errorOccurred;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

/// 컴포저 제목 입력에 쓰는 pill(완전 둥근) 모양 데코레이션.
/// 라벨 입력도 동일한 스타일을 공유하도록 헬퍼로 추출했다.
BoxDecoration _composerPillDecoration(ThemeData theme) {
  final isDark = theme.brightness == Brightness.dark;
  return BoxDecoration(
    color: isDark ? theme.colorScheme.surfaceContainerHigh : Colors.white,
    borderRadius: BorderRadius.circular(999),
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
        blurRadius: AppConstants.spacingMedium,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
  );
}

/// 설명을 인라인으로 펼쳐 입력하는 투명·보더리스 멀티라인 필드.
class _InlineDescriptionField extends StatelessWidget {
  const _InlineDescriptionField({
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 4,
      textInputAction: TextInputAction.newline,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingSmall,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(
            alpha: AppConstants.alphaStrong,
          ),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.controller,
    required this.maxLines,
    required this.minLines,
    required this.hintText,
    required this.transparentFill,
    required this.borderless,
  });

  final TextEditingController controller;
  final int maxLines;
  final int minLines;
  final String hintText;
  final bool transparentFill;
  final bool borderless;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: TextInputAction.newline,
      textAlignVertical: TextAlignVertical.center,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: transparentFill ? Colors.transparent : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLarge,
          vertical: AppConstants.spacingXSmall,
        ),
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(
            alpha: AppConstants.alphaStrong,
          ),
        ),
        border: borderless
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
        enabledBorder: borderless
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
        focusedBorder: borderless
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
      ),
    );
  }
}

List<Widget> _buildSummaryChips(
  BuildContext context,
  AppLocalizations l10n,
  TodoFormState state,
  List<FolderEntity> folders,
) {
  final theme = Theme.of(context);
  final chips = <Widget>[];

  if (state.folderId != null) {
    for (final folder in folders) {
      if (folder.id == state.folderId) {
        chips.add(_summaryChip(theme, folder.name));
        break;
      }
    }
  }

  if (state.priority != Priority.medium) {
    chips.add(_summaryChip(theme, state.priority.getLocalizedName(context)));
  }

  if (state.dueDate != null) {
    final d = state.dueDate!;
    chips.add(_summaryChip(theme, l10n.dueDateFormat(d.year, d.month, d.day)));
  }

  if (state.labels.isNotEmpty) {
    chips.add(_summaryChip(theme, l10n.todoLabelsChip(state.labels.length)));
  }

  return chips
      .map(
        (chip) => Padding(
          padding: const EdgeInsets.only(right: AppConstants.spacingSmall),
          child: chip,
        ),
      )
      .toList();
}

Widget _summaryChip(ThemeData theme, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMedium,
      vertical: AppConstants.spacingXSmall,
    ),
    decoration: BoxDecoration(
      color: theme.colorScheme.onSurface.withValues(
        alpha: AppConstants.alphaVeryLight,
      ),
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      border: Border.all(
        color: theme.colorScheme.onSurface.withValues(
          alpha: AppConstants.alphaMediumLight,
        ),
      ),
    ),
    child: Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(
          alpha: AppConstants.alphaVeryStrong,
        ),
      ),
    ),
  );
}

List<Widget> _folderMenuItems(
  BuildContext context,
  AppLocalizations l10n,
  List<FolderEntity> folders,
  int? selectedFolderId,
  ValueChanged<int?> onChanged,
) {
  final theme = Theme.of(context);
  final menuItemStyle = DropdownStyle.of(context).menuItemStyle;

  Widget buildLabel(String name, Color dotColor, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppConstants.spacingSmall,
          height: AppConstants.spacingSmall,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
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
    );
  }

  return [
    MenuItemButton(
      style: menuItemStyle,
      onPressed: () => onChanged(null),
      child: buildLabel(
        l10n.noFolder,
        theme.colorScheme.onSurfaceVariant,
        selectedFolderId == null,
      ),
    ),
    ...folders.map((folder) {
      final isSelected = selectedFolderId == folder.id;
      return MenuItemButton(
        style: menuItemStyle,
        onPressed: () => onChanged(folder.id),
        child: buildLabel(folder.name, Color(folder.color), isSelected),
      );
    }),
  ];
}

List<Widget> _priorityMenuItems(
  BuildContext context,
  Priority selected,
  ValueChanged<Priority> onChanged,
) {
  final theme = Theme.of(context);
  final menuItemStyle = DropdownStyle.of(context).menuItemStyle;

  return Priority.values.map((priority) {
    final isSelected = selected == priority;
    return MenuItemButton(
      style: menuItemStyle,
      onPressed: () => onChanged(priority),
      child: Text(
        priority.getLocalizedName(context),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
    );
  }).toList();
}

List<Widget> _dueDateMenuItems(
  BuildContext context,
  AppLocalizations l10n,
  TodoFormViewModel viewModel,
  TodoFormState state,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final menuItemStyle = DropdownStyle.of(context).menuItemStyle;

  return [
    MenuItemButton(
      style: menuItemStyle,
      onPressed: () => viewModel.setDueDate(today),
      child: Text(l10n.dueToday),
    ),
    MenuItemButton(
      style: menuItemStyle,
      onPressed: () => viewModel.setDueDate(tomorrow),
      child: Text(l10n.dueTomorrow),
    ),
    MenuItemButton(
      style: menuItemStyle,
      onPressed: () => _pickDueDate(context, viewModel, state.dueDate),
      child: Text(l10n.pickDueDate),
    ),
    if (state.dueDate != null)
      MenuItemButton(
        style: menuItemStyle,
        onPressed: viewModel.clearDueDate,
        child: Text(l10n.clearDueDate),
      ),
  ];
}

Future<void> _pickDueDate(
  BuildContext context,
  TodoFormViewModel viewModel,
  DateTime? currentDueDate,
) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: currentDueDate ?? DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (picked != null && context.mounted) {
    viewModel.setDueDate(picked);
  }
}

/// 카드 배경색 선택 패널: "없음" + 8가지 파스텔 스와치 그리드.
class _CardColorMenuPanel extends StatelessWidget {
  const _CardColorMenuPanel({
    required this.selected,
    required this.onSelected,
    required this.onClear,
    required this.l10n,
  });

  final CardColor? selected;
  final ValueChanged<CardColor?> onSelected;
  final VoidCallback onClear;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 248,
      child: Wrap(
        spacing: AppConstants.spacingMedium,
        runSpacing: AppConstants.spacingMedium,
        children: [
          _SwatchDot(
            color: theme.colorScheme.surfaceContainerHighest,
            borderColor: theme.colorScheme.outlineVariant,
            isSelected: selected == null,
            tooltip: l10n.cardColorNone,
            noneIcon: true,
            onTap: onClear,
          ),
          ...CardColor.values.map(
            (c) => _SwatchDot(
              color: c.swatch,
              borderColor: theme.colorScheme.outlineVariant,
              isSelected: selected == c,
              onTap: () => onSelected(c),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwatchDot extends StatelessWidget {
  const _SwatchDot({
    required this.color,
    required this.borderColor,
    required this.isSelected,
    required this.onTap,
    this.tooltip,
    this.noneIcon = false,
  });

  final Color color;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;
  final String? tooltip;
  final bool noneIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const size = 40.0;

    Widget dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : borderColor,
          width: isSelected
              ? AppConstants.borderWidthThick
              : AppConstants.borderWidthThin,
        ),
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              size: AppConstants.iconSizeSmall,
              color: theme.colorScheme.onSurface,
            )
          : noneIcon
          ? Icon(
              Icons.format_color_reset_outlined,
              size: AppConstants.iconSizeSmall,
              color: theme.colorScheme.onSurface.withValues(
                alpha: AppConstants.alphaVeryStrong,
              ),
            )
          : null,
    );

    if (tooltip != null) {
      dot = Tooltip(message: tooltip!, child: dot);
    }

    return ScalePressFeedback(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: dot,
      ),
    );
  }
}
