import '../entities/registered_user.dart';
import '../entities/registration_payload.dart';
import '../repositories/registration_repository.dart';
import '../../usecases/usecase.dart';

/// Use case for registering a new user
class RegisterUserUseCase
    implements UseCase<RegisteredUser, RegistrationPayload> {
  final RegistrationRepository _repository;

  RegisterUserUseCase(this._repository);

  @override
  Future<RegisteredUser> call(RegistrationPayload params) {
    return _repository.register(params);
  }
}
