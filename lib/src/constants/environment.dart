import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tickly/src/core/logger/logger.dart';

enum AppEnvironment {
  development,
  production,
}

class Environment {
  static bool _isInitialized = false;

  static String? _apiUrl;
  static String? _ivUtf8;

  static AppEnvironment get current {
    switch (appFlavor) {
      case 'development':
        return AppEnvironment.development;

      case 'production':
        return AppEnvironment.production;

      default:
        throw StateError(
          'Invalid Flutter flavor: $appFlavor. '
          'Use --flavor development or --flavor production.',
        );
    }
  }

  static bool get isDevelopment =>
      current == AppEnvironment.development;

  static bool get isProduction =>
      current == AppEnvironment.production;

  static String get fileName {
    switch (current) {
      case AppEnvironment.development:
        return '.env.development';

      case AppEnvironment.production:
        return '.env.production';
    }
  }

  static Future<void> initialize() async {
    if (_isInitialized) {
      logger.i('Environment already initialized');
      return;
    }

    try {
      await dotenv.load(fileName: fileName);

      final expectedEnvironment = current.name;
      final configuredEnvironment = dotenv.env['APP_ENV'];

      if (configuredEnvironment != expectedEnvironment) {
        throw StateError(
          'Environment mismatch: '
          'Flavor=$expectedEnvironment, '
          'APP_ENV=$configuredEnvironment.',
        );
      }

      _apiUrl = dotenv.env['API_URL'];
      _ivUtf8 = dotenv.env['IV_UTF8'];

      _isInitialized = true;

      logger.i(
        'Environment initialized: ${current.name}',
      );
    } catch (e, s) {
      logger.e('Failed to initialize environment: $e');
      logger.d('Stack trace: $s');
      rethrow;
    }
  }

  static String get getApiUrl {
    _checkInitialized();
    return _apiUrl ?? _throwMissingEnv('API_URL');
  }

  static String get getIVUtf8 {
    _checkInitialized();
    return _ivUtf8 ?? _throwMissingEnv('IV_UTF8');
  }

  static void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'Environment not initialized. '
        'Call Environment.initialize() first.',
      );
    }
  }

  static Never _throwMissingEnv(String key) {
    throw StateError(
      'Environment variable $key not found. '
      'Please check your .env file.',
    );
  }
}
