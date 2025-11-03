import '../repositories/habit_repository.dart';

class IncrementHabitLogUseCase {
  final HabitRepository repository;

  IncrementHabitLogUseCase(this.repository);

  Future<void> call(int habitId, DateTime date) async {
    await repository.incrementLog(habitId, date);
  }
}
