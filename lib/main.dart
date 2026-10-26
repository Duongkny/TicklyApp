import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/constants/environment.dart';
import 'package:tickly/src/core/firebase/firebase_provider.dart';
import 'package:tickly/src/core/injections/injections.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/localization/bloc/localization_bloc.dart';
import 'package:tickly/src/core/localization/bloc/localization_event.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tickly/src/features/auth/presentation/bloc/auth_event.dart';

import 'src/core/app/my_app.dart';
import 'src/core/theme/bloc/theme_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('STEP 1: Initialize Environment');
  await Environment.initialize();

  debugPrint('STEP 2: Initialize Firebase');
  await FirebaseProvider.initialize();

  debugPrint('STEP 3: Initialize Hive');
  await AppLocalStorage().initLocalStorage();

  debugPrint('STEP 4: Initialize Injection');
  await configureDependencies();

  debugPrint('STEP 5: Check AuthBloc');
  debugPrint('AuthBloc registered: ${getIt.isRegistered<AuthBloc>()}');

  debugPrint('STEP 6: Run App');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()..add(GetTheme())),
        BlocProvider<LocalizationBloc>(
          create: (_) => LocalizationBloc()..add(GetLanguage()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(const AuthStarted()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
