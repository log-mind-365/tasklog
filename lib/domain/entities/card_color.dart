/// 할 일 카드의 배경색 옵션 (파스텔 톤).
///
/// 각 색은 라이트/다크 테마별 배경색과 선택 UI용 스와치 점 색을 갖는다.
/// 색 → `Color` 변환은 presentation의 `card_color_extension.dart`에서 처리한다
/// (도메인은 Flutter에 의존하지 않도록 원시 ARGB int만 보관).
///
/// "없음"은 별도 값 없이 DB NULL(= `cardColor == null`)로 표현한다.
enum CardColor {
  rose,
  peach,
  amber,
  sage,
  mint,
  sky,
  lavender,
  mauve;

  /// DB에 저장하는 안정적인 정수 값.
  int get value {
    switch (this) {
      case CardColor.rose:
        return 0;
      case CardColor.peach:
        return 1;
      case CardColor.amber:
        return 2;
      case CardColor.sage:
        return 3;
      case CardColor.mint:
        return 4;
      case CardColor.sky:
        return 5;
      case CardColor.lavender:
        return 6;
      case CardColor.mauve:
        return 7;
    }
  }

  /// 매칭되는 값이 없거나 null이면 "없음"을 의미하는 null 반환.
  static CardColor? fromValue(int? value) {
    switch (value) {
      case 0:
        return CardColor.rose;
      case 1:
        return CardColor.peach;
      case 2:
        return CardColor.amber;
      case 3:
        return CardColor.sage;
      case 4:
        return CardColor.mint;
      case 5:
        return CardColor.sky;
      case 6:
        return CardColor.lavender;
      case 7:
        return CardColor.mauve;
      default:
        return null;
    }
  }

  /// 라이트 테마 카드 배경 ARGB (배경 `#FAFAFA`/카드 `#F0F0F0` 위에서 은은한 톤).
  int get lightBgValue {
    switch (this) {
      case CardColor.rose:
        return 0xFFFCE7EA;
      case CardColor.peach:
        return 0xFFFDEBDD;
      case CardColor.amber:
        return 0xFFFCF4D9;
      case CardColor.sage:
        return 0xFFE7F2E3;
      case CardColor.mint:
        return 0xFFDFF1EC;
      case CardColor.sky:
        return 0xFFE2EEF9;
      case CardColor.lavender:
        return 0xFFEDE7F6;
      case CardColor.mauve:
        return 0xFFF6E7F1;
    }
  }

  /// 다크 테마 카드 배경 ARGB (배경 `#1A1A1A`/카드 `#262626` 위에서 한 단계 밝은 톤).
  int get darkBgValue {
    switch (this) {
      case CardColor.rose:
        return 0xFF3A2A2E;
      case CardColor.peach:
        return 0xFF3C2F26;
      case CardColor.amber:
        return 0xFF3A3526;
      case CardColor.sage:
        return 0xFF26342A;
      case CardColor.mint:
        return 0xFF22332F;
      case CardColor.sky:
        return 0xFF24313D;
      case CardColor.lavender:
        return 0xFF302A3C;
      case CardColor.mauve:
        return 0xFF382A35;
    }
  }

  /// 선택 UI(스와치)에서 색을 구분해 보여주는 점 색 ARGB (중간 채도).
  int get swatchValue {
    switch (this) {
      case CardColor.rose:
        return 0xFFE9A1AD;
      case CardColor.peach:
        return 0xFFEEB48C;
      case CardColor.amber:
        return 0xFFE6C97A;
      case CardColor.sage:
        return 0xFF9CC79E;
      case CardColor.mint:
        return 0xFF8AC9BC;
      case CardColor.sky:
        return 0xFF93BEDD;
      case CardColor.lavender:
        return 0xFFB3A1D6;
      case CardColor.mauve:
        return 0xFFD3A1C6;
    }
  }
}
