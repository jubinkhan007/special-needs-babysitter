import '../entities/registered_user.dart';
import '../entities/registration_payload.dart';
import '../entities/otp_send_payload.dart';
import '../entities/otp_verify_payload.dart';
import '../entities/uniqueness_check_payload.dart';
import '../entities/uniqueness_check_result.dart';
import '../../entities/auth_session.dart';

/// Contract for registration-related auth operations
/// Separate from main AuthRepository to follow Single Responsibility
abstract interface class RegistrationRepository {
  /// Register a new user
  Future<RegisteredUser> register(RegistrationPayload payload);

  /// Send OTP for phone verification
  Future<void> sendOtp(OtpSendPayload payload);

  /// Get list of security questions
  Future<List<String>> getSecurityQuestions();

  /// Check if email/phone are unique
  Future<UniquenessCheckResult> checkUniqueness(
    UniquenessCheckPayload payload,
  );

  /// Verify OTP and get session
  Future<AuthSession> verifyOtp(OtpVerifyPayload payload);
}
