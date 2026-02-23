import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Parameters for sign in usecase
class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

/// Usecase for signing in a user
class SignInUseCase implements UseCase<AuthSession, SignInParams> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<AuthSession> call(SignInParams params) async {
    return _repository.signIn(email: params.email, password: params.password);
  }
}
