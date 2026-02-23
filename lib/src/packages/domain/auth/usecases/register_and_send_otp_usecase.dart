import 'package:babysitter_app/src/packages/domain/auth/entities/registered_user.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/registration_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/otp_send_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/repositories/registration_repository.dart';
import 'package:babysitter_app/src/packages/domain/usecases/usecase.dart';

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
