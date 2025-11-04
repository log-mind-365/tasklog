import '../entities/folder_entity.dart';
import '../repositories/folder_repository.dart';

class UpdateFolderUseCase {
  final FolderRepository repository;

  UpdateFolderUseCase(this.repository);

  Future<void> call(FolderEntity folder) async {
    return await repository.updateFolder(folder);
  }
}
