import '../entities/folder_entity.dart';

abstract class FolderRepository {
  Future<List<FolderEntity>> getFolders();
  Future<FolderEntity> getFolderById(int id);
  Future<int> addFolder(FolderEntity folder);
  Future<void> updateFolder(FolderEntity folder);
  Future<void> deleteFolder(int id);
  Stream<List<FolderEntity>> watchFolders();
}
