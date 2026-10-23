
import '../entities/app_user.dart';

abstract class AuthRepository {
  // Người dùng đang đăng nhập
  AppUser? get currentUser;

  // Theo dõi thay đổi trạng thái xác thực
  Stream<AppUser?> get authStateChanges;

  // Đăng nhập
  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  // Đăng ký
  Future<AppUser> signUp({
    required String email,
    required String password,
  });

  // Đăng xuất
  Future<void> signOut();

  // Quên mật khẩu
  Future<void> resetPassword({
    required String email,
  });

  // Gửi email xác minh
  Future<void> sendEmailVerification();

  // Làm mới thông tin người dùng
  Future<AppUser?> reloadUser();

  Future<AppUser> signInWithGoogle();
}
