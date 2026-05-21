import 'package:flutter_test/flutter_test.dart';
import 'package:tasklog/core/utils/todo_card_description_parser.dart';

void main() {
  test('parses structured blocks and body', () {
    const raw = '''
메모 한 줄

@멘션: 김, 이
태그: #버그 #급함
- 자료 정리
- 메일 보내기
''';
    final p = parseTodoCardDescription(raw);
    expect(p.body, '메모 한 줄');
    expect(p.mentionNames, ['김', '이']);
    expect(p.tagLabels, ['버그', '급함']);
    expect(p.subTasks, ['자료 정리', '메일 보내기']);
    expect(p.hasStructuredContent, true);
  });

  test('plain text becomes body only', () {
    final p = parseTodoCardDescription('그냥 설명만');
    expect(p.body, '그냥 설명만');
    expect(p.hasStructuredContent, false);
  });
}
