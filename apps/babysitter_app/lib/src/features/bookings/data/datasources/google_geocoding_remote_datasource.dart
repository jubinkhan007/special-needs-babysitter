import 'package:core/core.dart';
import 'package:dio/dio.dart';

class GoogleGeocodingRemoteDataSource {
  final Dio _dio;
  final Map<String, String> _cache = {};

  GoogleGeocodingRemoteDataSource(this._dio);

  Future<String?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final apiKey = EnvConfig.googleGeocodingApiKey;
    if (apiKey.isEmpty) {
      return null;
    }

    final cacheKey =
        '${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}';
    final cached = _cache[cacheKey];
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    try {
      final response = await _dio.get(
        '/geocode/json',
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': apiKey,
        },
      );
      final results = response.data['results'] as List?;
      final first = results != null && results.isNotEmpty ? results.first : null;
      final address = first is Map<String, dynamic>
          ? first['formatted_address'] as String?
          : null;
      if (address != null && address.isNotEmpty) {
        _cache[cacheKey] = address;
      }
      return address;
    } catch (e) {
      return null;
    }
  }
}
