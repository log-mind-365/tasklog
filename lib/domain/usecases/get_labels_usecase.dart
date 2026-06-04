import '../entities/label_entity.dart';
import '../repositories/label_repository.dart';

class GetLabelsUseCase {
  final LabelRepository repository;

  GetLabelsUseCase(this.repository);

  Stream<List<LabelEntity>> watch() {
    return repository.watchLabels();
  }
}
