// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce_flutter/adapters.dart' as _i170;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:tickly/src/core/injections/module.dart' as _i336;
import 'package:tickly/src/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i271;
import 'package:tickly/src/features/auth/data/repos/auth_repository_impl.dart'
    as _i405;
import 'package:tickly/src/features/auth/domain/repos/auth_repository.dart'
    as _i470;
import 'package:tickly/src/features/auth/domain/usecases/get_current_user_usecases.dart'
    as _i397;
import 'package:tickly/src/features/auth/domain/usecases/observe_auth_state_usecases.dart'
    as _i731;
import 'package:tickly/src/features/auth/domain/usecases/reload_user_usecases.dart'
    as _i1056;
import 'package:tickly/src/features/auth/domain/usecases/reset_password_usecases.dart'
    as _i269;
import 'package:tickly/src/features/auth/domain/usecases/send_email_verification_usecases.dart'
    as _i734;
import 'package:tickly/src/features/auth/domain/usecases/sign_in_usecases.dart'
    as _i497;
import 'package:tickly/src/features/auth/domain/usecases/sign_out_usecases.dart'
    as _i115;
import 'package:tickly/src/features/auth/domain/usecases/sign_up_usecases.dart'
    as _i564;
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart'
    as _i429;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i170.HiveInterface>(() => registerModule.hive);
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => registerModule.firebaseMessaging,
    );
    gh.lazySingleton<_i974.Logger>(() => registerModule.logger);
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i271.AuthRemoteDataSource>(
      () => _i271.AuthRemoteDataSource(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i470.AuthRepository>(
      () => _i405.AuthRepositoryImpl(gh<_i271.AuthRemoteDataSource>()),
    );
    gh.factory<_i397.GetCurrentUser>(
      () => _i397.GetCurrentUser(gh<_i470.AuthRepository>()),
    );
    gh.factory<_i731.ObserveAuthState>(
      () => _i731.ObserveAuthState(gh<_i470.AuthRepository>()),
    );
    gh.factory<_i1056.ReloadUser>(
      () => _i1056.ReloadUser(gh<_i470.AuthRepository>()),
    );
    gh.factory<_i269.ResetPassword>(
      () => _i269.ResetPassword(gh<_i470.AuthRepository>()),
    );
    gh.factory<_i734.SendEmailVerification>(
      () => _i734.SendEmailVerification(gh<_i470.AuthRepository>()),
    );
    gh.factory<_i497.SignIn>(() => _i497.SignIn(gh<_i470.AuthRepository>()));
    gh.factory<_i115.SignOut>(() => _i115.SignOut(gh<_i470.AuthRepository>()));
    gh.factory<_i564.SignUp>(() => _i564.SignUp(gh<_i470.AuthRepository>()));
    gh.factory<_i429.AuthBloc>(
      () => _i429.AuthBloc(
        gh<_i497.SignIn>(),
        gh<_i564.SignUp>(),
        gh<_i115.SignOut>(),
        gh<_i269.ResetPassword>(),
        gh<_i734.SendEmailVerification>(),
        gh<_i397.GetCurrentUser>(),
        gh<_i731.ObserveAuthState>(),
        gh<_i1056.ReloadUser>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i336.RegisterModule {}

class _$FirebaseModule extends _i336.FirebaseModule {}
