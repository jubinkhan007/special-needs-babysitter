import 'package:babysitter_app/src/packages/domain/auth/entities/registered_user.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/registration_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/otp_send_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/otp_verify_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/uniqueness_check_payload.dart';
import 'package:babysitter_app/src/packages/domain/auth/entities/uniqueness_check_result.dart';
import 'package:babysitter_app/src/packages/domain/entities/auth_session.dart';

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
