import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class SearchTodosUseCase {
  final TodoRepository repository;

  SearchTodosUseCase(this.repository);

  Future<List<TodoEntity>> call(String query) async {
    return await repository.searchTodos(query);
  }
}
