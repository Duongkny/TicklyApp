import 'package:injectable/injectable.dart';

import '../repos/category_repository.dart';

@injectable
class DeleteCategory {
  const DeleteCategory(this._repository);

  final CategoryRepository _repository;

  Future<void> call(String categoryId) {
    return _repository.deleteCategory(categoryId);
  }
}
