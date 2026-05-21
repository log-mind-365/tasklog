import 'dart:convert';

import '../../../domain/repositories/natural_language_task_parser.dart';
import 'openai_chat_client.dart';

/// [NaturalLanguageTaskParser]의 OpenAI 구현.
class OpenAiNaturalLanguageTaskParser implements NaturalLanguageTaskParser {
  OpenAiNaturalLanguageTaskParser({required OpenAiChatClient client})
    : _client = client;

  final OpenAiChatClient _client;

  @override
  Future<Map<String, dynamic>> parseRemainder({
    required String remainder,
    required Map<String, dynamic> localSnapshot,
  }) async {
    final payload = jsonEncode({
      'remainder': remainder,
      'local': localSnapshot,
    });

    return _client.completeJsonObject(
      messages: [
        {'role': 'system', 'content': _systemPrompt},
        {'role': 'user', 'content': payload},
      ],
    );
  }
}

const String _systemPrompt = '''
당신은 한국어 할 일 문장을 구조화하는 도우미입니다.
입력 JSON의 "remainder"는 이미 @멘션·#태그·우선순위 키워드·일부 날짜 표현이 제거된 뒤 남은 텍스트입니다.
"local"에는 앱에서 로컬로 추출한 값이 있습니다.

규칙:
1) local에 이미 있는 값(dueDate, priority, mentions, tags, subTasks, title)은 **절대 덮어쓰지 말고** 그대로 유지합니다. 비어 있거나 null인 항목만 remainder에서 보완합니다.
2) 응답은 JSON 객체 하나만 출력합니다. 마크다운·설명 문장 금지.
3) 키: title(문자열), dueDate(ISO8601 문자열 또는 null), mentions(문자열 배열), tags(문자열 배열), priority("high"|"medium"|"low"|null), subTasks(문자열 배열).
4) title은 할 일 제목 한 줄로 간결하게. remainder가 비유어만 있으면 local.title을 그대로 쓰세요.
''';
