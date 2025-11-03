import '../entities/habit_log_entity.dart';
import '../repositories/habit_repository.dart';

class GetHabitLogsUseCase {
  final HabitRepository repository;

  GetHabitLogsUseCase(this.repository);

  Future<List<HabitLogEntity>> call(int habitId) async {
    return await repository.getLogsByHabitId(habitId);
  }

  Future<List<HabitLogEntity>> getByDateRange(
    int habitId,
    DateTime start,
    DateTime end,
  ) async {
    return await repository.getLogsByDateRange(habitId, start, end);
  }

  Stream<List<HabitLogEntity>> watch(int habitId) {
    return repository.watchLogsByHabitId(habitId);
  }
}
