/// Type of chat message content.
enum ChatMessageType {
  text,
  callLog,
}

/// Type of call for log messages.
enum CallType {
  voice,
  video,
}

/// Status of the call.
enum CallStatus {
  completed,
  missed,
}

/// Type of sender (user vs support vs system)
enum ChatMessageSenderType {
  user,
  support,
  system,
}

/// Domain model for a single chat message.
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final ChatMessageSenderType senderType; // New field
  final bool isMe;
  final ChatMessageType type;
  final String? text;
  final CallType? callType;
  final CallStatus? callStatus;
  final Duration? duration;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    this.senderType = ChatMessageSenderType.user, // Default for backward compat
    required this.isMe,
    required this.type,
    this.text,
    this.callType,
    this.callStatus,
    this.duration,
    required this.createdAt,
  });

  // Factory for text message
  factory ChatMessage.text({
    required String id,
    required String senderId,
    required String senderName,
    String? senderAvatarUrl,
    ChatMessageSenderType senderType = ChatMessageSenderType.user,
    required bool isMe,
    required String text,
    required DateTime createdAt,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderAvatarUrl: senderAvatarUrl,
      senderType: senderType,
      isMe: isMe,
      type: ChatMessageType.text,
      text: text,
      createdAt: createdAt,
    );
  }

  // Factory for call log
  factory ChatMessage.callLog({
    required String id,
    required String senderId,
    required String senderName,
    required bool isMe,
    required CallType callType,
    required CallStatus callStatus,
    Duration? duration,
    required DateTime createdAt,
  }) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderType: ChatMessageSenderType.user, // Calls usually user-to-user
      isMe: isMe,
      type: ChatMessageType.callLog,
      callType: callType,
      callStatus: callStatus,
      duration: duration,
      createdAt: createdAt,
    );
  }
}
