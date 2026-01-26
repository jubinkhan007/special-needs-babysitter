import 'package:domain/domain.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Conversation>> getConversations() async {
    final dtos = await _remoteDataSource.getConversations();
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
