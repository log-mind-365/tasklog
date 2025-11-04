import '../entities/todo_entity.dart';
import '../entities/priority.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos();
  Future<List<TodoEntity>> getTodosByFolder(int folderId);
  Future<List<TodoEntity>> searchTodos(String query);
  Future<TodoEntity> getTodoById(int id);
  Future<int> addTodo(TodoEntity todo);
  Future<void> updateTodo(TodoEntity todo);
  Future<void> deleteTodo(int id);
  Future<void> toggleTodoDone(int id);
  Stream<List<TodoEntity>> watchTodos();
  Stream<List<TodoEntity>> watchTodosByStatus(bool isDone);
  Stream<List<TodoEntity>> watchTodosByPriority(Priority priority);
}
