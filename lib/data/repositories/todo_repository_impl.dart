import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/priority.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/database.dart';
import '../models/todo_mapper.dart';

class TodoRepositoryImpl implements TodoRepository {
  final AppDatabase database;

  TodoRepositoryImpl(this.database);

  @override
  Future<List<TodoEntity>> getTodos() async {
    final todos = await database.getAllTodos();
    return todos.map((todo) => todo.toEntity()).toList();
  }

  @override
  Future<List<TodoEntity>> getTodosByCategory(int categoryId) async {
    final todos = await database.getTodosByCategory(categoryId);
    return todos.map((todo) => todo.toEntity()).toList();
  }

  @override
  Future<List<TodoEntity>> searchTodos(String query) async {
    final todos = await database.searchTodos(query);
    return todos.map((todo) => todo.toEntity()).toList();
  }

  @override
  Future<TodoEntity> getTodoById(int id) async {
    final todo = await database.getTodoById(id);
    return todo.toEntity();
  }

  @override
  Future<int> addTodo(TodoEntity todo) async {
    return await database.insertTodo(todo.toInsertCompanion());
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    await database.updateTodo(todo.toDriftModel());
  }

  @override
  Future<void> deleteTodo(int id) async {
    await database.deleteTodo(id);
  }

  @override
  Future<void> toggleTodoDone(int id) async {
    await database.toggleTodoDone(id);
  }

  @override
  Stream<List<TodoEntity>> watchTodos() {
    return database.watchAllTodos().map(
          (todos) => todos.map((todo) => todo.toEntity()).toList(),
        );
  }

  @override
  Stream<List<TodoEntity>> watchTodosByStatus(bool isDone) {
    return database.watchTodosByStatus(isDone).map(
          (todos) => todos.map((todo) => todo.toEntity()).toList(),
        );
  }

  @override
  Stream<List<TodoEntity>> watchTodosByPriority(Priority priority) {
    return database.watchTodosByPriority(priority.value).map(
          (todos) => todos.map((todo) => todo.toEntity()).toList(),
        );
  }
}
