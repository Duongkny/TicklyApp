import 'package:equatable/equatable.dart';

import '../../domain/entities/app_user.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthUserChanged extends AuthEvent {
  final AppUser? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String? displayName;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword, displayName];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthEmailVerificationRequested extends AuthEvent {
  const AuthEmailVerificationRequested();
}

class AuthReloadUserRequested extends AuthEvent {
  const AuthReloadUserRequested();
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}
