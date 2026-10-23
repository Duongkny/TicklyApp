import 'dart:convert';

import 'package:tickly/src/features/auth/domain/entities/user_token.dart';



class UserTokenModel extends UserToken {
  UserTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
    required super.tokenType,
  });

  UserTokenModel copyWith({
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    String? tokenType,
  }) {
    return UserTokenModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokenType': tokenType,
      'accessToken': accessToken,
      'expiresIn': expiresIn,
      'refreshToken': refreshToken,
    };
  }

  factory UserTokenModel.fromMap(Map<String, dynamic> map) {
    return UserTokenModel(
      accessToken: map["accessToken"],
      refreshToken: map["refreshToken"],
      expiresIn: map["expiresIn"],
      tokenType: map["tokenType"],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserTokenModel.fromJson(String source) =>
      UserTokenModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
