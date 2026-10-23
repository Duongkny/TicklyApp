import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:tickly/src/features/tasks/domain/entities/task_entity.dart';

import '../models/task_model.dart';

@lazySingleton
class TaskRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  TaskRemoteDataSource(this._firestore, this._firebaseAuth);

  String get _userId {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('User is not authenticated');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _tasks {
    return _firestore.collection('users').doc(_userId).collection('tasks');
  }

  // ==================== CREATE ====================

  Future<String> createTask(TaskModel task) async {
    final uid = _userId;

    if (task.userId != uid) {
      throw StateError('Task owner does not match user');
    }

    if (task.title.trim().isEmpty) {
      throw ArgumentError('Task title is required');
    }

    final doc = _tasks.doc();
    final data = task.toFirestore();

    data['userId'] = uid;
    data['title'] = task.title.trim();
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await doc.set(data);

    return doc.id;
  }

  // ==================== READ ====================

  Stream<List<TaskModel>> watchTasks() {
    return _tasks
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(TaskModel.fromFirestore).toList());
  }

  Future<TaskModel?> getTaskById(String taskId) async {
    final snapshot = await _tasks.doc(taskId).get();

    if (!snapshot.exists) return null;

    return TaskModel.fromFirestore(snapshot);
  }

  // ==================== UPDATE ====================

  Future<void> updateTask(TaskModel task) async {
    if (task.userId != _userId) {
      throw StateError('Task owner does not match user');
    }

    if (task.title.trim().isEmpty) {
      throw ArgumentError('Task title is required');
    }

    final data = task.toFirestore();

    // Không thay đổi danh tính và thời gian tạo Task.
    data.remove('userId');
    data.remove('createdAt');

    data['title'] = task.title.trim();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _tasks.doc(task.id).update(data);
  }

  // ==================== COMPLETE ====================

  Future<void> toggleTask({
    required String taskId,
    required bool isCompleted,
  }) async {
    await _tasks.doc(taskId).update({
      'status': isCompleted
          ? TaskStatus.completed.name
          : TaskStatus.pending.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== DELETE ====================

  Future<void> deleteTask(String taskId) async {
    await _tasks.doc(taskId).delete();
  }
}
