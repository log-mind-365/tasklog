import '../../domain/entities/folder_entity.dart';
import '../../domain/repositories/folder_repository.dart';
import '../datasources/local/database.dart';
import '../models/folder_mapper.dart';

class FolderRepositoryImpl implements FolderRepository {
  final AppDatabase database;

  FolderRepositoryImpl(this.database);

  @override
  Future<List<FolderEntity>> getFolders() async {
    final folders = await database.getAllFolders();
    return folders.map((folder) => folder.toEntity()).toList();
  }

  @override
  Future<FolderEntity> getFolderById(int id) async {
    final folder = await database.getFolderById(id);
    return folder.toEntity();
  }

  @override
  Future<int> addFolder(FolderEntity folder) async {
    return await database.insertFolder(folder.toInsertCompanion());
  }

  @override
  Future<void> updateFolder(FolderEntity folder) async {
    await database.updateFolder(folder.toDriftModel());
  }

  @override
  Future<void> deleteFolder(int id) async {
    await database.deleteFolder(id);
  }

  @override
  Stream<List<FolderEntity>> watchFolders() {
    return database.watchAllFolders().map(
          (folders) => folders.map((folder) => folder.toEntity()).toList(),
        );
  }
}
