import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tickly/src/constants/environment.dart';
import 'package:tickly/src/core/app/my_app.dart';

import 'package:tickly/src/core/firebase/firebase_provider.dart';
import 'package:tickly/src/core/localization/bloc/localization_bloc.dart';
import 'package:tickly/src/core/localization/bloc/localization_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initialize();
  await FirebaseProvider.initialize();
  runApp(
    BlocProvider<LocalizationBloc>(
      create: (context) => LocalizationBloc()..add(GetLanguage()),
      child: const MyApp(),
    ),
  );
}

bool isInitializedFirebase = false;

