
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tickly/src/core/logger/logger.dart';

enum AppEnvironment {
  development,
  production,
}

class Environment {
  Environment._();

  static bool _isInitialized = false;

  static String? _apiUrl;
  static String? _ivUtf8;

  // Xác định môi trường dựa trên Flutter Flavor
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

  // Lấy file .env theo Flavor, không theo Build Mode
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

      // API_URL và IV_UTF8 chỉ cần thiết nếu dự án sử dụng
      _apiUrl = dotenv.env['API_URL'];
      _ivUtf8 = dotenv.env['IV_UTF8'];

      // Kiểm tra để tránh dùng nhầm file môi trường
      final expectedEnvironment = current.name;
      final configuredEnvironment = dotenv.env['APP_ENV'];

      if (configuredEnvironment != expectedEnvironment) {
        throw StateError(
          'Environment mismatch: '
          'Flutter flavor=$expectedEnvironment, '
          'APP_ENV=$configuredEnvironment.',
        );
      }

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

    return _apiUrl ??
        _throwMissingEnv('API_URL');
  }

  static String get getIVUtf8 {
    _checkInitialized();

    return _ivUtf8 ??
        _throwMissingEnv('IV_UTF8');
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
