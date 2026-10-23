import 'package:injectable/injectable.dart';
import 'package:tickly/src/features/categories/data/datasource/category_remote_data_source.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repos/category_repository.dart';

import '../models/category_model.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remoteDataSource);

  final CategoryRemoteDataSource _remoteDataSource;

  @override
  Future<String> createCategory(CategoryEntity category) {
    return _remoteDataSource.createCategory(CategoryModel.fromEntity(category));
  }

  @override
  Stream<List<CategoryEntity>> watchCategories() {
    return _remoteDataSource.watchCategories();
  }

  @override
  Future<void> updateCategory(CategoryEntity category) {
    return _remoteDataSource.updateCategory(CategoryModel.fromEntity(category));
  }

  @override
  Future<void> deleteCategory(String categoryId) {
    return _remoteDataSource.deleteCategory(categoryId);
  }
}
