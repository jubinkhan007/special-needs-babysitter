import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable()
class ChatMessageDto {
  final String id;
  final String? conversationId;
  final String? senderUserId;
  final String? recipientUserId;
  final String? type;
  final String? textContent;
  final String? mediaUrl;
  final String? status;
  final String? deliveredAt;
  final String? readAt;
  final String? agoraMessageId;
  final bool? syncedFromAgora;
  final String? createdAt;
  final String? updatedAt;

  ChatMessageDto({
    required this.id,
    this.conversationId,
    this.senderUserId,
    this.recipientUserId,
    this.type,
    this.textContent,
    this.mediaUrl,
    this.status,
    this.deliveredAt,
    this.readAt,
    this.agoraMessageId,
    this.syncedFromAgora,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    final senderUserId = _stringFromJson(json['senderUserId']) ??
        _stringFromJson(json['senderId']) ??
        _stringFromJson(json['fromUserId']) ??
        _stringFromJson(json['from']) ??
        _stringFromJson(_extractId(json['sender'])) ??
        _stringFromJson(_extractId(json['fromUser']));
    final recipientUserId = _stringFromJson(json['recipientUserId']) ??
        _stringFromJson(json['recipientId']) ??
        _stringFromJson(json['toUserId']) ??
        _stringFromJson(json['to']) ??
        _stringFromJson(_extractId(json['recipient'])) ??
        _stringFromJson(_extractId(json['toUser']));
    final textContent = _stringFromJson(json['textContent']) ??
        _stringFromJson(json['text']) ??
        _stringFromJson(json['message']) ??
        _stringFromJson(json['content']);
    final messageType = _stringFromJson(json['type']) ??
        _stringFromJson(json['messageType']);
    final messageStatus = _stringFromJson(json['status']) ??
        _stringFromJson(json['messageStatus']);
    final messageId = _stringFromJson(json['id']) ??
        _stringFromJson(json['messageId']) ??
        _stringFromJson(json['agoraMessageId']) ??
        '';

    return ChatMessageDto(
      id: messageId,
      conversationId: _stringFromJson(json['conversationId']),
      senderUserId: senderUserId,
      recipientUserId: recipientUserId,
      type: messageType,
      textContent: textContent,
      mediaUrl: _stringFromJson(json['mediaUrl']),
      status: messageStatus,
      deliveredAt: _stringFromJson(json['deliveredAt']),
      readAt: _stringFromJson(json['readAt']),
      agoraMessageId: _stringFromJson(json['agoraMessageId']),
      syncedFromAgora: json['syncedFromAgora'] as bool?,
      createdAt: _stringFromJson(json['createdAt']),
      updatedAt: _stringFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);

  ChatMessageEntity toDomain() {
    final resolvedId = id.isNotEmpty
        ? id
        : (agoraMessageId?.isNotEmpty == true
            ? agoraMessageId!
            : '${senderUserId ?? 'unknown'}-${createdAt ?? DateTime.now().toIso8601String()}');
    return ChatMessageEntity(
      id: resolvedId,
      conversationId: conversationId ?? '',
      senderUserId: senderUserId ?? '',
      recipientUserId: recipientUserId ?? '',
      type: _parseMessageType(type),
      textContent: textContent,
      mediaUrl: mediaUrl,
      status: _parseMessageStatus(status),
      deliveredAt: _parseDate(deliveredAt),
      readAt: _parseDate(readAt),
      agoraMessageId: agoraMessageId,
      syncedFromAgora: syncedFromAgora ?? false,
      createdAt: _parseDate(createdAt) ?? DateTime.now(),
      updatedAt: _parseDate(updatedAt) ?? DateTime.now(),
    );
  }

  ChatMessageType _parseMessageType(String? type) {
    if (type == null) return ChatMessageType.text;
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

  ChatMessageStatus _parseMessageStatus(String? status) {
    if (status == null) return ChatMessageStatus.sent;
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

  static String? _stringFromJson(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      final text = value['text'] ?? value['textContent'];
      return text is String ? text : null;
    }
    return value.toString();
  }

  static dynamic _extractId(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['id'];
    }
    return null;
  }
}
