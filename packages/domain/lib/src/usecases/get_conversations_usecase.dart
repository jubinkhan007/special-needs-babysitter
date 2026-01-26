import '../entities/conversation.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository _repository;

  GetConversationsUseCase(this._repository);

  Future<List<Conversation>> call() {
    return _repository.getConversations();
  }
}
