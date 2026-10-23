enum TaskPriority { low, medium, high }

enum TaskStatus { pending, completed }

class TaskEntity {
  const TaskEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.categoryId,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.dueDate,
    this.reminderAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? categoryId;

  final TaskPriority priority;
  final TaskStatus status;

  final DateTime? dueDate;
  final DateTime? reminderAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isCompleted => status == TaskStatus.completed;
}
