import 'package:domain/domain.dart';

import '../dtos/auth_session_dto.dart';
import '../dtos/user_dto.dart';

/// Mappers for authentication-related DTOs to domain entities
class AuthMappers {
  AuthMappers._();

  /// Map UserDto to User entity
  static User userFromDto(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      firstName: dto.firstName,
      lastName: dto.lastName,
      phoneNumber: dto.phoneNumber,
      avatarUrl: dto.avatarUrl,
      role: dto.roleEnum,
      isProfileComplete: dto.isProfileComplete,
      isSitterApproved: dto.isSitterApproved,
      createdAt: dto.createdAt,
    );
  }

  /// Map AuthSessionDto to AuthSession entity
  static AuthSession authSessionFromDto(AuthSessionDto dto) {
    return AuthSession(
      user: userFromDto(dto.user),
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      expiresAt: dto.expiresAt,
    );
  }

  /// Map User entity to UserDto
  static UserDto userToDto(User user) {
    return UserDto(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      avatarUrl: user.avatarUrl,
      role: user.role.name,
      isProfileComplete: user.isProfileComplete,
      isSitterApproved: user.isSitterApproved,
      createdAt: user.createdAt,
    );
  }

  /// Convert UserRole enum to string for API
  static String roleToString(UserRole role) {
    return role.name;
  }

  /// Convert string to UserRole enum
  static UserRole roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'sitter':
        return UserRole.sitter;
      case 'parent':
      default:
        return UserRole.parent;
    }
  }
}
