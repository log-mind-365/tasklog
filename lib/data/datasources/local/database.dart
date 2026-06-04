import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/todo_card_description_parser.dart';

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

  /// JSON 배열 문자열, 예: `["업무","긴급"]`
  TextColumn get labelsJson => text().withDefault(const Constant('[]'))();

  /// 카드 배경색 (`CardColor.value`, null = 없음)
  IntColumn get cardColor => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Labels (tag) catalog table — 재사용 가능한 라벨 카탈로그
class Labels extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name =>
      text().withLength(min: 1, max: AppConstants.maxTodoLabelCharacterLength)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Folders, Todos, Labels])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

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
        if (from < 5) {
          await m.addColumn(todos, todos.labelsJson);
          final rows = await customSelect(
            'SELECT id, description FROM todos',
            readsFrom: {todos},
          ).get();
          for (final row in rows) {
            final id = row.read<int>('id');
            final description = row.read<String>('description');
            final tags = parseTodoCardDescription(description).tagLabels;
            if (tags.isNotEmpty) {
              await customStatement(
                'UPDATE todos SET labels_json = ? WHERE id = ?',
                [jsonEncode(tags), id],
              );
            }
          }
        }
        if (from < 6) {
          // 개발 중 스키마 버전이 어긋나 컬럼이 이미 있을 수 있으므로
          // 중복 추가(SqliteException: duplicate column)를 방지한다.
          final columns = await customSelect("PRAGMA table_info('todos')").get();
          final hasCardColor = columns.any(
            (row) => row.read<String>('name') == 'card_color',
          );
          if (!hasCardColor) {
            await m.addColumn(todos, todos.cardColor);
          }
        }
        if (from < 7) {
          await m.createTable(labels);
          // 기존 할 일의 labelsJson에 있던 이름들을 카탈로그로 백필.
          final rows = await customSelect(
            'SELECT labels_json FROM todos',
            readsFrom: {todos},
          ).get();
          final seen = <String>{};
          for (final row in rows) {
            final raw = row.read<String?>('labels_json');
            if (raw == null || raw.isEmpty) continue;
            try {
              final decoded = jsonDecode(raw);
              if (decoded is! List) continue;
              for (final e in decoded) {
                final name = e.toString().trim();
                if (name.isEmpty) continue;
                final key = name.toLowerCase();
                if (seen.contains(key)) continue;
                seen.add(key);
                await into(labels).insert(LabelsCompanion.insert(name: name));
              }
            } on FormatException {
              // 손상된 JSON은 건너뛴다.
            }
          }
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

  // Label (tag) catalog operations
  Stream<List<Label>> watchAllLabels() => (select(
    labels,
  )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();

  Future<int> insertLabel(LabelsCompanion label) => into(labels).insert(label);

  Future<int> deleteLabel(int id) =>
      (delete(labels)..where((tbl) => tbl.id.equals(id))).go();

  Future<Label?> getLabelByName(String name) =>
      (select(labels)
            ..where((tbl) => tbl.name.lower().equals(name.toLowerCase())))
          .getSingleOrNull();

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
                tbl.title.like('%$query%') |
                tbl.description.like('%$query%') |
                tbl.labelsJson.like('%$query%'),
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
