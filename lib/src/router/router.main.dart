
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:tickly/src/core/injections/injections.dart';

// HomeScreen
import 'package:tickly/src/features/main_wrapper/presentation/home_screen.dart';

// TaskBloc
import 'package:tickly/src/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:tickly/src/features/tasks/presentation/bloc/task_event.dart';

// CategoryBloc
import 'package:tickly/src/features/categories/presentation/bloc/category_bloc.dart';
import 'package:tickly/src/features/categories/presentation/bloc/category_event.dart';

// Routes
import 'package:tickly/src/router/route.dart';

List<RouteBase> mainRoutes() => [
  GoRoute(
    path: AppRoute.home,
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          // ==================== TASK BLOC ====================
          BlocProvider<TaskBloc>(
            create: (_) => getIt<TaskBloc>()
              ..add(const TaskStarted()),
          ),

          // ==================== CATEGORY BLOC ====================
          BlocProvider<CategoryBloc>(
            create: (_) => getIt<CategoryBloc>()
              ..add(const CategoryStarted()),
          ),
        ],
        child: const HomeScreen(),
      );
    },
  ),

  // GoRoute(
  //   path: AppRoute.settings,
  //   builder: (context, state) => const SettingsScreen(),
  // ),
];
