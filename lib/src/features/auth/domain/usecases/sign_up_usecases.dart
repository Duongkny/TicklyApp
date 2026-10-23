import 'package:injectable/injectable.dart';

import '../entities/app_user.dart';
import '../repos/auth_repository.dart';

@injectable
class SignUp {
  final AuthRepository _repository;

  const SignUp(this._repository);

  Future<AppUser> call({
    required String email,
    required String password,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
    );
  }
}