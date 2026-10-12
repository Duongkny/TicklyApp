import 'package:go_router/go_router.dart';
import 'package:tickly/src/router/route.dart';
import 'package:tickly/src/router/router.main.dart';



class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.home,
    debugLogDiagnostics: true,
    routes: [
      // Main screens
      ...mainRoutes(),
      // Sau khi triển khai Auth:
      // _authRoute(),
    ],
  );
}