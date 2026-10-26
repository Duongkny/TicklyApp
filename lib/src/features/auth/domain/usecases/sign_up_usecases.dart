import 'package:injectable/injectable.dart';

import '../entities/app_user.dart';
import '../repos/auth_repository.dart';

@injectable
class SignUp {
  final AuthRepository _repository;

  const SignUp(this._repository);

  Future<AppUser> call({
    String? displayName,
    required String email,
    required String password,
  }) {
    return _repository.signUp(
      displayName: displayName,
      email: email,
      password: password,
    );
  }
}
