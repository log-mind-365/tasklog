import '../entities/folder_entity.dart';
import '../repositories/folder_repository.dart';

class AddFolderUseCase {
  final FolderRepository repository;

  AddFolderUseCase(this.repository);

  Future<int> call(FolderEntity folder) async {
    return await repository.addFolder(folder);
  }
}
