import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../models/category_model.dart';

@lazySingleton
class CategoryRemoteDataSource {
  const CategoryRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('User is not authenticated');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _categories {
    return _firestore.collection('users').doc(_userId).collection('categories');
  }

  // ==================== CREATE ====================

  Future<String> createCategory(CategoryModel category) async {
    final uid = _userId;

    if (category.userId != uid) {
      throw StateError('Category owner does not match user');
    }

    final name = category.name.trim();

    if (name.isEmpty || name.length > 50) {
      throw ArgumentError('Category name must be 1-50 characters');
    }

    final doc = _categories.doc();

    await doc.set({
      ...category.toFirestore(),
      'userId': uid,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return doc.id;
  }

  // ==================== READ (REALTIME) ====================

  Stream<List<CategoryModel>> watchCategories() {
    return _categories.orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs.map(CategoryModel.fromFirestore).toList();
    });
  }

  // ==================== UPDATE ====================

  Future<void> updateCategory(CategoryModel category) async {
    if (category.userId != _userId) {
      throw StateError('Category owner does not match user');
    }

    final name = category.name.trim();

    if (name.isEmpty || name.length > 50) {
      throw ArgumentError('Category name must be 1-50 characters');
    }

    await _categories.doc(category.id).update({
      'name': name,
      'colorValue': category.colorValue,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ==================== DELETE ====================

  Future<void> deleteCategory(String categoryId) async {
    final uid = _userId;

    if (categoryId.trim().isEmpty) {
      throw ArgumentError('Category ID must not be empty');
    }

    final userRef = _firestore.collection('users').doc(uid);

    final categoryRef = userRef.collection('categories').doc(categoryId);

    final tasksRef = userRef.collection('tasks');

    // Kiểm tra Category tồn tại trước khi xóa.
    final categorySnapshot = await categoryRef.get();

    if (!categorySnapshot.exists) {
      throw StateError('Category does not exist');
    }

    // Tìm các Task đang thuộc danh mục này.
    final taskSnapshot = await tasksRef
        .where('categoryId', isEqualTo: categoryId)
        .limit(500)
        .get();

    // Giữ giới hạn bảo thủ cho một batch.
    if (taskSnapshot.docs.length > 499) {
      throw StateError(
        'Danh mục có quá nhiều công việc. '
        'Không thể xóa trong một lần.',
      );
    }

    // Tạo WriteBatch.
    final batch = _firestore.batch();

    // Chuyển các Task sang "Chưa phân loại".
    for (final taskDoc in taskSnapshot.docs) {
      batch.update(taskDoc.reference, {
        'categoryId': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // Xóa document Category.
    batch.delete(categoryRef);

    // Commit các thay đổi trong cùng một batch.
    await batch.commit();
  }
}
