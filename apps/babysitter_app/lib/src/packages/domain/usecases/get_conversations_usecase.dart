import 'package:babysitter_app/src/packages/domain/entities/conversation.dart';
import 'package:babysitter_app/src/packages/domain/repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository _repository;

  GetConversationsUseCase(this._repository);

  Future<List<Conversation>> call() {
    return _repository.getConversations();
  }
}
