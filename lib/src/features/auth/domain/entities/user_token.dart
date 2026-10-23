import 'package:hive_ce_flutter/adapters.dart';

class UserToken extends HiveObject {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  UserToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  @override
  String toString() {
    return 'UserToken(tokenType: $tokenType, accessToken: $accessToken, expiresIn: $expiresIn, refreshToken: $refreshToken)';
  }
}
