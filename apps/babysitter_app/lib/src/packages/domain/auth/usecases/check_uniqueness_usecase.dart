import 'package:babysitter_app/src/packages/domain/auth/entities/uniqueness_check_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/uniqueness_check_result.dart';
import 'package:babysitter_app/src/packages/domain/auth/repositories/registration_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

/// Use case for checking email/phone uniqueness during sign-up
class CheckUniquenessUseCase
    implements UseCase<UniquenessCheckResult, UniquenessCheckPayload> {
  final RegistrationRepository _repository;

  CheckUniquenessUseCase(this._repository);

  @override
  Future<UniquenessCheckResult> call(UniquenessCheckPayload params) {
    return _repository.checkUniqueness(params);
  }
}
