import '../utils/referral_parsers.dart';

class ReferralItem {
  final String id;
  final String referralCode;
  final String status;
  final String? referredUserId;
  final String? referredUserName;
  final String? referredUserAvatarUrl;
  final int earnedAmountCents;
  final DateTime? signedUpAt;
  final DateTime? firstJobCompletedAt;
  final DateTime? rewardedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  const ReferralItem({
    required this.id,
    required this.referralCode,
    required this.status,
    required this.referredUserId,
    required this.referredUserName,
    required this.referredUserAvatarUrl,
    required this.earnedAmountCents,
    required this.signedUpAt,
    required this.firstJobCompletedAt,
    required this.rewardedAt,
    required this.expiresAt,
    required this.createdAt,
  });

  factory ReferralItem.fromJson(Map<String, dynamic> json) {
    final referredUserRaw = json['referredUser'];
    String? referredUserId;
    String? referredUserName;
    String? referredUserAvatarUrl;

    if (referredUserRaw is Map<String, dynamic>) {
      referredUserId =
          (referredUserRaw['id'] as String?) ?? (referredUserRaw['_id'] as String?);
      referredUserAvatarUrl = (referredUserRaw['avatarUrl'] as String?) ??
          (referredUserRaw['photoUrl'] as String?) ??
          (referredUserRaw['profilePhotoUrl'] as String?);

      final nameValue = referredUserRaw['fullName'] ?? referredUserRaw['name'];
      if (nameValue is String && nameValue.trim().isNotEmpty) {
        referredUserName = nameValue.trim();
      } else {
        final firstName = referredUserRaw['firstName'] as String?;
        final lastName = referredUserRaw['lastName'] as String?;
        final combinedName = [firstName, lastName]
            .where((part) => part != null && part.trim().isNotEmpty)
            .join(' ');
        if (combinedName.trim().isNotEmpty) {
          referredUserName = combinedName.trim();
        }
      }
    }

    return ReferralItem(
      id: (json['id'] as String?) ?? (json['_id'] as String?) ?? '',
      referralCode: json['referralCode'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      referredUserId: referredUserId,
      referredUserName: referredUserName,
      referredUserAvatarUrl: referredUserAvatarUrl,
      earnedAmountCents: parseIntValue(
        json['earnedAmount'] ?? json['earnedAmountCents'],
      ),
      signedUpAt: _parseDate(json['signedUpAt']),
      firstJobCompletedAt: _parseDate(json['firstJobCompletedAt']),
      rewardedAt: _parseDate(json['rewardedAt']),
      expiresAt: _parseDate(json['expiresAt']),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
