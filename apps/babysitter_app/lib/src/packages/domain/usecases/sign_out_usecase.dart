import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Usecase for signing out the current user
class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<void> call(NoParams params) async {
    return _repository.signOut();
  }
}
