import 'package:injectable/injectable.dart';
import 'package:tickly/src/features/tasks/data/datasource/task_remote_data_source.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/repos/task_repository.dart';
import '../models/task_model.dart';

@LazySingleton(as: TaskRepository)
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource _remoteDataSource;

  const TaskRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> createTask(TaskEntity task) {
    return _remoteDataSource.createTask(TaskModel.fromEntity(task));
  }

  @override
  Stream<List<TaskEntity>> watchTasks() {
    return _remoteDataSource.watchTasks();
  }

  @override
  Future<TaskEntity?> getTaskById(String taskId) {
    return _remoteDataSource.getTaskById(taskId);
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    return _remoteDataSource.updateTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> toggleTask({required String taskId, required bool isCompleted}) {
    return _remoteDataSource.toggleTask(
      taskId: taskId,
      isCompleted: isCompleted,
    );
  }

  @override
  Future<void> deleteTask(String taskId) {
    return _remoteDataSource.deleteTask(taskId);
  }
}
