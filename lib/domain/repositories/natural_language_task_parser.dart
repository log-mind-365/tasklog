/// Layer 3: remainder만 구조화 (OpenAI 등 원격 구현체).
abstract class NaturalLanguageTaskParser {
  /// [remainder]와 이미 로컬에서 추출된 값(JSON 직렬화 가능한 맵)을 바탕으로 보완 필드를 JSON 형태로 반환.
  /// 실패 시 예외를 던질 수 있음 — 호출부에서 로컬 결과만 사용.
  Future<Map<String, dynamic>> parseRemainder({
    required String remainder,
    required Map<String, dynamic> localSnapshot,
  });
}
