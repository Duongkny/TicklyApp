import 'package:injectable/injectable.dart';

import '../entities/app_user.dart';
import '../repos/auth_repository.dart';

@injectable
class GetCurrentUser {
  final AuthRepository _repository;

  const GetCurrentUser(this._repository);

  AppUser? call() {
    return _repository.currentUser;
  }
}