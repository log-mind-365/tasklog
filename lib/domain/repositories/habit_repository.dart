import '../entities/habit_entity.dart';
import '../entities/habit_log_entity.dart';

abstract class HabitRepository {
  // Habit CRUD
  Future<List<HabitEntity>> getHabits();
  Future<HabitEntity> getHabitById(int id);
  Future<int> addHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(int id);
  Stream<List<HabitEntity>> watchHabits();

  // Habit Log CRUD
  Future<HabitLogEntity?> getLogByHabitAndDate(int habitId, DateTime date);
  Future<List<HabitLogEntity>> getLogsByHabitId(int habitId);
  Future<List<HabitLogEntity>> getLogsByDateRange(int habitId, DateTime start, DateTime end);
  Future<int> addLog(HabitLogEntity log);
  Future<void> updateLog(HabitLogEntity log);
  Future<void> incrementLog(int habitId, DateTime date);
  Future<void> decrementLog(int habitId, DateTime date);
  Stream<List<HabitLogEntity>> watchLogsByHabitId(int habitId);
}
