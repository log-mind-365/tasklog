import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../widgets/dropdown_popup_animation.dart';
import '../../../widgets/dropdown_style.dart';
import '../../../widgets/scale_press_feedback.dart';

/// 컴포저 옵션 아이콘 + MenuAnchor 드롭다운
class TodoComposerOptionButton extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final String tooltip;
  final List<Widget> menuChildren;

  /// 지정되면 아이콘 대신 이 색의 원형을 표시한다 (예: 카드 색 선택 버튼).
  final Color? swatchColor;

  /// 지정되면 탭 시 드롭다운 메뉴 대신 이 콜백을 호출한다 (예: 바텀시트 열기).
  /// 이 경우 [menuChildren]은 비워 둔다.
  final VoidCallback? onTap;

  const TodoComposerOptionButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.tooltip,
    required this.menuChildren,
    this.swatchColor,
    this.onTap,
  });

  @override
  State<TodoComposerOptionButton> createState() =>
      _TodoComposerOptionButtonState();
}

class _TodoComposerOptionButtonState extends State<TodoComposerOptionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DropdownPopupAnimation.duration,
      reverseDuration: DropdownPopupAnimation.duration,
    );
    _curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dropdownStyle = DropdownStyle.of(context);

    final animatedMenuChildren = widget.menuChildren.map((child) {
      return FadeTransition(opacity: _curve, child: child);
    }).toList();

    return MenuAnchor(
      onOpen: () => _controller.forward(from: 0),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(dropdownStyle.backgroundColor),
        surfaceTintColor: WidgetStatePropertyAll(
          dropdownStyle.surfaceTintColor,
        ),
        shadowColor: WidgetStatePropertyAll(dropdownStyle.shadowColor),
        elevation: WidgetStatePropertyAll(dropdownStyle.elevation),
        shape: WidgetStatePropertyAll(dropdownStyle.shape),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
        ),
      ),
      builder: (context, controller, child) {
        return ScalePressFeedback(
          child: IconButton(
            tooltip: widget.tooltip,
            style: IconButton.styleFrom(
              minimumSize: const Size(40, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.zero,
            ),
            iconSize: AppConstants.iconSizeMedium,
            onPressed: () {
              if (widget.onTap != null) {
                widget.onTap!();
                return;
              }
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: widget.swatchColor != null
                ? Container(
                    width: AppConstants.iconSizeMedium,
                    height: AppConstants.iconSizeMedium,
                    decoration: BoxDecoration(
                      color: widget.swatchColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: AppConstants.alphaMediumLight,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    widget.icon,
                    color: widget.isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(
                            alpha: AppConstants.alphaVeryStrong,
                          ),
                  ),
          ),
        );
      },
      menuChildren: animatedMenuChildren,
    );
  }
}
