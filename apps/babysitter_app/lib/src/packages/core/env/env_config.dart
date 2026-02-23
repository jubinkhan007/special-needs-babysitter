import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/constants.dart';
import 'package:flutter/foundation.dart';

/// Environment configuration loaded from .env file
class EnvConfig {
  EnvConfig._();

  static String? _getEnv(String key) {
    try {
      return dotenv.env[key];
    } catch (_) {
      return null;
    }
  }

  /// API base URL - uses .env value if set, otherwise falls back to Constants.baseUrl
  static String get apiBaseUrl => _getEnv('API_BASE_URL')?.isNotEmpty == true
      ? _getEnv('API_BASE_URL')!
      : Constants.baseUrl;
  
  static String get agoraAppId => _getEnv('AGORA_APP_ID') ?? '';
  
  static String get agoraTokenServerUrl =>
      _getEnv('AGORA_TOKEN_SERVER_URL') ?? '';
  
  static String get firebaseProjectId =>
      _getEnv('FIREBASE_PROJECT_ID') ?? '';

  static String get googleGeocodingApiKey =>
      _getEnv('GOOGLE_GEOCODING_API_KEY') ?? '';

  /// Check if API base URL is configured
  static bool get hasApiBaseUrl => apiBaseUrl.isNotEmpty;

  /// Check if Agora App ID is configured
  static bool get hasAgoraAppId => agoraAppId.isNotEmpty;

  /// Check if Agora token server is configured
  static bool get hasAgoraTokenServer => agoraTokenServerUrl.isNotEmpty;

  /// Load environment configuration
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  /// Try to load environment configuration, returns false on failure
  static Future<bool> tryLoad() async {
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('DEBUG: EnvConfig loaded .env OK. API_BASE_URL=${dotenv.env['API_BASE_URL']}');
      debugPrint('DEBUG: EnvConfig apiBaseUrl getter => $apiBaseUrl');
      return true;
    } catch (e) {
      // .env file not found or invalid
      debugPrint('DEBUG: EnvConfig failed to load .env: $e');
      return false;
    }
  }
}
