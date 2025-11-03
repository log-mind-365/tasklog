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

// Habits table
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get goalCount => integer().withDefault(const Constant(1))(); // 하루 목표 횟수
  IntColumn get color => integer()();
  TextColumn get icon => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// HabitLogs table
class HabitLogs extends Table {
  IntColumn get habitId => integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()(); // 날짜 (시간은 00:00:00으로 정규화)
  IntColumn get completedCount => integer().withDefault(const Constant(0))(); // 완료 횟수
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {habitId, date};
}

@DriftDatabase(tables: [Categories, Todos, Habits, HabitLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

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
      },
    );
  }

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

  // Habit operations
  Future<List<Habit>> getAllHabits() => select(habits).get();
  Stream<List<Habit>> watchAllHabits() => select(habits).watch();
  Future<Habit> getHabitById(int id) =>
      (select(habits)..where((tbl) => tbl.id.equals(id))).getSingle();
  Future<int> insertHabit(HabitsCompanion habit) =>
      into(habits).insert(habit);
  Future<bool> updateHabit(Habit habit) => update(habits).replace(habit);
  Future<int> deleteHabit(int id) =>
      (delete(habits)..where((tbl) => tbl.id.equals(id))).go();

  // Habit Log operations
  Future<HabitLog?> getLogByHabitAndDate(int habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final query = select(habitLogs)
      ..where((tbl) =>
          tbl.habitId.equals(habitId) & tbl.date.equals(normalizedDate));
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  Future<List<HabitLog>> getLogsByHabitId(int habitId) =>
      (select(habitLogs)..where((tbl) => tbl.habitId.equals(habitId)))
          .get();

  Future<List<HabitLog>> getLogsByDateRange(
      int habitId, DateTime start, DateTime end) {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedEnd = DateTime(end.year, end.month, end.day);
    return (select(habitLogs)
          ..where((tbl) =>
              tbl.habitId.equals(habitId) &
              tbl.date.isBiggerOrEqualValue(normalizedStart) &
              tbl.date.isSmallerOrEqualValue(normalizedEnd)))
        .get();
  }

  Future<int> insertLog(HabitLogsCompanion log) =>
      into(habitLogs).insert(log);

  Future<bool> updateLog(HabitLog log) => update(habitLogs).replace(log);

  Stream<List<HabitLog>> watchLogsByHabitId(int habitId) =>
      (select(habitLogs)..where((tbl) => tbl.habitId.equals(habitId)))
          .watch();

  Future<void> incrementLog(int habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existingLog = await getLogByHabitAndDate(habitId, normalizedDate);

    if (existingLog == null) {
      await insertLog(HabitLogsCompanion.insert(
        habitId: habitId,
        date: normalizedDate,
        completedCount: const Value(1),
      ));
    } else {
      await updateLog(
          existingLog.copyWith(completedCount: existingLog.completedCount + 1));
    }
  }

  Future<void> decrementLog(int habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final existingLog = await getLogByHabitAndDate(habitId, normalizedDate);

    if (existingLog != null && existingLog.completedCount > 0) {
      await updateLog(
          existingLog.copyWith(completedCount: existingLog.completedCount - 1));
    }
  }
}
