import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/local/database.dart';
import '../models/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase database;

  CategoryRepositoryImpl(this.database);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final categories = await database.getAllCategories();
    return categories.map((category) => category.toEntity()).toList();
  }

  @override
  Future<CategoryEntity> getCategoryById(int id) async {
    final category = await database.getCategoryById(id);
    return category.toEntity();
  }

  @override
  Future<int> addCategory(CategoryEntity category) async {
    return await database.insertCategory(category.toInsertCompanion());
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await database.updateCategory(category.toDriftModel());
  }

  @override
  Future<void> deleteCategory(int id) async {
    await database.deleteCategory(id);
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return database.watchAllCategories().map(
          (categories) => categories.map((category) => category.toEntity()).toList(),
        );
  }
}
