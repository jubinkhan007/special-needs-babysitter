import 'package:equatable/equatable.dart';

import 'user.dart';

/// Represents an authenticated session with user and tokens
class AuthSession extends Equatable {
  final User user;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  AuthSession copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];
}
