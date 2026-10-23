import 'package:equatable/equatable.dart';

import '../../domain/entities/task_entity.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

// Bắt đầu lắng nghe danh sách công việc.
final class TaskStarted extends TaskEvent {
  const TaskStarted();
}

// Dừng lắng nghe khi đăng xuất.
final class TaskStopped extends TaskEvent {
  const TaskStopped();
}

// Cập nhật danh sách từ Firestore.
final class TaskItemsUpdated extends TaskEvent {
  final List<TaskEntity> tasks;

  const TaskItemsUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

// Lỗi từ stream Firestore.
final class TaskSubscriptionFailed extends TaskEvent {
  final String message;

  const TaskSubscriptionFailed(this.message);

  @override
  List<Object?> get props => [message];
}

// Tạo công việc.
final class TaskCreateRequested extends TaskEvent {
  final TaskEntity task;

  const TaskCreateRequested(this.task);

  @override
  List<Object?> get props => [task];
}

// Chỉnh sửa công việc.
final class TaskUpdateRequested extends TaskEvent {
  final TaskEntity task;

  const TaskUpdateRequested(this.task);

  @override
  List<Object?> get props => [task];
}

// Đánh dấu hoàn thành/chưa hoàn thành.
final class TaskToggleRequested extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  const TaskToggleRequested({required this.taskId, required this.isCompleted});

  @override
  List<Object?> get props => [taskId, isCompleted];
}

// Xóa công việc.
final class TaskDeleteRequested extends TaskEvent {
  final String taskId;

  const TaskDeleteRequested(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

// Xóa thông báo kết quả thao tác.
final class TaskActionCleared extends TaskEvent {
  const TaskActionCleared();
}
