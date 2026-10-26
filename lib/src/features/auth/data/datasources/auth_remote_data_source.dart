import 'package:tickly/src/core/localization/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';

@lazySingleton
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSource(this._firebaseAuth);

  // Theo dõi phiên đăng nhập
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

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
    String? displayName,
    required String email,
    required String password,
  }) {
    return _createAccount(email, password, displayName);
  }

  Future<UserCredential> _createAccount(
    String email,
    String password,
    String? displayName,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName?.trim().isNotEmpty == true) {
      await credential.user?.updateDisplayName(displayName!.trim());
    }
    return credential;
  }

  // Gửi email xác minh
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('User is not authenticated');
    }

    await _firebaseAuth.setLanguageCode(AppStrings.current.localeName);
    await user.sendEmailVerification();
  }

  Future<User?> reloadUser() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    await user.reload();

    return _firebaseAuth.currentUser;
  }

  // Quên mật khẩu
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.setLanguageCode(AppStrings.current.localeName);
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  // Đăng xuất
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void>? _googleInitFuture;

  Future<void> _initGoogle() {
    return _googleInitFuture ??= _googleSignIn.initialize();
  }

  Future<UserCredential> signInWithGoogle() async {
    await _initGoogle();

    final googleUser = await _googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }
}
