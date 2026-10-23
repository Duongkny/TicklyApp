
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:injectable/injectable.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repos/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  // Chuyển Firebase User thành Domain Entity
  AppUser _mapUser(firebase.User user) {
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
    );
  }

  // Người dùng hiện tại
  @override
  AppUser? get currentUser {
    final user = _remoteDataSource.currentUser;

    return user == null ? null : _mapUser(user);
  }

  // Theo dõi đăng nhập / đăng xuất
  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map(
      (user) => user == null ? null : _mapUser(user),
    );
  }

  // Đăng nhập
  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Sign in failed: user is null');
    }

    return _mapUser(user);
  }

  // Đăng ký
  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _remoteDataSource.signUp(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Sign up failed: user is null');
    }

    return _mapUser(user);
  }

  // Đăng xuất
  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  // Quên mật khẩu
  @override
  Future<void> resetPassword({
    required String email,
  }) {
    return _remoteDataSource.resetPassword(email);
  }

  // Gửi email xác minh
  @override
  Future<void> sendEmailVerification() {
    return _remoteDataSource.sendEmailVerification();
  }

  // Làm mới trạng thái người dùng
  @override
  Future<AppUser?> reloadUser() async {
    final user = _remoteDataSource.currentUser;

    if (user == null) return null;

    await user.reload();

    final updatedUser = _remoteDataSource.currentUser;

    return updatedUser == null
        ? null
        : _mapUser(updatedUser);
  }
}
