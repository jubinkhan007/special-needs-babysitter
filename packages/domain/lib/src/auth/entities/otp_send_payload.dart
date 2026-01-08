/// Payload for sending OTP
/// API: POST /auth/otp/send
/// Schema confirmed from docs: { "userId": "" }
class OtpSendPayload {
  final String userId;

  const OtpSendPayload({required this.userId});

  Map<String, dynamic> toJson() => {'userId': userId};
}
