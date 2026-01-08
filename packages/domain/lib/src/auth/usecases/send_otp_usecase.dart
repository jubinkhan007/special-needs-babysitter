import '../entities/otp_send_payload.dart';
import '../repositories/registration_repository.dart';
import '../../usecases/usecase.dart';

/// Use case for sending OTP
class SendOtpUseCase implements UseCase<void, OtpSendPayload> {
  final RegistrationRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<void> call(OtpSendPayload params) {
    return _repository.sendOtp(params);
  }
}
