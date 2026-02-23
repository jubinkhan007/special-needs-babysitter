import 'package:babysitter_app/src/packages/domain/entities/auth_session.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/otp_verify_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/repositories/registration_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

class VerifyOtpUseCase implements UseCase<AuthSession, OtpVerifyPayload> {
  final RegistrationRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<AuthSession> call(OtpVerifyPayload params) {
    return _repository.verifyOtp(params);
  }
}
