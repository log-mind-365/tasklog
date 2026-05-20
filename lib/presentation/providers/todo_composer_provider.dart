import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/todo_entity.dart';

part 'todo_composer_provider.g.dart';

/// 하단 컴포저에서 수정 중인 할 일
@riverpod
class EditingTodo extends _$EditingTodo {
  @override
  TodoEntity? build() => null;

  void startEdit(TodoEntity todo) {
    state = todo;
  }

  void clear() {
    state = null;
  }
}
