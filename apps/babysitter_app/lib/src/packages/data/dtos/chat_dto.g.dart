// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDto _$ChatDtoFromJson(Map<String, dynamic> json) => ChatDto(
  id: json['id'] as String,
  participantName: json['participant_name'] as String?,
  participantAvatarUrl: json['participant_avatar'] as String?,
  lastMessage: json['last_message'] as String?,
  lastMessageType: json['last_message_type'] as String?,
  lastMessageTime: json['last_message_time'] as String?,
  unreadCount: (json['unread_count'] as num?)?.toInt(),
  isVerified: json['is_verified'] as bool?,
  isSystem: json['is_system'] as bool?,
);

Map<String, dynamic> _$ChatDtoToJson(ChatDto instance) => <String, dynamic>{
  'id': instance.id,
  'participant_name': instance.participantName,
  'participant_avatar': instance.participantAvatarUrl,
  'last_message': instance.lastMessage,
  'last_message_type': instance.lastMessageType,
  'last_message_time': instance.lastMessageTime,
  'unread_count': instance.unreadCount,
  'is_verified': instance.isVerified,
  'is_system': instance.isSystem,
};
