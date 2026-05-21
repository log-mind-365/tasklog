import 'package:freezed_annotation/freezed_annotation.dart';

import 'priority.dart';

part 'parsed_todo_draft.freezed.dart';

/// 자연어 파싱 결과 (DB 스키마와 독립적인 초안).
@freezed
class ParsedTodoDraft with _$ParsedTodoDraft {
  const factory ParsedTodoDraft({
    required String title,
    DateTime? dueDate,
    @Default(<String>[]) List<String> mentions,
    @Default(<String>[]) List<String> tags,
    Priority? priority,
    @Default(<String>[]) List<String> subTasks,
  }) = _ParsedTodoDraft;
}
