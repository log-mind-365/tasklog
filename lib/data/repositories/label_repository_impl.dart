import '../../domain/entities/label_entity.dart';
import '../../domain/repositories/label_repository.dart';
import '../datasources/local/database.dart';
import '../models/label_mapper.dart';

class LabelRepositoryImpl implements LabelRepository {
  final AppDatabase database;

  LabelRepositoryImpl(this.database);

  @override
  Stream<List<LabelEntity>> watchLabels() {
    return database.watchAllLabels().map(
      (labels) => labels.map((label) => label.toEntity()).toList(),
    );
  }

  @override
  Future<LabelEntity> addLabel(String name) async {
    final existing = await database.getLabelByName(name);
    if (existing != null) return existing.toEntity();
    final id = await database.insertLabel(
      LabelEntity(id: 0, name: name).toInsertCompanion(),
    );
    return LabelEntity(id: id, name: name);
  }

  @override
  Future<void> deleteLabel(int id) async {
    await database.deleteLabel(id);
  }

  @override
  Future<LabelEntity?> getLabelByName(String name) async {
    final label = await database.getLabelByName(name);
    return label?.toEntity();
  }
}
