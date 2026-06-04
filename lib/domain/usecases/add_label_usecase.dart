import '../../core/constants/app_constants.dart';
import '../entities/label_entity.dart';
import '../repositories/label_repository.dart';

class AddLabelUseCase {
  final LabelRepository repository;

  AddLabelUseCase(this.repository);

  /// 유효하면 추가된(또는 기존) 라벨을 반환, 유효하지 않으면 null.
  Future<LabelEntity?> call(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) return null;
    if (name.length > AppConstants.maxTodoLabelCharacterLength) return null;
    return repository.addLabel(name);
  }
}
