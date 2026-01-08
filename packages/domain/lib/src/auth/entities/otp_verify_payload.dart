class OtpVerifyPayload {
  final String? email;
  final String? phone;
  final String? userId; // Added userId
  final String code;

  const OtpVerifyPayload({
    this.email,
    this.phone,
    this.userId,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'otp': code,
    };
  }
}
