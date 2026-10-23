import 'package:go_router/go_router.dart';
import 'package:tickly/src/features/main_wrapper/presentation/home_screen.dart';
import 'package:tickly/src/router/route.dart';

import 'router.import.dart';

List<RouteBase> mainRoutes() => [
  GoRoute(
    path: AppRoute.home,
    builder: (context, state) => const HomeScreen(),
  ),
  // GoRoute(
  //   path: AppRoute.settings,
  //   builder: (context, state) => const SettingsScreen(),
  // ),
];