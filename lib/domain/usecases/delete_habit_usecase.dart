import '../repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository repository;

  DeleteHabitUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteHabit(id);
  }
}
