import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<void> call(TodoEntity todo) async {
    await repository.updateTodo(todo);
  }
}
