
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreTest {
  static Future<void> testConnection() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;

    if (user == null) {
      throw StateError('Bạn chưa đăng nhập');
    }

    await user.reload();

    final currentUser = auth.currentUser;

    if (currentUser == null || !currentUser.emailVerified) {
      throw StateError('Email chưa được xác minh');
    }

    await currentUser.getIdToken(true);

    final uid = currentUser.uid;

    await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc('test-task')
        .set({
          'userId': uid,
          'title': 'Test kết nối Firestore',
          'description': 'Kiểm tra kết nối từ Tickly',
          'categoryId': null,
          'priority': 'medium',
          'status': 'pending',
          'dueDate': null,
          'reminderAt': null,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }
}
