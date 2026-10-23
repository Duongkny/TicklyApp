import 'package:injectable/injectable.dart';

import '../repos/task_repository.dart';

@injectable
class DeleteTask {
  final TaskRepository _repository;

  const DeleteTask(this._repository);

  Future<void> call(String taskId) {
    return _repository.deleteTask(taskId);
  }
}
