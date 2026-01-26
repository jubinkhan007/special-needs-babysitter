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

      if (response.data == null) {
        print('DEBUG: Chat API returned null data');
        return [];
      }

      final data = response.data['data'];
      if (data == null) {
        print('DEBUG: Chat API response missing "data" field: ${response.data}');
        return [];
      }

      if (data is! List) {
         print('DEBUG: Chat API "data" field is not a List: $data');
         return [];
      }

      return data.map((json) {
        try {
          return ChatDto.fromJson(json as Map<String, dynamic>);
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
        return ChatMessageDto.fromJson(json as Map<String, dynamic>);
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
      return ChatMessageDto.fromJson(data as Map<String, dynamic>);
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
      return ChatMessageDto.fromJson(data as Map<String, dynamic>);
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