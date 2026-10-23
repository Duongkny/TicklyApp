import 'package:equatable/equatable.dart';

import '../../domain/entities/task_entity.dart';

enum TaskStatusView { initial, loading, success, failure }

enum TaskActionStatus { initial, loading, success, failure }

enum TaskAction { none, create, update, toggle, delete }

class TaskState extends Equatable {
  final TaskStatusView status;
  final TaskActionStatus actionStatus;
  final TaskAction action;
  final List<TaskEntity> tasks;
  final String? errorMessage;
  final String? successMessage;

  const TaskState({
    this.status = TaskStatusView.initial,
    this.actionStatus = TaskActionStatus.initial,
    this.action = TaskAction.none,
    this.tasks = const [],
    this.errorMessage,
    this.successMessage,
  });

  TaskState copyWith({
    TaskStatusView? status,
    TaskActionStatus? actionStatus,
    TaskAction? action,
    List<TaskEntity>? tasks,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return TaskState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      action: action ?? this.action,
      tasks: tasks ?? this.tasks,
      errorMessage: clearMessages
          ? errorMessage
          : errorMessage ?? this.errorMessage,
      successMessage: clearMessages
          ? successMessage
          : successMessage ?? this.successMessage,
    );
  }

  List<TaskEntity> get pendingTasks =>
      tasks.where((task) => !task.isCompleted).toList();

  List<TaskEntity> get completedTasks =>
      tasks.where((task) => task.isCompleted).toList();

  int get totalTasks => tasks.length;

  int get completedCount => completedTasks.length;

  double get completionProgress {
    if (tasks.isEmpty) return 0;

    return completedCount / tasks.length;
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    action,
    tasks,
    errorMessage,
    successMessage,
  ];
}
