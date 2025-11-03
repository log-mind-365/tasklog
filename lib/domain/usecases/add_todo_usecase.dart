import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<int> call(TodoEntity todo) async {
    return await repository.addTodo(todo);
  }
}
