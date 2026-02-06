class ReferralValidateResponse {
  final bool valid;
  final String? referralCode;
  final String? message;

  const ReferralValidateResponse({
    required this.valid,
    this.referralCode,
    this.message,
  });

  factory ReferralValidateResponse.fromJson(Map<String, dynamic> json) {
    return ReferralValidateResponse(
      valid: json['valid'] == true,
      referralCode: json['referralCode'] as String?,
      message: json['message'] as String?,
    );
  }
}
