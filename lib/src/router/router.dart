import 'package:go_router/go_router.dart';
import 'package:tickly/src/router/route.dart';
import 'package:tickly/src/router/router.auth.dart';
import 'package:tickly/src/router/router.main.dart';



class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.signIn,
    debugLogDiagnostics: true,
    routes: [
      // Main screens
      ...mainRoutes(),
      ...authRoutes(),
      // Sau khi triển khai Auth:
      // _authRoute(),
    ],
  );
}