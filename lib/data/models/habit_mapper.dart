import 'package:drift/drift.dart';
import '../../domain/entities/habit_entity.dart';
import '../datasources/local/database.dart';

extension HabitMapper on Habit {
  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      name: name,
      description: description,
      goalCount: goalCount,
      color: color,
      icon: icon,
      createdAt: createdAt,
    );
  }
}

extension HabitEntityMapper on HabitEntity {
  HabitsCompanion toCompanion() {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      goalCount: Value(goalCount),
      color: Value(color),
      icon: Value(icon),
      createdAt: Value(createdAt),
    );
  }

  HabitsCompanion toInsertCompanion() {
    return HabitsCompanion.insert(
      name: name,
      color: color,
      icon: icon,
      description: description.isEmpty ? const Value.absent() : Value(description),
      goalCount: Value(goalCount),
    );
  }

  Habit toDriftModel() {
    return Habit(
      id: id,
      name: name,
      description: description,
      goalCount: goalCount,
      color: color,
      icon: icon,
      createdAt: createdAt,
    );
  }
}
