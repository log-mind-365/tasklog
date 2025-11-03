import 'package:drift/drift.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/priority.dart';
import '../datasources/local/database.dart';

extension TodoMapper on Todo {
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      isDone: isDone,
      priority: Priority.fromValue(priority),
      dueDate: dueDate,
      categoryId: categoryId,
      createdAt: createdAt,
    );
  }
}

extension TodoEntityMapper on TodoEntity {
  TodosCompanion toCompanion() {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      isDone: Value(isDone),
      priority: Value(priority.value),
      dueDate: Value(dueDate),
      categoryId: Value(categoryId),
      createdAt: Value(createdAt),
    );
  }

  TodosCompanion toInsertCompanion() {
    return TodosCompanion.insert(
      title: title,
      description: description.isEmpty ? const Value.absent() : Value(description),
      isDone: Value(isDone),
      priority: Value(priority.value),
      dueDate: Value(dueDate),
      categoryId: Value(categoryId),
    );
  }

  Todo toDriftModel() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isDone: isDone,
      priority: priority.value,
      dueDate: dueDate,
      categoryId: categoryId,
      createdAt: createdAt,
    );
  }
}
