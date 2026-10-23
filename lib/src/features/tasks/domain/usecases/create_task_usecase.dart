import 'package:injectable/injectable.dart';

import '../entities/task_entity.dart';
import '../repos/task_repository.dart';

@injectable
class CreateTask {
  final TaskRepository _repository;

  const CreateTask(this._repository);

  Future<String> call(TaskEntity task) {
    return _repository.createTask(task);
  }
}
