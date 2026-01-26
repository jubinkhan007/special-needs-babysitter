// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) =>
    ChatMessageDto(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String?,
      senderUserId: json['senderUserId'] as String?,
      recipientUserId: json['recipientUserId'] as String?,
      type: json['type'] as String?,
      textContent: json['textContent'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      status: json['status'] as String?,
      deliveredAt: json['deliveredAt'] as String?,
      readAt: json['readAt'] as String?,
      agoraMessageId: json['agoraMessageId'] as String?,
      syncedFromAgora: json['syncedFromAgora'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ChatMessageDtoToJson(ChatMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderUserId': instance.senderUserId,
      'recipientUserId': instance.recipientUserId,
      'type': instance.type,
      'textContent': instance.textContent,
      'mediaUrl': instance.mediaUrl,
      'status': instance.status,
      'deliveredAt': instance.deliveredAt,
      'readAt': instance.readAt,
      'agoraMessageId': instance.agoraMessageId,
      'syncedFromAgora': instance.syncedFromAgora,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
