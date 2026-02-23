class SupportChatUiModel {
  final String id;
  final String text;
  final String metaText; // "Support • 4:27 PM" or "4:27 PM • You"
  final bool isSupport; // Derived from senderType
  final bool isMe;
  final bool showAvatar; // Logic for grouping
  final String? userAvatarUrl; // Only if isMe

  const SupportChatUiModel({
    required this.id,
    required this.text,
    required this.metaText,
    required this.isSupport,
    required this.isMe,
    required this.showAvatar,
    this.userAvatarUrl,
  });
}
