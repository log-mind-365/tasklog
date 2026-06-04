import '../repositories/label_repository.dart';

class DeleteLabelUseCase {
  final LabelRepository repository;

  DeleteLabelUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteLabel(id);
  }
}
