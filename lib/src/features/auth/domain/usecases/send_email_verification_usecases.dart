import 'package:injectable/injectable.dart';

import '../repos/auth_repository.dart';

@injectable
class SendEmailVerification {
  final AuthRepository _repository;

  const SendEmailVerification(this._repository);

  Future<void> call() {
    return _repository.sendEmailVerification();
  }
}