import 'package:injectable/injectable.dart';

import '../entities/app_user.dart';
import '../repos/auth_repository.dart';

@injectable
class SignInGoogle {
  final AuthRepository _repository;

  const SignInGoogle(this._repository);

  Future<AppUser> call() {
    return _repository.signInWithGoogle();
  }
}