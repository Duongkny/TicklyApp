import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource(this._firebaseAuth);

  // Theo dõi phiên đăng nhập
  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  // Lấy tài khoản hiện tại
  User? get currentUser => _firebaseAuth.currentUser;

  // Đăng nhập
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Đăng ký
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Gửi email xác minh
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('User is not authenticated');
    }

    await user.sendEmailVerification();
  }

  // Quên mật khẩu
  Future<void> resetPassword(String email) {
    return _firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  // Đăng xuất
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
