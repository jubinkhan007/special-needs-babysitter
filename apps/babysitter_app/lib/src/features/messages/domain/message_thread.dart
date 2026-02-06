/// Raw domain model for a message thread/conversation.
class MessageThread {
  final String id;
  final String title;
  final String lastMessage;
  final MessageType lastMessageType;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String? avatarUrl;
  final bool isVerified;
  final bool isSystemThread;

  const MessageThread({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageType,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.avatarUrl,
    this.isVerified = false,
    this.isSystemThread = false,
  });
}

enum MessageType {
  text,
  callEnded,
  system,
  image,
  callLog,
}
