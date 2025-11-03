import 'package:freezed_annotation/freezed_annotation.dart';
import 'priority.dart';

part 'todo_entity.freezed.dart';

@freezed
class TodoEntity with _$TodoEntity {
  const factory TodoEntity({
    required int id,
    required String title,
    required String description,
    required bool isDone,
    required Priority priority,
    DateTime? dueDate,
    int? categoryId,
    required DateTime createdAt,
  }) = _TodoEntity;
}
