import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<String> createCategory(CategoryEntity category);

  Stream<List<CategoryEntity>> watchCategories();

  Future<void> updateCategory(CategoryEntity category);

  Future<void> deleteCategory(String categoryId);
}
