import 'package:injectable/injectable.dart';

import '../repos/auth_repository.dart';

@injectable
class SignOut {
  final AuthRepository _repository;

  const SignOut(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}