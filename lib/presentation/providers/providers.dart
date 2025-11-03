import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/local/database.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/toggle_todo_done_usecase.dart';
import '../../domain/usecases/search_todos_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_category_usecase.dart';

part 'providers.g.dart';

// Database provider
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

// Repository providers
@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return TodoRepositoryImpl(database);
}

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  final database = ref.watch(appDatabaseProvider);
  return CategoryRepositoryImpl(database);
}

// UseCase providers
@riverpod
GetTodosUseCase getTodosUseCase(GetTodosUseCaseRef ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodosUseCase(repository);
}

@riverpod
AddTodoUseCase addTodoUseCase(AddTodoUseCaseRef ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return AddTodoUseCase(repository);
}

@riverpod
UpdateTodoUseCase updateTodoUseCase(UpdateTodoUseCaseRef ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return UpdateTodoUseCase(repository);
}

@riverpod
DeleteTodoUseCase deleteTodoUseCase(DeleteTodoUseCaseRef ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodoUseCase(repository);
}

@riverpod
ToggleTodoDoneUseCase toggleTodoDoneUseCase(ToggleTodoDoneUseCaseRef ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return ToggleTodoDoneUseCase(repository);
}

@riverpod
SearchTodosUseCase searchTodosUseCase(SearchTodosUseCaseRef ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return SearchTodosUseCase(repository);
}

@riverpod
GetCategoriesUseCase getCategoriesUseCase(GetCategoriesUseCaseRef ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
}

@riverpod
AddCategoryUseCase addCategoryUseCase(AddCategoryUseCaseRef ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return AddCategoryUseCase(repository);
}
