import '../repositories/folder_repository.dart';

class DeleteFolderUseCase {
  final FolderRepository repository;

  DeleteFolderUseCase(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteFolder(id);
  }
}
