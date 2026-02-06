import 'referral_item.dart';
import '../utils/referral_parsers.dart';

class ReferralsListResponse {
  final int total;
  final int limit;
  final int offset;
  final List<ReferralItem> referrals;

  const ReferralsListResponse({
    required this.total,
    required this.limit,
    required this.offset,
    required this.referrals,
  });

  factory ReferralsListResponse.fromJson(Map<String, dynamic> json) {
    final referralList = json['referrals'];
    final referrals = <ReferralItem>[];

    if (referralList is List) {
      for (final entry in referralList) {
        if (entry is Map<String, dynamic>) {
          referrals.add(ReferralItem.fromJson(entry));
        }
      }
    }

    return ReferralsListResponse(
      total: parseIntValue(json['total'], defaultValue: referrals.length),
      limit: parseIntValue(json['limit'], defaultValue: referrals.length),
      offset: parseIntValue(json['offset']),
      referrals: referrals,
    );
  }

  const ReferralsListResponse.empty()
      : total = 0,
        limit = 0,
        offset = 0,
        referrals = const [];
}
