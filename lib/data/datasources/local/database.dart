import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Categories table
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  IntColumn get color => integer()();
}

// Todos table
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get priority => integer().withDefault(const Constant(1))();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Categories, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tasklog_db');
  }

  // Category operations
  Future<List<Category>> getAllCategories() => select(categories).get();
  Stream<List<Category>> watchAllCategories() => select(categories).watch();
  Future<Category> getCategoryById(int id) =>
      (select(categories)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<int> insertCategory(CategoriesCompanion category) =>
      into(categories).insert(category);
  Future<bool> updateCategory(Category category) =>
      update(categories).replace(category);
  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((tbl) => tbl.id.equals(id))).go();

  // Todo operations
  Future<List<Todo>> getAllTodos() => select(todos).get();
  Stream<List<Todo>> watchAllTodos() => select(todos).watch();
  Stream<List<Todo>> watchTodosByStatus(bool isDone) =>
      (select(todos)..where((tbl) => tbl.isDone.equals(isDone))).watch();
  Stream<List<Todo>> watchTodosByPriority(int priority) =>
      (select(todos)..where((tbl) => tbl.priority.equals(priority))).watch();
  Future<List<Todo>> getTodosByCategory(int categoryId) =>
      (select(todos)..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  Future<List<Todo>> searchTodos(String query) =>
      (select(todos)..where((tbl) => tbl.title.like('%$query%') | tbl.description.like('%$query%'))).get();
  Future<Todo> getTodoById(int id) =>
      (select(todos)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<int> insertTodo(TodosCompanion todo) => into(todos).insert(todo);
  Future<bool> updateTodo(Todo todo) => update(todos).replace(todo);
  Future<int> deleteTodo(int id) =>
      (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
  Future<void> toggleTodoDone(int id) async {
    final todo = await getTodoById(id);
    await updateTodo(todo.copyWith(isDone: !todo.isDone));
  }
}
