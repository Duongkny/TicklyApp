
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:tickly/src/features/auth/domain/usecases/sign_in_google_usecases.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/get_current_user_usecases.dart';
import '../../domain/usecases/observe_auth_state_usecases.dart';
import '../../domain/usecases/reload_user_usecases.dart';
import '../../domain/usecases/reset_password_usecases.dart';
import '../../domain/usecases/send_email_verification_usecases.dart';
import '../../domain/usecases/sign_in_usecases.dart';
import '../../domain/usecases/sign_out_usecases.dart';
import '../../domain/usecases/sign_up_usecases.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final ResetPassword _resetPassword;
  final SendEmailVerification _sendEmailVerification;
  final GetCurrentUser _getCurrentUser;
  final ObserveAuthState _observeAuthState;
  final ReloadUser _reloadUser;
  final SignInGoogle _signInGoogle;

  StreamSubscription<AppUser?>? _authSubscription;

  AuthBloc(
    this._signIn,
    this._signUp,
    this._signOut,
    this._resetPassword,
    this._sendEmailVerification,
    this._getCurrentUser,
    this._observeAuthState,
    this._reloadUser,
    this._signInGoogle
  ) : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthUserChanged>(_onUserChanged);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthPasswordResetRequested>(_onResetPassword);
    on<AuthEmailVerificationRequested>(_onSendVerification);
    on<AuthReloadUserRequested>(_onReloadUser);
    on<AuthGoogleSignInRequested>(_onGoogleSignIn);
  }

  // ================= AUTH SESSION =================

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    await _authSubscription?.cancel();

    final currentUser = _getCurrentUser();

    emit(
      state.copyWith(
        status: currentUser == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
        user: currentUser,
        clearUser: currentUser == null,
      ),
    );

    _authSubscription = _observeAuthState().listen(
      (user) {
        if (!isClosed) {
          add(AuthUserChanged(user));
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        addError(error, stackTrace);
      },
    );
  }

  void _onUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        status: event.user == null
            ? AuthStatus.unauthenticated
            : AuthStatus.authenticated,
        user: event.user,
        clearUser: event.user == null,
      ),
    );
  }

  // ================= SIGN IN =================

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      final user = await _signIn(
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          actionStatus: AuthActionStatus.success,
          successMessage: 'Đăng nhập thành công',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: _errorMessage(e),
        ),
      );
    }
  }

  // ================= SIGN UP =================

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: 'Mật khẩu xác nhận không khớp',
          clearMessages: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      final user = await _signUp(
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          actionStatus: AuthActionStatus.success,
          successMessage: 'Đăng ký thành công',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: _errorMessage(e),
        ),
      );
    }
  }

  // ================= SIGN OUT =================

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _signOut();

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          actionStatus: AuthActionStatus.success,
          clearUser: true,
          successMessage: 'Đăng xuất thành công',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: _errorMessage(e),
        ),
      );
    }
  }

  // ================= RESET PASSWORD =================

  Future<void> _onResetPassword(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _resetPassword(event.email);

      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.success,
          successMessage:
              'Nếu email hợp lệ, bạn sẽ nhận được '
              'hướng dẫn đặt lại mật khẩu',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: _errorMessage(e),
        ),
      );
    }
  }

  // ================= EMAIL VERIFICATION =================

  Future<void> _onSendVerification(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      await _sendEmailVerification();

      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.success,
          successMessage: 'Đã gửi email xác minh',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: _errorMessage(e),
        ),
      );
    }
  }

  // ================= RELOAD USER =================

  Future<void> _onReloadUser(
    AuthReloadUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.loading,
        clearMessages: true,
      ),
    );

    try {
      final user = await _reloadUser();

      emit(
        state.copyWith(
          status: user == null
              ? AuthStatus.unauthenticated
              : AuthStatus.authenticated,
          user: user,
          clearUser: user == null,
          actionStatus: AuthActionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.failure,
          errorMessage: _errorMessage(e),
        ),
      );
    }
  }

  String _errorMessage(Object error) {
    // Tạm thời dùng thông báo chung để tránh
    // hiển thị lỗi nội bộ Firebase cho người dùng.
    return 'Thao tác không thành công. Vui lòng thử lại.';
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await super.close();
  }

  Future<void> _onGoogleSignIn(
  AuthGoogleSignInRequested event,
  Emitter<AuthState> emit,
) async {
  if (state.actionStatus == AuthActionStatus.loading) return;

  emit(
    state.copyWith(
      actionStatus: AuthActionStatus.loading,
      clearMessages: true,
    ),
  );

  try {
    final user = await _signInGoogle();

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        actionStatus: AuthActionStatus.success,
        successMessage: 'Đăng nhập Google thành công',
        clearMessages: true,
      ),
    );
  } on GoogleSignInException catch (e) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      emit(
        state.copyWith(
          actionStatus: AuthActionStatus.initial,
          clearMessages: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.failure,
        errorMessage: 'Không thể đăng nhập bằng Google',
        clearMessages: true,
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        actionStatus: AuthActionStatus.failure,
        errorMessage: 'Đăng nhập Google thất bại. Vui lòng thử lại.',
        clearMessages: true,
      ),
    );
  }
}
}
