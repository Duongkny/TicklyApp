import 'package:firebase_core/firebase_core.dart';
import 'package:tickly/src/constants/environment.dart';

import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;

class FirebaseProvider {
  FirebaseProvider._();

  static Future<FirebaseApp> initialize() async {
    final FirebaseOptions options;

    switch (Environment.current) {
      case AppEnvironment.development:
        options = dev.DefaultFirebaseOptions.currentPlatform;
        break;

      case AppEnvironment.production:
        options = prod.DefaultFirebaseOptions.currentPlatform;
        break;
    }

    // Đảm bảo Flutter Flavor và Firebase Project khớp nhau.
    final expectedProjectId = switch (Environment.current) {
      AppEnvironment.development => 'tickly-dev-da871',
      AppEnvironment.production => 'tickly-prod',
    };

    if (options.projectId != expectedProjectId) {
      throw StateError(
        'Firebase project mismatch: '
        'expected=$expectedProjectId, '
        'actual=${options.projectId}',
      );
    }

    if (Firebase.apps.isNotEmpty) {
      final app = Firebase.app();

      if (app.options.projectId != expectedProjectId) {
        throw StateError(
          'Firebase already initialized with '
          '${app.options.projectId}',
        );
      }

      return app;
    }

    return Firebase.initializeApp(options: options);
  }
}
