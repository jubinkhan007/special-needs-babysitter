import '../entities/conversation.dart';
import '../entities/chat_message.dart';
import '../entities/chat_init_result.dart';

abstract interface class ChatRepository {
  /// Initialize the Agora Chat system for the current user.
  /// Returns Agora username and token for SDK initialization.
  Future<ChatInitResult> initChat();

  /// Fetches the list of conversations for the current user.
  Future<List<Conversation>> getConversations();

  /// Fetches messages for a specific conversation.
  /// [otherUserId] is the UUID of the other participant.
  Future<List<ChatMessageEntity>> getMessages(String otherUserId);

  /// Sends a text message to another user.
  /// Returns the sent message.
  Future<ChatMessageEntity> sendMessage({
    required String recipientUserId,
    required String text,
  });

  /// Sends a media message (image, video, etc.) to another user.
  /// Returns the sent message.
  Future<ChatMessageEntity> sendMediaMessage({
    required String recipientUserId,
    required String mediaUrl,
    required String mediaType,
    String? text,
  });

  /// Marks a conversation as read.
  Future<void> markAsRead(String otherUserId);
}
