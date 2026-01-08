/// User returned from registration API
class RegisteredUser {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? middleInitial;
  final String phone;
  final String role;
  final bool phoneVerified;
  final bool emailVerified;
  final DateTime? createdAt;

  const RegisteredUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.middleInitial,
    required this.phone,
    required this.role,
    this.phoneVerified = false,
    this.emailVerified = false,
    this.createdAt,
  });
}
