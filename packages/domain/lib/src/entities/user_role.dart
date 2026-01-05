/// User role in the application
/// Selected at signup and cannot be changed later
enum UserRole {
  /// Parent/Family looking for sitters
  parent,

  /// Babysitter offering services
  sitter,
}

extension UserRoleX on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.sitter:
        return 'Babysitter';
    }
  }

  String get description {
    switch (this) {
      case UserRole.parent:
        return 'Find trusted babysitters for your family';
      case UserRole.sitter:
        return 'Connect with families who need your help';
    }
  }
}
