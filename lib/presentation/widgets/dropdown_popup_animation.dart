import 'package:flutter/material.dart';

/// 헤더 `PopupMenuButton`과 컴포저 `MenuAnchor` 메뉴 등에서 공유하는 페이드 타이밍.
abstract final class DropdownPopupAnimation {
  static const Duration duration = Duration(milliseconds: 220);

  /// `PopupMenuButton.popUpAnimationStyle` (열림·닫힘 동일 스펙).
  static AnimationStyle get popUpStyle => AnimationStyle(
        duration: duration,
        reverseDuration: duration,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
}
