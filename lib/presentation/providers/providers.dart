import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/local/database.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../data/repositories/folder_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/repositories/folder_repository.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/toggle_todo_done_usecase.dart';
import '../../domain/usecases/search_todos_usecase.dart';
import '../../domain/usecases/get_folders_usecase.dart';
import '../../domain/usecases/add_folder_usecase.dart';
import '../../domain/usecases/update_folder_usecase.dart';
import '../../domain/usecases/delete_folder_usecase.dart';

part 'providers.g.dart';

// Database provider
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

// Repository providers
@riverpod
TodoRepository todoRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return TodoRepositoryImpl(database);
}

@riverpod
FolderRepository folderRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return FolderRepositoryImpl(database);
}

// UseCase providers
@riverpod
GetTodosUseCase getTodosUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodosUseCase(repository);
}

@riverpod
AddTodoUseCase addTodoUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return AddTodoUseCase(repository);
}

@riverpod
UpdateTodoUseCase updateTodoUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return UpdateTodoUseCase(repository);
}

@riverpod
DeleteTodoUseCase deleteTodoUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodoUseCase(repository);
}

@riverpod
ToggleTodoDoneUseCase toggleTodoDoneUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return ToggleTodoDoneUseCase(repository);
}

@riverpod
SearchTodosUseCase searchTodosUseCase(Ref ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return SearchTodosUseCase(repository);
}

@riverpod
GetFoldersUseCase getFoldersUseCase(Ref ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return GetFoldersUseCase(repository);
}

@riverpod
AddFolderUseCase addFolderUseCase(Ref ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return AddFolderUseCase(repository);
}

@riverpod
UpdateFolderUseCase updateFolderUseCase(Ref ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return UpdateFolderUseCase(repository);
}

@riverpod
DeleteFolderUseCase deleteFolderUseCase(Ref ref) {
  final repository = ref.watch(folderRepositoryProvider);
  return DeleteFolderUseCase(repository);
}
