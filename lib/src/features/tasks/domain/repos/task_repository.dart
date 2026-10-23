import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<String> createTask(TaskEntity task);

  Stream<List<TaskEntity>> watchTasks();

  Future<TaskEntity?> getTaskById(String taskId);

  Future<void> updateTask(TaskEntity task);

  Future<void> toggleTask({required String taskId, required bool isCompleted});

  Future<void> deleteTask(String taskId);
}
