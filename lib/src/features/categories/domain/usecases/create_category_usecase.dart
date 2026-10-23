import 'package:injectable/injectable.dart';

import '../entities/category_entity.dart';
import '../repos/category_repository.dart';

@injectable
class CreateCategory {
  const CreateCategory(this._repository);

  final CategoryRepository _repository;

  Future<String> call(CategoryEntity category) {
    return _repository.createCategory(category);
  }
}
