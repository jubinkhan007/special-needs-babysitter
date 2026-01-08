/// Registration payload for sign-up API
class RegistrationPayload {
  final String email;
  final String password;
  final String firstName;
  final String? middleInitial;
  final String lastName;
  final String phone;
  final String role; // "parent" | "sitter"
  final String securityQuestion;
  final String securityAnswer;

  const RegistrationPayload({
    required this.email,
    required this.password,
    required this.firstName,
    this.middleInitial,
    required this.lastName,
    required this.phone,
    required this.role,
    required this.securityQuestion,
    required this.securityAnswer,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'middleInitial': middleInitial ?? '',
        'lastName': lastName,
        'phone': phone,
        'role': role,
        'securityQuestion': securityQuestion,
        'securityAnswer': securityAnswer,
      };
}
