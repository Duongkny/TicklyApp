import 'package:injectable/injectable.dart';

import '../entities/category_entity.dart';
import '../repos/category_repository.dart';

@injectable
class UpdateCategory {
  const UpdateCategory(this._repository);

  final CategoryRepository _repository;

  Future<void> call(CategoryEntity category) {
    return _repository.updateCategory(category);
  }
}
