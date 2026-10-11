import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tickly/src/core/logger/logger.dart';

class Environment {
  static bool _isInitialized = false;
  static String? _apiUrl;
  static String? _ivUtf8;

  static Future<void> initialize() async {
    if (_isInitialized) {
      logger.i('Environment already initialized');
      return;
    }

    try {
      await dotenv.load(fileName: fileName);
      _apiUrl = dotenv.env['API_URL'] ?? _throwMissingEnv('API_URL');
      _ivUtf8 = dotenv.env['IV_UTF8'] ?? _throwMissingEnv('IV_UTF8');
      _isInitialized = true;
      logger.i('Environment initialized successfully');
    } catch (e, s) {
      logger.e('Failed to initialize environment: $e');
      logger.d('Stack trace: $s');
      rethrow;
    }
  }

  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }
    return '.env.development';
  }

  static String get getApiUrl {
    _checkInitialized();
    return _apiUrl!;
  }

  static String get getIVUtf8 {
    _checkInitialized();
    return _ivUtf8!;
  }

  static void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'Environment not initialized. Call Environment.initialize() first.',
      );
    }
  }

  static String _throwMissingEnv(String key) {
    throw StateError(
      'Environment variable $key not found. Please check your .env file.',
    );
  }
}
