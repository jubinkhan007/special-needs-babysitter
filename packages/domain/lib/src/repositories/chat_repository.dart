import '../entities/conversation.dart';

abstract interface class ChatRepository {
  /// Fetches the list of conversations for the current user.
  Future<List<Conversation>> getConversations();
}
