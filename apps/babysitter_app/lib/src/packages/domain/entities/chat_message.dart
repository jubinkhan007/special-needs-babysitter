import 'package:equatable/equatable.dart';

/// Represents a chat message in a conversation
class ChatMessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderUserId;
  final String recipientUserId;
  final ChatMessageType type;
  final String? textContent;
  final String? mediaUrl;
  final ChatMessageStatus status;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final String? agoraMessageId;
  final bool syncedFromAgora;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderUserId,
    required this.recipientUserId,
    required this.type,
    this.textContent,
    this.mediaUrl,
    required this.status,
    this.deliveredAt,
    this.readAt,
    this.agoraMessageId,
    this.syncedFromAgora = false,
    required this.createdAt,
    required this.updatedAt,
  });

  bool isFromMe(String currentUserId) => senderUserId == currentUserId;

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderUserId,
        recipientUserId,
        type,
        textContent,
        mediaUrl,
        status,
        deliveredAt,
        readAt,
        agoraMessageId,
        syncedFromAgora,
        createdAt,
        updatedAt,
      ];
}

enum ChatMessageType {
  text,
  image,
  video,
  audio,
  file,
}

enum ChatMessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}
