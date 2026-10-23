import 'package:injectable/injectable.dart';

import '../entities/app_user.dart';
import '../repos/auth_repository.dart';

@injectable
class ReloadUser {
  final AuthRepository _repository;

  const ReloadUser(this._repository);

  Future<AppUser?> call() {
    return _repository.reloadUser();
  }
}