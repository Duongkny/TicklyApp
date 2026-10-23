import 'package:injectable/injectable.dart';

import '../entities/task_entity.dart';
import '../repos/task_repository.dart';

@injectable
class UpdateTask {
  final TaskRepository _repository;

  const UpdateTask(this._repository);

  Future<void> call(TaskEntity task) {
    return _repository.updateTask(task);
  }
}
