import 'package:flutter/material.dart';

/// 포인터 눌림 시 짧게 스케일 다운했다가 떼면 복귀하는 시각 피드백.
///
/// 자식 위젯의 히트 테스트·제스처는 그대로 동작합니다.
class ScalePressFeedback extends StatefulWidget {
  const ScalePressFeedback({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressedScale = 0.94,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeInOut,
  });

  final Widget child;
  final bool enabled;
  final double pressedScale;
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;

  @override
  State<ScalePressFeedback> createState() => _ScalePressFeedbackState();
}

class _ScalePressFeedbackState extends State<ScalePressFeedback> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled) return;
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: _pressed ? widget.curve : widget.reverseCurve,
        child: widget.child,
      ),
    );
  }
}
