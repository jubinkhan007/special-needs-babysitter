import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/constants.dart';

/// Environment configuration loaded from .env file
class EnvConfig {
  EnvConfig._();

  /// API base URL - uses .env value if set, otherwise falls back to Constants.baseUrl
  static String get apiBaseUrl => dotenv.env['API_BASE_URL']?.isNotEmpty == true
      ? dotenv.env['API_BASE_URL']!
      : Constants.baseUrl;
  static String get agoraAppId => dotenv.env['AGORA_APP_ID'] ?? '';
  static String get agoraTokenServerUrl =>
      dotenv.env['AGORA_TOKEN_SERVER_URL'] ?? '';
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

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
      return true;
    } catch (e) {
      // .env file not found or invalid
      return false;
    }
  }
}
