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

// Habits table
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  TextColumn get description => text().withDefault(const Constant(''))();

  IntColumn get goalCount =>
      integer().withDefault(const Constant(1))(); // 하루 목표 횟수
  IntColumn get color => integer()();

  TextColumn get icon => text().withLength(min: 1, max: 50)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// HabitLogs table
class HabitLogs extends Table {
  IntColumn get habitId =>
      integer().references(Habits, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get date => dateTime()(); // 날짜 (시간은 00:00:00으로 정규화)
  IntColumn get completedCount =>
      integer().withDefault(const Constant(0))(); // 완료 횟수
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {habitId, date};
}

@DriftDatabase(tables: [Folders, Todos, Habits, HabitLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add Habits and HabitLogs tables in version 2
          await m.createTable(habits);
          await m.createTable(habitLogs);
        }
        if (from < 3) {
          // Version 3: Rename Categories to Folders and add order column
          // Create new folders table
          await m.createTable(folders);

          // Migrate data from categories to folders
          await customStatement('''
            INSERT INTO folders (id, name, color, "order")
            SELECT id, name, color, 0 FROM categories
          ''');

          // Rename categoryId column to folderId in todos table
          // Note: Drift doesn't have direct column rename, so we keep the data as is
          // The column is already named folderId in the new schema

          // Drop old categories table
          await m.deleteTable('categories');
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

  // Habit operations
  Future<List<Habit>> getAllHabits() => select(habits).get();

  Stream<List<Habit>> watchAllHabits() => select(habits).watch();

  Future<Habit> getHabitById(int id) =>
      (select(habits)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<int> insertHabit(HabitsCompanion habit) => into(habits).insert(habit);

  Future<bool> updateHabit(Habit habit) => update(habits).replace(habit);

  Future<int> deleteHabit(int id) =>
      (delete(habits)..where((tbl) => tbl.id.equals(id))).go();

  // Habit Log operations
  Future<HabitLog?> getLogByHabitAndDate(int habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final query = select(habitLogs)
      ..where(
        (tbl) => tbl.habitId.equals(habitId) & tbl.date.equals(normalizedDate),
      );
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  Future<List<HabitLog>> getLogsByHabitId(int habitId) =>
      (select(habitLogs)..where((tbl) => tbl.habitId.equals(habitId))).get();

  Future<List<HabitLog>> getLogsByDateRange(
    int habitId,
    DateTime start,
    DateTime end,
  ) {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    return (select(habitLogs)..where(
          (tbl) =>
              tbl.habitId.equals(habitId) &
              tbl.date.isBiggerOrEqualValue(normalizedStart) &
              tbl.date.isSmallerOrEqualValue(normalizedEnd),
        ))
        .get();
  }

  Future<int> insertLog(HabitLogsCompanion log) => into(habitLogs).insert(log);

  Future<bool> updateLog(HabitLog log) => update(habitLogs).replace(log);

  Stream<List<HabitLog>> watchLogsByHabitId(int habitId) =>
      (select(habitLogs)..where((tbl) => tbl.habitId.equals(habitId))).watch();

  Future<void> incrementLog(int habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existingLog = await getLogByHabitAndDate(habitId, normalizedDate);

    if (existingLog == null) {
      await insertLog(
        HabitLogsCompanion.insert(
          habitId: habitId,
          date: normalizedDate,
          completedCount: const Value(1),
        ),
      );
    } else {
      await updateLog(
        existingLog.copyWith(completedCount: existingLog.completedCount + 1),
      );
    }
  }

  Future<void> decrementLog(int habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existingLog = await getLogByHabitAndDate(habitId, normalizedDate);

    if (existingLog != null && existingLog.completedCount > 0) {
      await updateLog(
        existingLog.copyWith(completedCount: existingLog.completedCount - 1),
      );
    }
  }
}
