import 'package:injectable/injectable.dart';

import '../repos/task_repository.dart';

@injectable
class ToggleTask {
  final TaskRepository _repository;

  const ToggleTask(this._repository);

  Future<void> call({required String taskId, required bool isCompleted}) {
    return _repository.toggleTask(taskId: taskId, isCompleted: isCompleted);
  }
}
