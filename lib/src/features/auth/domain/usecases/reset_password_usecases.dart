import 'package:injectable/injectable.dart';

import '../repos/auth_repository.dart';

@injectable
class ResetPassword {
  final AuthRepository _repository;

  const ResetPassword(this._repository);

  Future<void> call(String email) {
    return _repository.resetPassword(
      email: email,
    );
  }
}