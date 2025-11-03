import '../repositories/todo_repository.dart';

class ToggleTodoDoneUseCase {
  final TodoRepository repository;

  ToggleTodoDoneUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.toggleTodoDone(id);
  }
}
