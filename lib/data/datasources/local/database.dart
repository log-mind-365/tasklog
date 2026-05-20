import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Folders table (renamed from Categories)
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  IntColumn get color => integer()();

  IntColumn get order => integer().withDefault(const Constant(0))(); // 정렬 순서
}

// Todos table
class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  TextColumn get description => text().withDefault(const Constant(''))();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  IntColumn get priority => integer().withDefault(const Constant(1))();

  DateTimeColumn get dueDate => dateTime().nullable()();

  IntColumn get folderId => integer().nullable().references(
    Folders,
    #id,
    onDelete: KeyAction.setNull,
  )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Folders, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          await m.createTable(folders);

          await customStatement('''
            INSERT INTO folders (id, name, color, "order")
            SELECT id, name, color, 0 FROM categories
          ''');

          await m.deleteTable('categories');
        }
        if (from < 4) {
          await customStatement('DROP TABLE IF EXISTS habit_logs');
          await customStatement('DROP TABLE IF EXISTS habits');
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tasklog_db');
  }

  // Folder operations
  Future<List<Folder>> getAllFolders() => (select(
    folders,
  )..orderBy([(t) => OrderingTerm(expression: t.order)])).get();

  Stream<List<Folder>> watchAllFolders() => (select(
    folders,
  )..orderBy([(t) => OrderingTerm(expression: t.order)])).watch();

  Future<Folder> getFolderById(int id) =>
      (select(folders)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> insertFolder(FoldersCompanion folder) =>
      into(folders).insert(folder);

  Future<bool> updateFolder(Folder folder) => update(folders).replace(folder);

  Future<int> deleteFolder(int id) =>
      (delete(folders)..where((tbl) => tbl.id.equals(id))).go();

  // Todo operations
  Future<List<Todo>> getAllTodos() => select(todos).get();

  Stream<List<Todo>> watchAllTodos() => select(todos).watch();

  Stream<List<Todo>> watchTodosByStatus(bool isDone) =>
      (select(todos)..where((tbl) => tbl.isDone.equals(isDone))).watch();

  Stream<List<Todo>> watchTodosByPriority(int priority) =>
      (select(todos)..where((tbl) => tbl.priority.equals(priority))).watch();

  Future<List<Todo>> getTodosByFolder(int folderId) =>
      (select(todos)..where((tbl) => tbl.folderId.equals(folderId))).get();

  Stream<List<Todo>> watchTodosByFolder(int folderId) =>
      (select(todos)..where((tbl) => tbl.folderId.equals(folderId))).watch();

  Future<List<Todo>> searchTodos(String query) =>
      (select(todos)..where(
            (tbl) =>
                tbl.title.like('%$query%') | tbl.description.like('%$query%'),
          ))
          .get();

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
