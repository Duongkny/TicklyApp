import 'package:injectable/injectable.dart';

import '../entities/app_user.dart';
import '../repos/auth_repository.dart';

@injectable
class ObserveAuthState {
  final AuthRepository _repository;

  const ObserveAuthState(this._repository);

  Stream<AppUser?> call() {
    return _repository.authStateChanges;
  }
}