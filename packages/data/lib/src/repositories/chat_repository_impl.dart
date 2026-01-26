import 'package:domain/domain.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChatInitResult> initChat() async {
    final dto = await _remoteDataSource.initChat();
    return dto.toDomain();
  }

  @override
  Future<List<Conversation>> getConversations() async {
    final dtos = await _remoteDataSource.getConversations();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getMessages(String otherUserId) async {
    final dtos = await _remoteDataSource.getMessages(otherUserId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<ChatMessageEntity> sendMessage({
    required String recipientUserId,
    required String text,
  }) async {
    final dto = await _remoteDataSource.sendMessage(
      recipientUserId: recipientUserId,
      text: text,
    );
    return dto.toDomain();
  }

  @override
  Future<ChatMessageEntity> sendMediaMessage({
    required String recipientUserId,
    required String mediaUrl,
    required String mediaType,
    String? text,
  }) async {
    final dto = await _remoteDataSource.sendMediaMessage(
      recipientUserId: recipientUserId,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      text: text,
    );
    return dto.toDomain();
  }

  @override
  Future<void> markAsRead(String otherUserId) async {
    await _remoteDataSource.markAsRead(otherUserId);
  }
}
