import 'package:dio/dio.dart';
import '../dtos/chat_dto.dart';
import '../dtos/chat_message_dto.dart';
import '../dtos/chat_init_dto.dart';

abstract interface class ChatRemoteDataSource {
  /// POST /chat/init - Initialize Agora Chat
  Future<ChatInitDto> initChat();

  /// GET /chat/conversations - Get all conversations
  Future<List<ChatDto>> getConversations();

  /// GET /chat/messages - Get messages for a conversation
  Future<List<ChatMessageDto>> getMessages(String otherUserId);

  /// POST /chat/messages - Send a text message
  Future<ChatMessageDto> sendMessage({
    required String recipientUserId,
    required String text,
  });

  /// POST /chat/messages/media - Send a media message
  Future<ChatMessageDto> sendMediaMessage({
    required String recipientUserId,
    required String mediaUrl,
    required String mediaType,
    String? text,
  });

  /// POST /chat/read - Mark conversation as read
  Future<void> markAsRead(String otherUserId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  @override
  Future<ChatInitDto> initChat() async {
    try {
      print('DEBUG: ChatRemoteDataSource.initChat()');
      final response = await _dio.post('/chat/init');

      if (response.data == null) {
        throw Exception('Chat init returned null data');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('Chat init response missing "data" field');
      }

      print('DEBUG: Chat init response: $data');
      return ChatInitDto.fromJson(data as Map<String, dynamic>);
    } catch (e, stack) {
      print('DEBUG: Error initializing chat: $e');
      print('DEBUG: Stack trace: $stack');
      if (e is DioException) {
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<List<ChatDto>> getConversations() async {
    try {
      final response = await _dio.get('/chat/conversations');
      print('DEBUG: Chat conversations raw response: ${response.data}');

      if (response.data == null) {
        print('DEBUG: Chat API returned null data');
        return [];
      }

      final data = response.data['data'];
      if (data == null) {
        print('DEBUG: Chat API response missing "data" field: ${response.data}');
        return [];
      }

      final List<dynamic>? rawList = data is List
          ? data
          : (data is Map<String, dynamic> ? data['conversations'] as List? : null);

      if (rawList == null) {
        print('DEBUG: Chat API "data" field has no conversations list: $data');
        return [];
      }

      return rawList.map((json) {
        try {
          final normalized = _normalizeConversationJson(json);
          return ChatDto.fromJson(normalized);
        } catch (e, stack) {
          print('DEBUG: Error parsing chat item: $json, error: $e, stack: $stack');
          rethrow;
        }
      }).toList();
    } catch (e, stack) {
      print('DEBUG: Error fetching conversations: $e');
      print('DEBUG: Stack trace: $stack');
      if (e is DioException) {
        print('DEBUG: Dio Error Type: ${e.type}');
        print('DEBUG: Dio Error Message: ${e.message}');
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Map<String, dynamic> _normalizeConversationJson(Object? json) {
    final raw = json is Map<String, dynamic> ? json : <String, dynamic>{};
    final otherUser = raw['otherUser'] is Map<String, dynamic>
        ? raw['otherUser'] as Map<String, dynamic>
        : const <String, dynamic>{};

    final firstName = otherUser['firstName']?.toString() ??
        otherUser['first_name']?.toString() ??
        '';
    final lastName = otherUser['lastName']?.toString() ??
        otherUser['last_name']?.toString() ??
        '';
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    final otherUserId = otherUser['_id']?.toString() ??
        otherUser['id']?.toString() ??
        otherUser['userId']?.toString() ??
        otherUser['user_id']?.toString();
    final avatarUrl = otherUser['avatarUrl'] ??
        otherUser['profilePhoto'] ??
        otherUser['profilePhotoUrl'] ??
        otherUser['photoUrl'] ??
        otherUser['photoURL'] ??
        otherUser['photo_url'] ??
        otherUser['imageUrl'] ??
        otherUser['profileImageUrl'];
    final displayName = raw['participant_name']?.toString() ??
        (fullName.isNotEmpty
            ? fullName
            : (otherUser['name']?.toString() ??
                otherUser['fullName']?.toString() ??
                'Unknown User'));

    final participantAvatar = _firstNonEmpty(
      raw['participant_avatar'],
      avatarUrl,
    );

    return {
      'id': otherUserId ?? raw['id']?.toString() ?? raw['_id']?.toString() ?? '',
      'participant_name': displayName,
      'participant_avatar': participantAvatar,
      'last_message': raw['last_message']?.toString() ??
          raw['lastMessagePreview']?.toString() ??
          '',
      'last_message_type': raw['last_message_type']?.toString(),
      'last_message_time': raw['last_message_time']?.toString() ??
          raw['lastMessageAt']?.toString(),
      'unread_count': raw['unread_count'] ?? raw['unreadCount'] ?? 0,
      'is_verified': raw['is_verified'] ?? otherUser['isVerified'] ?? false,
      'is_system': raw['is_system'] ?? false,
    };
  }

  @override
  Future<List<ChatMessageDto>> getMessages(String otherUserId) async {
    try {
      print('DEBUG: ChatRemoteDataSource.getMessages($otherUserId)');
      final response = await _dio.get(
        '/chat/messages',
        queryParameters: {'otherUserId': otherUserId},
      );

      if (response.data == null) {
        print('DEBUG: getMessages returned null data');
        return [];
      }

      final data = response.data['data'];
      if (data == null) {
        print('DEBUG: getMessages response missing "data" field');
        return [];
      }

      final messages = data['messages'] as List?;
      if (messages == null) {
        print('DEBUG: getMessages response missing "messages" field');
        return [];
      }

      print('DEBUG: Got ${messages.length} messages');
      return messages.map((json) {
        final safeJson = _normalizeMessageJson(json);
        return ChatMessageDto.fromJson(safeJson);
      }).toList();
    } catch (e, stack) {
      print('DEBUG: Error fetching messages: $e');
      print('DEBUG: Stack trace: $stack');
      if (e is DioException) {
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Map<String, dynamic> _normalizeMessageJson(Object? json) {
    final raw = json is Map<String, dynamic> ? json : <String, dynamic>{};
    final wrapperMessage = raw['message'];
    final wrapperContent = raw['content'];
    final inner = wrapperMessage is Map<String, dynamic>
        ? wrapperMessage
        : (wrapperContent is Map<String, dynamic> && _looksLikeMessage(wrapperContent)
            ? wrapperContent
            : raw);
    final safe = Map<String, dynamic>.from(inner);

    if (safe['senderUserId'] == null && safe['senderUser'] is Map<String, dynamic>) {
      safe['senderUserId'] = (safe['senderUser'] as Map<String, dynamic>)['id'];
    }
    if (safe['recipientUserId'] == null && safe['recipientUser'] is Map<String, dynamic>) {
      safe['recipientUserId'] = (safe['recipientUser'] as Map<String, dynamic>)['id'];
    }

    if (safe['textContent'] == null && safe['text'] != null) {
      safe['textContent'] = safe['text'];
    }

    if (safe['textContent'] is Map<String, dynamic>) {
      final textMap = safe['textContent'] as Map<String, dynamic>;
      safe['textContent'] = textMap['text'] ?? textMap['textContent'];
    }

    if (safe['id'] == null || safe['id'].toString().isEmpty) {
      final mongoId = safe['_id']?.toString();
      if (mongoId != null && mongoId.isNotEmpty) {
        safe['id'] = mongoId;
      }
    }

    if (safe['id'] == null || safe['id'].toString().isEmpty) {
      final fallbackId = safe['agoraMessageId']?.toString();
      safe['id'] = (fallbackId != null && fallbackId.isNotEmpty)
          ? fallbackId
          : '';
    }

    if (safe['conversationId'] == null && safe['conversation'] != null) {
      safe['conversationId'] = safe['conversation'].toString();
    }

    return safe;
  }

  bool _looksLikeMessage(Map<String, dynamic> value) {
    return value.containsKey('textContent') ||
        value.containsKey('senderUserId') ||
        value.containsKey('recipientUserId') ||
        value.containsKey('_id') ||
        value.containsKey('id');
  }

  String? _firstNonEmpty(dynamic primary, dynamic fallback) {
    final primaryStr = primary?.toString().trim();
    if (primaryStr != null && primaryStr.isNotEmpty) {
      return primaryStr;
    }
    final fallbackStr = fallback?.toString().trim();
    if (fallbackStr != null && fallbackStr.isNotEmpty) {
      return fallbackStr;
    }
    return null;
  }

  @override
  Future<ChatMessageDto> sendMessage({
    required String recipientUserId,
    required String text,
  }) async {
    try {
      print('DEBUG: ChatRemoteDataSource.sendMessage to $recipientUserId');
      final response = await _dio.post(
        '/chat/messages',
        data: {
          'recipientUserId': recipientUserId,
          'text': text,
        },
      );

      if (response.data == null) {
        throw Exception('sendMessage returned null data');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('sendMessage response missing "data" field');
      }

      print('DEBUG: Message sent successfully');
      final safeJson = _normalizeMessageJson(data);
      return ChatMessageDto.fromJson(safeJson);
    } catch (e, stack) {
      print('DEBUG: Error sending message: $e');
      print('DEBUG: Stack trace: $stack');
      if (e is DioException) {
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<ChatMessageDto> sendMediaMessage({
    required String recipientUserId,
    required String mediaUrl,
    required String mediaType,
    String? text,
  }) async {
    try {
      print('DEBUG: ChatRemoteDataSource.sendMediaMessage to $recipientUserId');
      final response = await _dio.post(
        '/chat/messages/media',
        data: {
          'recipientUserId': recipientUserId,
          'mediaUrl': mediaUrl,
          'mediaType': mediaType,
          if (text != null) 'text': text,
        },
      );

      if (response.data == null) {
        throw Exception('sendMediaMessage returned null data');
      }

      final data = response.data['data'];
      if (data == null) {
        throw Exception('sendMediaMessage response missing "data" field');
      }

      print('DEBUG: Media message sent successfully');
      final safeJson = _normalizeMessageJson(data);
      return ChatMessageDto.fromJson(safeJson);
    } catch (e, stack) {
      print('DEBUG: Error sending media message: $e');
      print('DEBUG: Stack trace: $stack');
      if (e is DioException) {
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String otherUserId) async {
    try {
      print('DEBUG: ChatRemoteDataSource.markAsRead($otherUserId)');
      await _dio.post(
        '/chat/read',
        data: {'otherUserId': otherUserId},
      );
      print('DEBUG: Conversation marked as read');
    } catch (e, stack) {
      print('DEBUG: Error marking as read: $e');
      print('DEBUG: Stack trace: $stack');
      if (e is DioException) {
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
