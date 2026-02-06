import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_dto.g.dart';

@JsonSerializable()
class ChatDto {
  final String id;
  @JsonKey(name: 'participant_name')
  final String? participantName;
  @JsonKey(name: 'participant_avatar')
  final String? participantAvatarUrl;
  @JsonKey(name: 'last_message')
  final String? lastMessage;
  @JsonKey(name: 'last_message_type')
  final String? lastMessageType;
  @JsonKey(name: 'last_message_time')
  final String? lastMessageTime;
  @JsonKey(name: 'unread_count')
  final int? unreadCount;
  @JsonKey(name: 'is_verified')
  final bool? isVerified;
  @JsonKey(name: 'is_system')
  final bool? isSystem;

  ChatDto({
    required this.id,
    this.participantName,
    this.participantAvatarUrl,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    this.unreadCount,
    this.isVerified,
    this.isSystem,
  });

  factory ChatDto.fromJson(Map<String, dynamic> json) =>
      _$ChatDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatDtoToJson(this);

  Conversation toDomain() {
    return Conversation(
      id: id,
      participantName: participantName ?? 'Unknown User',
      participantAvatarUrl: participantAvatarUrl,
      lastMessage: lastMessage ?? '',
      lastMessageType: _parseMessageType(lastMessageType),
      lastMessageTime: _parseDate(lastMessageTime),
      unreadCount: unreadCount ?? 0,
      isVerified: isVerified ?? false,
      isSystem: isSystem ?? false,
    );
  }

  MessageType _parseMessageType(String? type) {
    if (type == null) return MessageType.text;
    switch (type.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'call_ended':
      case 'callended':
        return MessageType.callEnded;
      case 'system':
        return MessageType.system;
      case 'image':
        return MessageType.image;
      case 'call_log':
      case 'calllog':
        return MessageType.callLog;
      default:
        return MessageType.text;
    }
  }

  DateTime _parseDate(String? date) {
    if (date == null) return DateTime.now();
    try {
      return DateTime.parse(date);
    } catch (e) {
      print('DEBUG: Error parsing date in ChatDto: $date');
      return DateTime.now();
    }
  }
}
