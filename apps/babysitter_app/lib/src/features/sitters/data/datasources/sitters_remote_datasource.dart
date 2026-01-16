import 'package:dio/dio.dart';
import '../models/sitter_dto.dart'; // Adjust path if needed
import '../models/sitter_profile_dto.dart';

// Reusing the dio provider that has AuthInterceptor from BookingsDataDi or similar
// Actually, let's create a simpler provider setup here or reuse global one.
// Let's assume we can get Dio from bookings_data_di for now or create a local provider that uses the same setup.
// To keep it clean, I will just define the class here, and handle DI in a separate DI file or just provider file.

class SittersRemoteDataSource {
  final Dio _dio;

  SittersRemoteDataSource(this._dio);

  Future<List<SitterDto>> fetchSitters({
    int limit = 20,
    int offset = 0,
    // Add filters later
  }) async {
    try {
      final response = await _dio.get(
        '/sitters/browse',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      final data = BrowseSittersResponseDto.fromJson(response.data);
      return data.data.sitters;
    } catch (e) {
      // Log error
      rethrow;
    }
  }

  Future<SitterProfileDto> getSitterDetails(String id) async {
    try {
      final response = await _dio.get('/sitters/$id');
      final data = SitterProfileResponseDto.fromJson(response.data);
      return data.data.profile;
    } catch (e) {
      rethrow;
    }
  }
}
