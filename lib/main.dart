import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tickly/src/constants/environment.dart';
import 'package:tickly/src/core/app/my_app.dart';
import 'package:tickly/src/core/firebase/firebase_provider.dart';
import 'package:tickly/src/core/local_storage/app_local_storage.dart';
import 'package:tickly/src/core/localization/bloc/localization_bloc.dart';
import 'package:tickly/src/core/localization/bloc/localization_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Environment
  await Environment.initialize();

  // 2. Firebase
  await FirebaseProvider.initialize();

  // 3. Hive CE + Register Adapters + Open Boxes
  await AppLocalStorage().initLocalStorage();

  // 4. Dependency Injection
  // await configureDependencies();

  // 5. Run App
  runApp(
    BlocProvider<LocalizationBloc>(
      create: (_) => LocalizationBloc()..add(GetLanguage()),
      child: const MyApp(),
    ),
  );
}
