import 'package:flutter/material.dart';
import '../../domain/entities/card_color.dart';

extension CardColorX on CardColor {
  /// 현재 테마 밝기에 맞는 카드 배경색.
  Color background(Brightness brightness) =>
      Color(brightness == Brightness.dark ? darkBgValue : lightBgValue);

  /// 선택 UI(스와치)에서 색을 구분해 보여주는 점 색.
  Color get swatch => Color(swatchValue);
}
