import '../../entities/auth_session.dart';
import '../entities/otp_verify_payload.dart';
import '../repositories/registration_repository.dart';
import '../../usecases/usecase.dart';

class VerifyOtpUseCase implements UseCase<AuthSession, OtpVerifyPayload> {
  final RegistrationRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<AuthSession> call(OtpVerifyPayload params) {
    return _repository.verifyOtp(params);
  }
}
