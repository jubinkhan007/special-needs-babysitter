import '../entities/uniqueness_check_payload.dart';
import '../entities/uniqueness_check_result.dart';
import '../repositories/registration_repository.dart';
import '../../usecases/usecase.dart';

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
