import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  Future<List<TodoEntity>> call() async {
    return await repository.getTodos();
  }

  Stream<List<TodoEntity>> watch() {
    return repository.watchTodos();
  }

  Stream<List<TodoEntity>> watchByStatus(bool isDone) {
    return repository.watchTodosByStatus(isDone);
  }
}
