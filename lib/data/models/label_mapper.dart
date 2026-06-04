import '../../domain/entities/label_entity.dart';
import '../datasources/local/database.dart';

extension LabelMapper on Label {
  LabelEntity toEntity() => LabelEntity(id: id, name: name);
}

extension LabelEntityMapper on LabelEntity {
  LabelsCompanion toInsertCompanion() => LabelsCompanion.insert(name: name);
}
