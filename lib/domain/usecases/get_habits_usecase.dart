import '../entities/habit_entity.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<List<HabitEntity>> call() async {
    return await repository.getHabits();
  }

  Stream<List<HabitEntity>> watch() {
    return repository.watchHabits();
  }
}
