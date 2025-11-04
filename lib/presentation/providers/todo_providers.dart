import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/todo_entity.dart';
import 'providers.dart';

part 'todo_providers.g.dart';

@riverpod
Stream<List<TodoEntity>> todosStream(Ref ref) {
  final useCase = ref.watch(getTodosUseCaseProvider);
  return useCase.watch();
}

@riverpod
Stream<List<TodoEntity>> incompleteTodosStream(Ref ref) {
  final useCase = ref.watch(getTodosUseCaseProvider);
  return useCase.watchByStatus(false);
}

@riverpod
Stream<List<TodoEntity>> completedTodosStream(Ref ref) {
  final useCase = ref.watch(getTodosUseCaseProvider);
  return useCase.watchByStatus(true);
}

// 폴더별 Todo 스트림 (null은 폴더가 없는 Todo)
@riverpod
Stream<List<TodoEntity>> todosByFolder(Ref ref, int? folderId) {
  final todos = ref.watch(todosStreamProvider);
  return todos.when(
    data: (list) {
      if (folderId == null) {
        return Stream.value(list.where((todo) => todo.folderId == null).toList());
      }
      return Stream.value(list.where((todo) => todo.folderId == folderId).toList());
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
}

// 현재 선택된 폴더 페이지 인덱스
final selectedFolderPageIndexProvider = StateProvider<int>((ref) => 0);
