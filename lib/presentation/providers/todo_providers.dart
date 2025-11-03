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
