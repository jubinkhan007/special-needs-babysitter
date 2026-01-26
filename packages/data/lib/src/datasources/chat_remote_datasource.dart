import 'package:dio/dio.dart';
import '../dtos/chat_dto.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ChatDto>> getConversations();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ChatDto>> getConversations() async {
    try {
      final response = await _dio.get('/chat/conversations');
      // Assuming standard response structure: { "data": [ ... ] }
      
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
}