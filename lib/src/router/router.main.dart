import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tickly/src/core/injections/injections.dart';
import 'package:tickly/src/features/main_wrapper/presentation/home_screen.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_event.dart';
import 'package:tickly/src/router/route.dart';

import 'router.import.dart';

List<RouteBase> mainRoutes() => [
  GoRoute(
    path: AppRoute.home,
      builder: (context, state) => BlocProvider(
    create: (context) => getIt<TaskBloc>()
      ..add(const TaskStarted()),
    child: const HomeScreen(),
      )
  ),
  // GoRoute(
  //   path: AppRoute.settings,
  //   builder: (context, state) => const SettingsScreen(),
  // ),
];