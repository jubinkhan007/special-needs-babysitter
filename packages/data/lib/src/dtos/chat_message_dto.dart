import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable()
class ChatMessageDto {
  final String id;
  final String conversationId;
  final String senderUserId;
  final String recipientUserId;
  final String type;
  final String? textContent;
  final String? mediaUrl;
  final String status;
  final String? deliveredAt;
  final String? readAt;
  final String? agoraMessageId;
  final bool? syncedFromAgora;
  final String createdAt;
  final String updatedAt;

  ChatMessageDto({
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
    this.syncedFromAgora,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);

  ChatMessageEntity toDomain() {
    return ChatMessageEntity(
      id: id,
      conversationId: conversationId,
      senderUserId: senderUserId,
      recipientUserId: recipientUserId,
      type: _parseMessageType(type),
      textContent: textContent,
      mediaUrl: mediaUrl,
      status: _parseMessageStatus(status),
      deliveredAt: _parseDate(deliveredAt),
      readAt: _parseDate(readAt),
      agoraMessageId: agoraMessageId,
      syncedFromAgora: syncedFromAgora ?? false,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  ChatMessageType _parseMessageType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return ChatMessageType.text;
      case 'image':
        return ChatMessageType.image;
      case 'video':
        return ChatMessageType.video;
      case 'audio':
        return ChatMessageType.audio;
      case 'file':
        return ChatMessageType.file;
      default:
        return ChatMessageType.text;
    }
  }

  ChatMessageStatus _parseMessageStatus(String status) {
    switch (status.toLowerCase()) {
      case 'sending':
        return ChatMessageStatus.sending;
      case 'sent':
        return ChatMessageStatus.sent;
      case 'delivered':
        return ChatMessageStatus.delivered;
      case 'read':
        return ChatMessageStatus.read;
      case 'failed':
        return ChatMessageStatus.failed;
      default:
        return ChatMessageStatus.sent;
    }
  }

  DateTime? _parseDate(String? date) {
    if (date == null || date.isEmpty) return null;
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }
}
