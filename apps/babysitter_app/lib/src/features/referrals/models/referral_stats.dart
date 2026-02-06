import '../utils/referral_parsers.dart';

class ReferralStats {
  final int totalReferrals;
  final int pending;
  final int completed;
  final int rewarded;
  final int expired;
  final int totalEarnedCents;

  const ReferralStats({
    required this.totalReferrals,
    required this.pending,
    required this.completed,
    required this.rewarded,
    required this.expired,
    required this.totalEarnedCents,
  });

  factory ReferralStats.fromJson(Map<String, dynamic> json) {
    return ReferralStats(
      totalReferrals: parseIntValue(json['totalReferrals']),
      pending: parseIntValue(json['pending']),
      completed: parseIntValue(json['completed']),
      rewarded: parseIntValue(json['rewarded']),
      expired: parseIntValue(json['expired']),
      totalEarnedCents: parseIntValue(json['totalEarned']),
    );
  }
}
