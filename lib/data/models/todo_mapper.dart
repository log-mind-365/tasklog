import 'dart:convert';

import 'package:drift/drift.dart';
import '../../domain/entities/card_color.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/entities/priority.dart';
import '../datasources/local/database.dart';

List<String> _labelsFromJson(String? raw) {
  if (raw == null || raw.isEmpty) return const [];
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
  } on FormatException {
    return const [];
  }
}

String _labelsToJson(List<String> labels) => jsonEncode(labels);

extension TodoMapper on Todo {
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      isDone: isDone,
      priority: Priority.fromValue(priority),
      dueDate: dueDate,
      folderId: folderId,
      labels: _labelsFromJson(labelsJson),
      cardColor: CardColor.fromValue(cardColor),
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
      folderId: Value(folderId),
      labelsJson: Value(_labelsToJson(labels)),
      cardColor: Value(cardColor?.value),
      createdAt: Value(createdAt),
    );
  }

  TodosCompanion toInsertCompanion() {
    return TodosCompanion.insert(
      title: title,
      description: description.isEmpty
          ? const Value.absent()
          : Value(description),
      isDone: Value(isDone),
      priority: Value(priority.value),
      dueDate: Value(dueDate),
      folderId: Value(folderId),
      labelsJson: Value(_labelsToJson(labels)),
      cardColor: Value(cardColor?.value),
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
      folderId: folderId,
      labelsJson: _labelsToJson(labels),
      cardColor: cardColor?.value,
      createdAt: createdAt,
    );
  }
}
