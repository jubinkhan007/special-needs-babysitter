import '../entities/registered_user.dart';
import '../entities/registration_payload.dart';
import '../entities/otp_send_payload.dart';
import '../repositories/registration_repository.dart';
import '../../usecases/usecase.dart';

/// Combined use case: register user then send OTP (sequential)
/// Returns RegisteredUser on success, throws on any failure
class RegisterAndSendOtpUseCase
    implements UseCase<RegisteredUser, RegistrationPayload> {
  final RegistrationRepository _repository;

  RegisterAndSendOtpUseCase(this._repository);

  @override
  Future<RegisteredUser> call(RegistrationPayload params) async {
    // Step 1: Register user
    final user = await _repository.register(params);

    // Step 2: Send OTP (only if register succeeds)
    await _repository.sendOtp(OtpSendPayload(userId: user.id));

    return user;
  }
}
