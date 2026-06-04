import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/label_entity.dart';
import '../../../../domain/entities/todo_entity.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../providers/label_providers.dart';
import '../../../providers/providers.dart';
import '../todo_form_view_model.dart';

/// 라벨 카탈로그에서 현재 할 일의 라벨을 선택/추가/삭제하는 바텀시트.
/// 에디터를 연 [TodoFormViewModel] 인스턴스를 그대로 공유한다.
class LabelSelectBottomSheet extends ConsumerStatefulWidget {
  const LabelSelectBottomSheet({
    super.key,
    required this.initialTodo,
    required this.defaultFolderId,
    required this.scrollController,
  });

  final TodoEntity? initialTodo;
  final int? defaultFolderId;
  final ScrollController scrollController;

  static Future<void> show(
    BuildContext context, {
    required TodoEntity? initialTodo,
    required int? defaultFolderId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (context, scrollController) => LabelSelectBottomSheet(
          initialTodo: initialTodo,
          defaultFolderId: defaultFolderId,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  ConsumerState<LabelSelectBottomSheet> createState() =>
      _LabelSelectBottomSheetState();
}

class _LabelSelectBottomSheetState
    extends ConsumerState<LabelSelectBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  TodoFormViewModelProvider get _provider =>
      todoFormViewModelProvider(widget.initialTodo, widget.defaultFolderId);

  Future<void> _addLabel() async {
    final label = await ref.read(addLabelUseCaseProvider)(_controller.text);
    if (label == null) return;
    ref.read(_provider.notifier).addLabel(label.name);
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _toggle(String name) {
    final vm = ref.read(_provider.notifier);
    final labels = ref.read(_provider).labels;
    final existing = labels
        .where((l) => l.toLowerCase() == name.toLowerCase())
        .toList();
    if (existing.isNotEmpty) {
      vm.removeLabel(existing.first);
    } else {
      vm.addLabel(name);
    }
  }

  Future<void> _deleteLabel(LabelEntity label) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label.name),
        content: Text(l10n.labelDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(deleteLabelUseCaseProvider)(label.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(_provider.select((s) => s.labels));
    final labelsAsync = ref.watch(labelsStreamProvider);

    bool isSelected(String name) =>
        selected.any((l) => l.toLowerCase() == name.toLowerCase());

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppConstants.spacingSmall),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: AppConstants.alphaMediumLight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusXSmall),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingLarge,
              AppConstants.spacingSmall,
              AppConstants.spacingSmall,
              AppConstants.spacingXSmall,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.labelSheetTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: l10n.cancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // 선택된 라벨 칩을 순서대로 배치하고, 남은 빈 공간에 투명 인풋을 흘린다.
          // 빈 공간을 탭하면 인풋에 포커스, 줄이 꽉 차면 인풋이 다음 줄로 넘어간다.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _focusNode.requestFocus,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppConstants.spacingLarge,
                AppConstants.spacingXSmall,
                AppConstants.spacingLarge,
                AppConstants.spacingMedium,
              ),
              child: Wrap(
                spacing: AppConstants.spacingSmall,
                runSpacing: AppConstants.spacingSmall,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ...selected.map(
                    (name) => InputChip(
                      label: Text(name),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onDeleted: () => _toggle(name),
                    ),
                  ),
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 80),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLength: AppConstants.maxTodoLabelCharacterLength,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addLabel(),
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: selected.isEmpty ? l10n.labelAddHint : null,
                          counterText: '',
                          isDense: true,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: AppConstants.alphaStrong,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: labelsAsync.when(
              data: (labels) {
                if (labels.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingXXLarge),
                      child: Text(
                        l10n.labelSheetEmpty,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: AppConstants.alphaStrong,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: widget.scrollController,
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.spacingLarge,
                  ),
                  itemCount: labels.length,
                  itemBuilder: (context, index) {
                    final label = labels[index];
                    final active = isSelected(label.name);
                    return ListTile(
                      onTap: () => _toggle(label.name),
                      leading: Icon(
                        active
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: active
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: AppConstants.alphaStrong,
                              ),
                      ),
                      title: Text(label.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: l10n.labelDeleteTooltip,
                        onPressed: () => _deleteLabel(label),
                      ),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Text(
                    l10n.errorOccurred,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
