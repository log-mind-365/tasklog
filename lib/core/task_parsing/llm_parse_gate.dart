/// Layer 1에서 마감일을 못 잡았는데도 날짜로 읽힐 만한 표현이 남았는지.
final RegExp _koreanDateCue = RegExp(
  r'(내일|모레|글피|어제|오늘|다음\s*주|이번\s*주|내년|올해|'
  r'월요일|화요일|수요일|목요일|금요일|토요일|일요일|'
  r'\d{1,2}\s*월\s*\d{1,2}\s*일|\d{1,2}/\d{1,2}|'
  r'오전|오후|\d{1,2}\s*시)',
  caseSensitive: false,
);

/// 비용 절감: 로컬이 충분하면 OpenAI를 부르지 않음.
bool shouldCallOpenAiForRemainder({
  required String strippedText,
  required DateTime? localDueDate,
  int minSignificantLength = 8,
}) {
  final t = strippedText.trim();
  if (t.length < minSignificantLength) return false;

  if (localDueDate == null && _koreanDateCue.hasMatch(t)) {
    return true;
  }

  // 긴 자유서술은 날짜 키워드 없어도 보완 시도 (상대적으로 드묾)
  if (t.runes.length >= 48) {
    return true;
  }

  return false;
}
