import 'package:go_router/go_router.dart';
import 'package:tickly/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:tickly/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tickly/src/features/main_wrapper/presentation/home_screen.dart';
import 'package:tickly/src/router/route.dart';

import 'router.import.dart';

List<RouteBase> authRoutes() => [
  GoRoute(
    path: AppRoute.signIn,
    builder: (context, state) => const SignInScreen(),
  ),
 GoRoute(
    path: AppRoute.signUp,
    builder: (context, state) => const SignUpScreen(),
  ),
];