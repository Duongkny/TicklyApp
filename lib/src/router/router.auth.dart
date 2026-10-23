import 'package:go_router/go_router.dart';
import 'package:tickly/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tickly/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:tickly/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:tickly/src/features/auth/presentation/screens/verify_email_screen.dart';
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
  GoRoute(
    path: AppRoute.forgotPassword,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
  GoRoute(
    path: AppRoute.verifyEmail,
    builder: (context, state) => const VerifyEmailScreen(),
  ),
];