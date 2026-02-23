class ReferralGenerateResponse {
  final String referralCode;
  final String shareUrl;

  const ReferralGenerateResponse({
    required this.referralCode,
    required this.shareUrl,
  });

  factory ReferralGenerateResponse.fromJson(Map<String, dynamic> json) {
    return ReferralGenerateResponse(
      referralCode: (json['referralCode'] as String?)?.trim() ?? '',
      shareUrl: (json['shareUrl'] as String?)?.trim() ?? '',
    );
  }
}
