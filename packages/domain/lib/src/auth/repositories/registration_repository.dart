import '../entities/registered_user.dart';
import '../entities/registration_payload.dart';
import '../entities/otp_send_payload.dart';

/// Contract for registration-related auth operations
/// Separate from main AuthRepository to follow Single Responsibility
abstract interface class RegistrationRepository {
  /// Register a new user
  Future<RegisteredUser> register(RegistrationPayload payload);

  /// Send OTP for phone verification
  Future<void> sendOtp(OtpSendPayload payload);

  /// Get list of security questions
  Future<List<String>> getSecurityQuestions();
}
