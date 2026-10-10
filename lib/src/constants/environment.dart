
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/logger/logger.dart';

enum AppEnvironment {
  development,
  production,
}

class Environment {
  Environment._();

  static bool _isInitialized = false;

  static AppEnvironment? _current;

  static Future<void> initialize() async {
    if (_isInitialized) {
      logger.i('Environment already initialized');
      return;
    }

    try {
      final flavor = appFlavor;

      _current = switch (flavor) {
        'development' => AppEnvironment.development,
        'production' => AppEnvironment.production,
        _ => throw StateError(
            'Invalid Flutter flavor: $flavor',
          ),
      };

      await dotenv.load(fileName: fileName);

      final declaredEnv = dotenv.env['APP_ENV'];

      if (declaredEnv != _current!.name) {
        throw StateError(
          'Environment mismatch: '
          'flavor=$flavor, APP_ENV=$declaredEnv',
        );
      }

      _isInitialized = true;
      logger.i(
        'Environment initialized: ${_current!.name}',
      );
    } catch (e, s) {
      logger.e('Failed to initialize environment: $e');
      logger.d('Stack trace: $s');
      rethrow;
    }
  }

  static String get fileName {
    switch (appFlavor) {
      case 'development':
        return '.env.development';

      case 'production':
        return '.env.production';

      default:
        throw StateError(
          'Invalid Flutter flavor: $appFlavor',
        );
    }
  }

  static AppEnvironment get current {
    _checkInitialized();
    return _current!;
  }

  static bool get isDevelopment =>
      current == AppEnvironment.development;

  static bool get isProduction =>
      current == AppEnvironment.production;

  static String get appName =>
      isDevelopment ? 'Tickly Dev' : 'Tickly';

  static void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'Environment not initialized. '
        'Call Environment.initialize() first.',
      );
    }
  }
}
