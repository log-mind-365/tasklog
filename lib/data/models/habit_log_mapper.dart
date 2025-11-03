import 'package:drift/drift.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../datasources/local/database.dart';

extension HabitLogMapper on HabitLog {
  HabitLogEntity toEntity() {
    return HabitLogEntity(
      habitId: habitId,
      date: date,
      completedCount: completedCount,
      createdAt: createdAt,
    );
  }
}

extension HabitLogEntityMapper on HabitLogEntity {
  HabitLogsCompanion toCompanion() {
    return HabitLogsCompanion(
      habitId: Value(habitId),
      date: Value(date),
      completedCount: Value(completedCount),
      createdAt: Value(createdAt),
    );
  }

  HabitLogsCompanion toInsertCompanion() {
    return HabitLogsCompanion.insert(
      habitId: habitId,
      date: date,
      completedCount: Value(completedCount),
    );
  }

  HabitLog toDriftModel() {
    return HabitLog(
      habitId: habitId,
      date: date,
      completedCount: completedCount,
      createdAt: createdAt,
    );
  }
}
