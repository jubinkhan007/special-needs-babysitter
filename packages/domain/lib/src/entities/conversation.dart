import 'package:equatable/equatable.dart';

import 'message_type.dart';

class Conversation extends Equatable {
  final String id;
  final String participantName;
  final String? participantAvatarUrl;
  final String lastMessage;
  final MessageType lastMessageType;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isVerified;
  final bool isSystem;

  const Conversation({
    required this.id,
    required this.participantName,
    this.participantAvatarUrl,
    required this.lastMessage,
    required this.lastMessageType,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isVerified = false,
    this.isSystem = false,
  });

  @override
  List<Object?> get props => [
        id,
        participantName,
        participantAvatarUrl,
        lastMessage,
        lastMessageType,
        lastMessageTime,
        unreadCount,
        isVerified,
        isSystem,
      ];
}
