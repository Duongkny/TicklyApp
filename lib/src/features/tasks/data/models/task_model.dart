import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    super.categoryId,
    super.priority,
    super.status,
    super.dueDate,
    super.reminderAt,
    required super.createdAt,
    required super.updatedAt,
  });

  // Chuyển Entity sang Model
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      description: entity.description,
      categoryId: entity.categoryId,
      priority: entity.priority,
      status: entity.status,
      dueDate: entity.dueDate,
      reminderAt: entity.reminderAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // Đọc dữ liệu từ Firestore
  factory TaskModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw StateError('Task document does not exist');
    }

    return TaskModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      description: data['description'] as String?,
      categoryId: data['categoryId'] as String?,
      priority: TaskPriority.values.byName(
        data['priority'] as String? ?? 'medium',
      ),
      status: TaskStatus.values.byName(data['status'] as String? ?? 'pending'),
      dueDate: _dateTime(data['dueDate']),
      reminderAt: _dateTime(data['reminderAt']),
      createdAt: _dateTime(data['createdAt']) ?? DateTime.now(),
      updatedAt: _dateTime(data['updatedAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _dateTime(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    throw FormatException('Invalid Firestore timestamp');
  }

  // Ghi dữ liệu lên Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'priority': priority.name,
      'status': status.name,
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      'reminderAt': reminderAt == null ? null : Timestamp.fromDate(reminderAt!),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
