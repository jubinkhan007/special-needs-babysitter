import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:domain/domain.dart';
import 'package:core/core.dart';

/// Secure storage for authentication session data
class SessionStore {
  final FlutterSecureStorage _storage;

  SessionStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions:
                  IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Save authentication session
  Future<void> saveSession(AuthSession session) async {
    await _storage.write(
      key: Constants.accessTokenKey,
      value: session.accessToken,
    );
    if (session.refreshToken != null) {
      await _storage.write(
        key: Constants.refreshTokenKey,
        value: session.refreshToken,
      );
    }
    await _storage.write(
      key: Constants.userDataKey,
      value: jsonEncode(_userToJson(session.user)),
    );
  }

  /// Save user profile separately (for caching after getMe)
  Future<void> saveUserProfile(User user) async {
    await _storage.write(
      key: Constants.userDataKey,
      value: jsonEncode(_userToJson(user)),
    );
  }

  /// Load stored session
  Future<AuthSession?> loadSession() async {
    final accessToken = await _storage.read(key: Constants.accessTokenKey);
    if (accessToken == null) return null;

    final refreshToken = await _storage.read(key: Constants.refreshTokenKey);
    final userData = await _storage.read(key: Constants.userDataKey);

    if (userData == null) return null;

    try {
      final userJson = jsonDecode(userData) as Map<String, dynamic>;
      final user = _userFromJson(userJson);
      return AuthSession(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      // Corrupted data, clear storage
      await clearSession();
      return null;
    }
  }

  /// Load cached user profile
  Future<User?> loadUserProfile() async {
    final userData = await _storage.read(key: Constants.userDataKey);
    if (userData == null) return null;

    try {
      final userJson = jsonDecode(userData) as Map<String, dynamic>;
      return _userFromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    return _storage.read(key: Constants.accessTokenKey);
  }

  /// Clear all stored session data
  Future<void> clearSession() async {
    await _storage.delete(key: Constants.accessTokenKey);
    await _storage.delete(key: Constants.refreshTokenKey);
    await _storage.delete(key: Constants.userDataKey);
  }

  Map<String, dynamic> _userToJson(User user) {
    return {
      'id': user.id,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phoneNumber': user.phoneNumber,
      'avatarUrl': user.avatarUrl,
      'role': user.role.name,
      'isProfileComplete': user.isProfileComplete,
      'isSitterApproved': user.isSitterApproved,
      'createdAt': user.createdAt?.toIso8601String(),
    };
  }

  User _userFromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: _roleFromString(json['role'] as String?),
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      isSitterApproved: json['isSitterApproved'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  UserRole _roleFromString(String? role) {
    switch (role) {
      case 'sitter':
        return UserRole.sitter;
      case 'parent':
      default:
        return UserRole.parent;
    }
  }
}
