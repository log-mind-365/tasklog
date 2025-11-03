import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteTodo(id);
  }
}
