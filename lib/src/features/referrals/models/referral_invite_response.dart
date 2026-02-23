class ReferralInviteResponse {
  final bool success;
  final String? message;
  final String? referralCode;

  const ReferralInviteResponse({
    required this.success,
    this.message,
    this.referralCode,
  });

  factory ReferralInviteResponse.fromJson(Map<String, dynamic> json) {
    return ReferralInviteResponse(
      success: json['success'] == true,
      message: json['message'] as String?,
      referralCode: json['referralCode'] as String?,
    );
  }
}
