import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository repository;

  AddHabitUseCase(this.repository);

  Future<int> call(HabitEntity habit) async {
    return await repository.addHabit(habit);
  }
}
