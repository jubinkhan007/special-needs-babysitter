import '../entities/auth_session.dart';
import '../entities/user_role.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Parameters for sign up usecase
class SignUpParams {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final UserRole role;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.role,
  });
}

/// Usecase for signing up a new user
class SignUpUseCase implements UseCase<AuthSession, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<AuthSession> call(SignUpParams params) async {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      role: params.role,
    );
  }
}
