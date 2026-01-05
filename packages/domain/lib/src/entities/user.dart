import 'package:equatable/equatable.dart';

import 'user_role.dart';

/// User entity representing authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserRole role;
  final bool isProfileComplete;
  final bool isSitterApproved; // Only relevant for sitters (background check)
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.avatarUrl,
    this.isProfileComplete = false,
    this.isSitterApproved = false,
    this.createdAt,
  });

  String get fullName {
    if (firstName == null && lastName == null) return email;
    return [firstName, lastName].whereType<String>().join(' ').trim();
  }

  String get initials {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  bool get isParent => role == UserRole.parent;
  bool get isSitter => role == UserRole.sitter;

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
    UserRole? role,
    bool? isProfileComplete,
    bool? isSitterApproved,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isSitterApproved: isSitterApproved ?? this.isSitterApproved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        avatarUrl,
        role,
        isProfileComplete,
        isSitterApproved,
        createdAt,
      ];
}
