import '../../domain/entities/habit_entity.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/local/database.dart';
import '../models/habit_log_mapper.dart';
import '../models/habit_mapper.dart';

class HabitRepositoryImpl implements HabitRepository {
  final AppDatabase database;

  HabitRepositoryImpl(this.database);

  @override
  Future<List<HabitEntity>> getHabits() async {
    final habits = await database.getAllHabits();
    return habits.map((habit) => habit.toEntity()).toList();
  }

  @override
  Future<HabitEntity> getHabitById(int id) async {
    final habit = await database.getHabitById(id);
    return habit.toEntity();
  }

  @override
  Future<int> addHabit(HabitEntity habit) async {
    return await database.insertHabit(habit.toInsertCompanion());
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    await database.updateHabit(habit.toDriftModel());
  }

  @override
  Future<void> deleteHabit(int id) async {
    await database.deleteHabit(id);
  }

  @override
  Stream<List<HabitEntity>> watchHabits() {
    return database
        .watchAllHabits()
        .map((habits) => habits.map((habit) => habit.toEntity()).toList());
  }

  @override
  Future<HabitLogEntity?> getLogByHabitAndDate(
      int habitId, DateTime date) async {
    final log = await database.getLogByHabitAndDate(habitId, date);
    return log?.toEntity();
  }

  @override
  Future<List<HabitLogEntity>> getLogsByHabitId(int habitId) async {
    final logs = await database.getLogsByHabitId(habitId);
    return logs.map((log) => log.toEntity()).toList();
  }

  @override
  Future<List<HabitLogEntity>> getLogsByDateRange(
      int habitId, DateTime start, DateTime end) async {
    final logs = await database.getLogsByDateRange(habitId, start, end);
    return logs.map((log) => log.toEntity()).toList();
  }

  @override
  Future<int> addLog(HabitLogEntity log) async {
    return await database.insertLog(log.toInsertCompanion());
  }

  @override
  Future<void> updateLog(HabitLogEntity log) async {
    await database.updateLog(log.toDriftModel());
  }

  @override
  Future<void> incrementLog(int habitId, DateTime date) async {
    await database.incrementLog(habitId, date);
  }

  @override
  Future<void> decrementLog(int habitId, DateTime date) async {
    await database.decrementLog(habitId, date);
  }

  @override
  Stream<List<HabitLogEntity>> watchLogsByHabitId(int habitId) {
    return database.watchLogsByHabitId(habitId).map(
        (logs) => logs.map((log) => log.toEntity()).toList());
  }
}
