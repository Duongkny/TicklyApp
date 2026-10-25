
import 'package:go_router/go_router.dart';

import 'package:tickly/src/core/auth/auth_refresh_notifier.dart';
import 'package:tickly/src/router/route.dart';
import 'package:tickly/src/router/router.auth.dart';
import 'package:tickly/src/router/router.main.dart';

class AppRouter {
  AppRouter._();

  static final AuthRefreshNotifier _authNotifier =
      AuthRefreshNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.signIn,
    debugLogDiagnostics: true,

    refreshListenable: _authNotifier,

    redirect: (context, state) {
      // Chờ Firebase khôi phục trạng thái đăng nhập.
      if (!_authNotifier.isReady) {
        return null;
      }

      final user = _authNotifier.user;
      final location = state.matchedLocation;

      final isSignIn = location == AppRoute.signIn;
      final isHome = location == AppRoute.home;

      // Chưa đăng nhập thì không cho vào Home.
      if (user == null) {
        if (isHome) {
          return AppRoute.signIn;
        }

        return null;
      }

      // Đã đăng nhập thì không cần vào Sign In nữa.
      if (isSignIn) {
        return AppRoute.home;
      }

      return null;
    },

    routes: [
      ...mainRoutes(),
      ...authRoutes(),
    ],
  );
}
