import 'package:babysitter_app/src/packages/domain/auth/entities/registered_user.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/registration_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/repositories/registration_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

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
