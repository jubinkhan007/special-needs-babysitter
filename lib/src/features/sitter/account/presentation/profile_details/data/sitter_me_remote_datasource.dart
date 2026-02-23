import 'package:dio/dio.dart';
import 'sitter_me_dto.dart';

class SitterMeRemoteDataSource {
  final Dio _dio;

  SitterMeRemoteDataSource(this._dio);

  /// GET /sitters/me - Fetch current sitter's profile
  Future<SitterMeResponseDto> getSitterMe() async {
    final response = await _dio.get('/sitters/me');
    return SitterMeResponseDto.fromJson(response.data);
  }
}
