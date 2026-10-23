import 'package:injectable/injectable.dart';

import '../entities/category_entity.dart';
import '../repos/category_repository.dart';

@injectable
class GetCategories {
  const GetCategories(this._repository);

  final CategoryRepository _repository;

  Stream<List<CategoryEntity>> call() {
    return _repository.watchCategories();
  }
}
