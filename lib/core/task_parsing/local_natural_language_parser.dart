import '../../domain/entities/priority.dart';
import 'korean_date_heuristics.dart';
import 'regex_lexicon_layer.dart';

/// Layer 1 + Layer 2 결과 (OpenAI 병합 전).
class LocalNaturalLanguageParseResult {
  const LocalNaturalLanguageParseResult({
    required this.title,
    required this.dueDate,
    required this.mentions,
    required this.tags,
    required this.priority,
    required this.subTasks,
  });

  final String title;
  final DateTime? dueDate;
  final List<String> mentions;
  final List<String> tags;
  final Priority? priority;
  final List<String> subTasks;
}

/// 날짜 휴리스틱 → 정규식 사전 순으로 파싱한다.
LocalNaturalLanguageParseResult parseNaturalLanguageLocally(
  String raw,
  DateTime reference,
) {
  final afterDates = extractKoreanDates(raw.trim(), reference);
  final lex = applyRegexLexicon(afterDates.text);

  return LocalNaturalLanguageParseResult(
    title: lex.text,
    dueDate: afterDates.dueDate,
    mentions: lex.mentions,
    tags: lex.tags,
    priority: lex.priority,
    subTasks: lex.subTasks,
  );
}
