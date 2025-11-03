import '../repositories/habit_repository.dart';

class DecrementHabitLogUseCase {
  final HabitRepository repository;

  DecrementHabitLogUseCase(this.repository);

  Future<void> call(int habitId, DateTime date) async {
    await repository.decrementLog(habitId, date);
  }
}
