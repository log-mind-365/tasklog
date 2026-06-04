import '../entities/label_entity.dart';

abstract class LabelRepository {
  Stream<List<LabelEntity>> watchLabels();

  /// 대소문자 무시 매칭이 있으면 기존 라벨을 반환, 없으면 새로 추가 후 반환.
  Future<LabelEntity> addLabel(String name);

  Future<void> deleteLabel(int id);

  Future<LabelEntity?> getLabelByName(String name);
}
