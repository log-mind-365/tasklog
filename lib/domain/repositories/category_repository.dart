import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<CategoryEntity> getCategoryById(int id);
  Future<int> addCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(int id);
  Stream<List<CategoryEntity>> watchCategories();
}
