import 'package:flutter_test/flutter_test.dart';
import 'package:tasklog/core/task_parsing/llm_parse_gate.dart';
import 'package:tasklog/core/task_parsing/local_natural_language_parser.dart';
import 'package:tasklog/domain/entities/folder_entity.dart';
import 'package:tasklog/domain/entities/parsed_todo_draft.dart';
import 'package:tasklog/domain/entities/priority.dart';
import 'package:tasklog/domain/repositories/natural_language_task_parser.dart';
import 'package:tasklog/domain/usecases/parse_natural_language_todo_usecase.dart';
import 'package:tasklog/domain/utils/parsed_todo_draft_mapper.dart';

void main() {
  final refMonday = DateTime(2025, 6, 2); // Monday

  group('parseNaturalLanguageLocally', () {
    test('extracts 내일 and strips from title', () {
      final r = parseNaturalLanguageLocally('보고서 제출 내일', refMonday);
      expect(r.dueDate, DateTime(2025, 6, 3));
      expect(r.title, '보고서 제출');
    });

    test('extracts @mention and #tag', () {
      final r = parseNaturalLanguageLocally('@업무 긴급 #버그 수정하기', refMonday);
      expect(r.mentions, ['업무']);
      expect(r.tags, ['버그']);
      expect(r.priority, Priority.high);
      expect(r.title, '수정하기');
    });

    test('mention allows space after @ and fullwidth hash', () {
      final r = parseNaturalLanguageLocally('@  팀A ＃일정  정리', refMonday);
      expect(r.mentions, ['팀A']);
      expect(r.tags, ['일정']);
      expect(r.title, '정리');
    });

    test('bullet lines become subTasks', () {
      final r = parseNaturalLanguageLocally('장보기\n- 우유\n- 계란', refMonday);
      expect(r.subTasks, ['우유', '계란']);
      expect(r.title, '장보기');
    });
  });

  group('shouldCallOpenAiForRemainder', () {
    test('returns false for short text without date cues', () {
      expect(
        shouldCallOpenAiForRemainder(strippedText: '짧은글', localDueDate: null),
        false,
      );
    });

    test('returns true when date cue remains and no dueDate', () {
      expect(
        shouldCallOpenAiForRemainder(
          strippedText: '다음주쯤 회의 준비하기',
          localDueDate: null,
        ),
        true,
      );
    });

    test('returns true for very long remainder', () {
      final long = '가' * 48;
      expect(
        shouldCallOpenAiForRemainder(
          strippedText: long,
          localDueDate: DateTime(2025, 6, 5),
        ),
        true,
      );
    });
  });

  group('mapDraftToFormFields', () {
    test('maps first mention to folder id', () {
      final folders = [
        const FolderEntity(id: 1, name: '업무', color: 0xff0000, order: 0),
      ];
      final fields = mapDraftToFormFields(
        draft: ParsedTodoDraft(title: '정리', mentions: ['업무'], tags: ['a']),
        folders: folders,
        existingDescription: '',
      );
      expect(fields.folderId, 1);
      expect(fields.title, '정리');
      expect(fields.description, '태그: #a');
      expect(fields.labels, ['a']);
    });
  });

  group('ParseNaturalLanguageTodoUseCase + mock LLM', () {
    test('skips LLM when gate false', () async {
      var called = 0;
      final parser = _CountingParser(() => called++);
      final uc = ParseNaturalLanguageTodoUseCase(parser);
      final d = await uc(rawInput: '간단', referenceTime: refMonday);
      expect(called, 0);
      expect(d.title, '간단');
    });

    test('calls LLM when gate true and merges', () async {
      var called = 0;
      final parser = _CountingParser(() => called++, {
        'title': '짧은제목',
        'dueDate': '2025-06-10T00:00:00.000',
        'priority': 'low',
        'mentions': <String>[],
        'tags': <String>[],
        'subTasks': <String>[],
      });
      final uc = ParseNaturalLanguageTodoUseCase(parser);
      final d = await uc(
        rawInput: '다음주쯤 무언가 길게 써야 하는 일' + '가' * 40,
        referenceTime: refMonday,
      );
      expect(called, 1);
      expect(d.dueDate, DateTime(2025, 6, 10));
      expect(d.priority, Priority.low);
    });
  });
}

class _CountingParser implements NaturalLanguageTaskParser {
  _CountingParser(this.onCall, [this.response]);

  final void Function() onCall;
  final Map<String, dynamic>? response;

  @override
  Future<Map<String, dynamic>> parseRemainder({
    required String remainder,
    required Map<String, dynamic> localSnapshot,
  }) async {
    onCall();
    return response ??
        {
          'title': remainder,
          'dueDate': null,
          'priority': null,
          'mentions': <String>[],
          'tags': <String>[],
          'subTasks': <String>[],
        };
  }
}
