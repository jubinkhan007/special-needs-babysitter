/// Notification category derived from notification type.
enum NotificationCategory {
  jobs,
  payments,
  rewards,
}

/// Domain model for an in-app notification.
class NotificationItem {
  final String id;
  final String type;
  final String status;
  final String title;
  final String body;
  final NotificationCategory category;
  final String? actionUserName;
  final String? actionUserAvatar;
  final Map<String, dynamic> data;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.body,
    required this.category,
    this.actionUserName,
    this.actionUserAvatar,
    this.data = const {},
    this.readAt,
    required this.createdAt,
  });

  bool get isUnread => readAt == null;

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? '';

    // Parse actionUser nested object
    final actionUserRaw = json['actionUser'];
    String? actionUserName;
    String? actionUserAvatar;
    if (actionUserRaw is Map<String, dynamic>) {
      final firstName = actionUserRaw['firstName'] as String? ?? '';
      final lastName = actionUserRaw['lastName'] as String? ?? '';
      final fullName = '$firstName $lastName'.trim();
      actionUserName = fullName.isNotEmpty
          ? fullName
          : (actionUserRaw['name'] as String?) ??
              (actionUserRaw['fullName'] as String?);
      actionUserAvatar = (actionUserRaw['avatarUrl'] as String?) ??
          (actionUserRaw['photoUrl'] as String?) ??
          (actionUserRaw['profilePhotoUrl'] as String?);
    }

    return NotificationItem(
      id: (json['id'] as String?) ?? (json['_id'] as String?) ?? '',
      type: type,
      status: json['status'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      category: _categoryFromType(type),
      actionUserName: actionUserName,
      actionUserAvatar: actionUserAvatar,
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : const {},
      readAt: _parseDate(json['readAt']),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }

  static NotificationCategory _categoryFromType(String type) {
    const paymentTypes = {
      'payment_received',
      'withdrawal_completed',
      'withdrawal_failed',
      'refund_received',
    };
    const rewardTypes = {
      'referral_bonus',
      'welcome_bonus',
    };

    if (paymentTypes.contains(type)) return NotificationCategory.payments;
    if (rewardTypes.contains(type)) return NotificationCategory.rewards;
    return NotificationCategory.jobs;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
