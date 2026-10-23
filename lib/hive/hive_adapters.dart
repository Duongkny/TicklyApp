import 'package:hive_ce_flutter/adapters.dart';
import 'package:tickly/src/features/auth/data/models/user_token_mode.dart';
import 'package:tickly/src/features/auth/domain/entities/user_token.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<UserToken>(),
  AdapterSpec<UserTokenModel>(),
])
// This is for code generation
// ignore: unused_element
void _() {}