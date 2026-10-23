
import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

enum AuthActionStatus {
  initial,
  loading,
  success,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthActionStatus actionStatus;
  final AppUser? user;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.actionStatus = AuthActionStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthActionStatus? actionStatus,
    AppUser? user,
    bool clearUser = false,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      user: clearUser ? null : (user ?? this.user),
      errorMessage:
          clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    user,
    errorMessage,
    successMessage,
  ];
}
