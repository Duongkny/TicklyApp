import 'package:injectable/injectable.dart';

import '../entities/task_entity.dart';
import '../repos/task_repository.dart';

@injectable
class GetTasks {
  final TaskRepository _repository;

  const GetTasks(this._repository);

  Stream<List<TaskEntity>> call() {
    return _repository.watchTasks();
  }
}
