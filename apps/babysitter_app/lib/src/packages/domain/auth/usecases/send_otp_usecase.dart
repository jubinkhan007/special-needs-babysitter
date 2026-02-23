import 'package:babysitter_app/src/packages/domain/auth/entities/otp_send_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/repositories/registration_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

/// Use case for sending OTP
class SendOtpUseCase implements UseCase<void, OtpSendPayload> {
  final RegistrationRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<void> call(OtpSendPayload params) {
    return _repository.sendOtp(params);
  }
}
