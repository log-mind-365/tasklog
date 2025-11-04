import '../entities/folder_entity.dart';
import '../repositories/folder_repository.dart';

class GetFoldersUseCase {
  final FolderRepository repository;

  GetFoldersUseCase(this.repository);

  Future<List<FolderEntity>> call() async {
    return await repository.getFolders();
  }

  Stream<List<FolderEntity>> watch() {
    return repository.watchFolders();
  }
}
